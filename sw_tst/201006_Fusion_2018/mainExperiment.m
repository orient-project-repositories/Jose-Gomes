function mainExperiment

freqIMU = 200; %Hz
freqCam = 20; %Hz

offset = 881;
tMin = 1081; % starting IMU time
tImagesMin = 109; % starting camera time

NbStepsMax = 8000;

[ParamGlobal, IMU_img_struct] = mainExperiment_init_IMU(tMin, tImagesMin);

[IMU_img_struct.tReal, IMU_img_struct.trajReal] = mainExperiment_correct_offset(IMU_img_struct.tReal, IMU_img_struct.trajReal, offset);

obsTimes = zeros(length(IMU_img_struct.t),1);
obsTimes(1:(freqIMU/freqCam):end) = 1; % IMU is 10 times faster than camera

[ParamFilter, state_camera_struct] = mainExperiment_init_state_camera;

%%
% Initialisation of the state is obtained following [Mur-Artal,2017],
orb_slam = load('data/ORB_SLAM_init.mat');
orb_slam = orb_slam.orb_slam;

[trajs, i] = mainExperiment_loop(orb_slam, IMU_img_struct, state_camera_struct, NbStepsMax, obsTimes, ParamFilter, ParamGlobal);

%% Plots
mainExperiment_plot(trajs, i, IMU_img_struct.trajReal, IMU_img_struct.t)

