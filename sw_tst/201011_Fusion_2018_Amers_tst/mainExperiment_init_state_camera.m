function [ParamFilter, state_camera_struct] = mainExperiment_init_state_camera

% Init Filter
P0amers = diag([1;1;1]*1.e-3); %initial landmark covariance
R = 1.0^2*eye(2); %measurement noise for one landmark
ParamFilter.NbAmers = 30; %nominal number of landmarks in the state
ParamFilter.NbAmersMin = ParamFilter.NbAmers;
ParamFilter.EcartPixelMax = 20;

% init covariance
p0Rot = (0.01*pi/180)^2;
p0v =  1.e-4;
p0x =  1.e-8;
p0omegab = 1.e-6;
p0ab = 1.e-6;
P0 = diag([p0Rot*ones(3,1);p0v*ones(3,1);p0x*ones(3,1);...
    p0omegab*ones(3,1);p0ab*ones(3,1)]);
%%

% process noises
q_omega = (1.6968e-4)^2*200;
q_a = (2e-3)^2*200;
q_omegab = (1.9393e-5)^2*200;
q_ab = (3e-3)^2*200;
Q = diag([q_omega*ones(3,1);q_a*ones(3,1);q_omegab* ...
    ones(3,1);q_ab*ones(3,1)]);
Qc = chol(Q);
P0 = blkdiag(P0,kron(eye(ParamFilter.NbAmers),P0amers));

%%

%depending on the chosen camera %cam0
ParamFilter.chiC = [0.0148655429818, -0.999880929698, 0.00414029679422, -0.0216401454975;
    0.999557249008, 0.0149672133247, 0.025715529948, -0.064676986768;
    -0.0257744366974, 0.00375618835797, 0.999660727178, 0.00981073058949;
    0.0, 0.0, 0.0, 1.0]; % camera pose // extrinsics
ParamFilter.Pi = [458.654 0 0; 0 457.296 0; 367.215, 248.375 1]';%camera calibration matrix
ParamFilter.cameraParams = cameraParameters('IntrinsicMatrix', ParamFilter.Pi',...
    'RadialDistortion',[-0.28340811, 0.07395907],...
    'TangentialDistortion',[0.00019359, 1.76187114e-05]);


state_camera_struct.P0 = P0;
state_camera_struct.Q = Q;
state_camera_struct.Qc = Qc;
state_camera_struct.R = R;