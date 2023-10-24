function mainExperiment_2( dataset, eklt, options )
if nargin<1
    dataset = 'ev_boxes_rotation';
end
if nargin<2
    options= [];
end

% dataset = 'ev_rotation_18_y';
% freqIMU = 1000; %Hz
% freqCam = 50; %Hz
% numFeatures = 20;
% offset = 1; % groundtruth offset - Should be synchronized
% tMin = 1; % starting IMU time - Should be synchronized
% tImagesMin = 1; % starting camera time - For events set to 1
% NbStepsMax = 4000;

freqIMU    = default_value( 1000, options, 'freqIMU' ); % 1000 Hz
freqCam    = default_value(  50, options, 'freqCam' ); % 50 %Hz
numFeatures= default_value(   20, options, 'numFeatures' ); % 20;
offset     = default_value(    1, options, 'offset' );
tMin       = default_value(    1, options, 'tMin' );
tImagesMin = default_value(    1, options, 'tImagesMin' );
NbStepsMax = default_value( 59735, options, 'NbStepsMax' );

% check if this works, choosing the dataId in this main file:
% global dataId
% %dataId= 'ev_shapes_rotation';
% dataId= 'ev_boxes_rotation';
neurocams3_data( dataset ); % save internaly the "dataId"
[ParamGlobal, IMU_img_struct] = mainExperiment_init_IMU_v2(tMin, tImagesMin);

ParamGlobal.tolerance = 0.5;

ParamGlobal.freqIMU = freqIMU; 
ParamGlobal.freqCam = freqCam;
ParamGlobal.PerCam = 1/freqCam;
ParamGlobal.PerIMU = 1/freqIMU;
ParamGlobal.numFeatures = numFeatures;

[IMU_img_struct.tReal, IMU_img_struct.trajReal] = mainExperiment_correct_offset(IMU_img_struct.tReal, IMU_img_struct.trajReal, offset);

[ParamFilter, state_camera_struct] = mainExperiment_init_state_camera(ParamGlobal);

%%
% Initialisation of the state is obtained following [Mur-Artal,2017],
% orb_slam = load('data/ORB_SLAM_init.mat');
% orb_slam = orb_slam.orb_slam;

[ParamGlobal, orb_slam] = mainExperiment_init_orbSlam(ParamFilter, ParamGlobal);

%obsTimes = mainExperiment_define_obsTimes(IMU_img_struct.tIMU, ParamGlobal);
obsTimes = 0;
% obsTimes(:)=0;
% obsTimes = zeros(length(IMU_img_struct.t),1);
% obsTimes(1:round(freqIMU/freqCam):end) = 1;


% mainExperiment_map_init_tst(tracker, ParamFilter, ParamGlobal, initHelper)%
% trackerTest(ParamGlobal, orb_slam, ParamFilter);

%%%REMOVER ORBSLAM, E SO PARA AJUDAR NO DEBUG
[orb_slam, trajs, i] = mainExperiment_loop(orb_slam, IMU_img_struct, state_camera_struct, NbStepsMax, ParamFilter, ParamGlobal);

%% Plots
%replace with relevant fucntions
helperSaveData(trajs, dataset, ParamGlobal, eklt);
% mainExperiment_plot(trajs, i, IMU_img_struct.trajReal, IMU_img_struct.t)

return % end of main function


function ret= default_value( defaultOpt, options, optName )
if isfield(options, optName)
    ret= getfield( options, optName );
else
    ret= defaultOpt;
end
