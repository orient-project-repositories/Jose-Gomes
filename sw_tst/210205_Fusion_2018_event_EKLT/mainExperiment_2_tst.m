function mainExperiment_2_tst( dataset, tstId )
if nargin<1
    tstId= 1;
    dataset='ev_rotation_18_y';
end
if nargin<2
    tstId=1;
end

% dataset    = default_value( 'ev_rotation_18_y', options, 'dataset' ); % 1000 Hz

%%% DEFAULTS
eklt.EKLT_BATCH_SIZE = 300;
eklt.EKLT_BLOCK_SIZE = 3;
eklt.EKLT_DISPLACEMENT_PX = 0.6;
eklt.EKLT_LK_WINDOW_SIZE = 20;
eklt.EKLT_MAX_CORNERS = 100;
eklt.EKLT_MAX_NUM_ITERATIONS = 10;
eklt.EKLT_MIN_CORNERS=30;
eklt.EKLT_MIN_DISTANCE = 10;
eklt.EKLT_NUM_PYRAMIDAL_LAYERS = 3;
eklt.EKLT_PATCH_SIZE = 25;
eklt.EKLT_QUALITY_LEVEL = 0.01;
eklt.EKLT_SCALE = 4;
eklt.EKLT_TRACKING_QUALITY = 0.6;

eklt.EKLT_BATCH_SIZE=[50 100 150 200 250 300 350 400 ];
% eklt.EKLT_BLOCK_SIZE = [3 10 20 30 40 50];
% eklt.EKLT_DISPLACEMENT_PX=0.6;
% eklt.EKLT_LK_WINDOW_SIZE=[10 20 30 40];
% eklt.EKLT_MAX_CORNERS=100;
% eklt.EKLT_MAX_NUM_ITERATIONS=10;
% eklt.EKLT_MIN_CORNERS=30;
% eklt.EKLT_MIN_DISTANCE=[5 10 15 20 25 30];
% eklt.EKLT_NUM_PYRAMIDAL_LAYERS=[1 2 3 4 5];
% eklt.EKLT_PATCH_SIZE = [15 20 25 30 35];
% eklt.EKLT_QUALITY_LEVEL=[0.01 0.05 0.1 0.2 0.3 0.4 0.5];
% eklt.EKLT_SCALE=4;
% eklt.EKLT_TRACKING_QUALITY=[0.1 0.3 0.6];

for batches = eklt.EKLT_BATCH_SIZE
    eklt.batches = batches;
for blocks = eklt.EKLT_BLOCK_SIZE
    eklt.blocks = blocks;
for windows = eklt.EKLT_LK_WINDOW_SIZE
    eklt.windows = windows;
for min_dists = eklt.EKLT_MIN_DISTANCE
    eklt.min_dists = min_dists;
for pyr_layers = eklt.EKLT_NUM_PYRAMIDAL_LAYERS
    eklt.pyr_layers = pyr_layers;
for patches = eklt.EKLT_PATCH_SIZE
    eklt.patches = patches;
for quals = eklt.EKLT_QUALITY_LEVEL
    eklt.quals = quals;
for track_quals = eklt.EKLT_TRACKING_QUALITY
    eklt.track_quals = track_quals;
    
%     file_out = strcat('./tracks_batch',batches,'block',blocks,'dispx',EKLT_DISPLACEMENT_PX,'lk',windows,'maxc',EKLT_MAX_CORNERS,'min'.EKLT_MIN_CORNERS,'maxiter',EKLT_MAX_NUM_ITERATIONS,'mindist',min_dists,'pyr',pyr_layers,'patch',patches,'qual',quals,'scale',EKLT_SCALE,'trqual',track_quals,'tracks.txt');
%     command = strcat('export LD_LIBRARY_PATH="/home/jpg/sim_ws/devel/lib:/opt/ros/kinetic/lib:/opt/ros/kinetic/lib/x86_64-linux-gnu";', " roslaunch eklt eklt.launch batch_size:=",batches," block_size:=",blocks," displacement_px:=",EKLT_DISPLACEMENT_PX, " tracks_file_txt:=./tracks.txt v:=0 &"]);
%     [status,cmdout] = system(['export LD_LIBRARY_PATH="/home/jpg/sim_ws/devel/lib:/opt/ros/kinetic/lib:/opt/ros/kinetic/lib/x86_64-linux-gnu";' 'roslaunch eklt eklt.launch batch_size='batches'} block_size:=${blocks} displacement_px:=${EKLT_DISPLACEMENT_PX} lk_window_size:=${windows} max_corners:=${EKLT_MAX_CORNERS} min_corners:=${EKLT_MIN_CORNERS} max_num_iterations:=${EKLT_MAX_NUM_ITERATIONS} min_distance:=${min_dists} num_pyramidal_layers:=${pyr_layers} patch_size:=${patches} quality_level:=${quals} scale:=${EKLT_SCALE} tracking_quality:=${track_quals} tracks_file_txt:=./tracks.txt v:=0 & echo $!']);
    exp = 'export LD_LIBRARY_PATH="/home/jpg/sim_ws/devel/lib:/opt/ros/kinetic/lib:/opt/ros/kinetic/lib/x86_64-linux-gnu";';
    command = sprintf('roslaunch eklt eklt.launch batch_size:=%f block_size:=%f displacement_px:=%f lk_window_size:=%f max_corners:=%f} min_corners:=%f max_num_iterations:=%f min_distance:=%f num_pyramidal_layers:=%f patch_size:=%f quality_level:=%f scale:=%f tracking_quality:=%f tracks_file_txt:=/home/MSc/GIT_MSc/sw_tst/210205_Fusion_2018_event_EKLT/tracks.txt v:=0 & echo $!', batches, blocks, eklt.EKLT_DISPLACEMENT_PX, windows, eklt.EKLT_MAX_CORNERS, eklt.EKLT_MIN_CORNERS, eklt.EKLT_MAX_NUM_ITERATIONS, min_dists, pyr_layers, patches, quals, eklt.EKLT_SCALE, track_quals);

    [status,cmdout] = system([exp command]);

    pause(5);
    
    bag_cmd = strcat('rosbag play /home/MSc/data/Rosbags/', dataset(4:end), '.bag /cam0/image_raw:=/dvs/image_raw /cam0/events:=/dvs/events &');
    
    system([exp bag_cmd ]);
    pause(120);
    system("pkill roslaunch");
    
    switch tstId
        case 0, mainExperiment_2( dataset, eklt )

        case 1
            for freqCam= [50 100 200 400]
                opt= struct('freqCam', freqCam );
                mainExperiment_2( dataset, eklt, opt);
                clc;
            end
         case 2
            for freqCam= [50 100 200 400]
                opt= struct('freqCam', freqCam , 'NbStepsMax', 400);
                mainExperiment_2( dataset, eklt, opt );
            end   
        otherwise
            error('inv tstId')
    end
end
end
end
end
end
end
end
end

end


function ret= default_value( defaultOpt, options, optName )
if isfield(options, optName)
    ret= getfield( options, optName );
else
    ret= defaultOpt;
end

end

function LaunchEKLT()
    [status,cmdout] = system(['export LD_LIBRARY_PATH="/home/jpg/sim_ws/devel/lib:/opt/ros/kinetic/lib:/opt/ros/kinetic/lib/x86_64-linux-gnu";' 'roslaunch eklt eklt.launch tracks_file_txt:=./tracks.txt v:=0 & echo $!']);
    pause(5);
    system(['export LD_LIBRARY_PATH="/home/jpg/sim_ws/devel/lib:/opt/ros/kinetic/lib:/opt/ros/kinetic/lib/x86_64-linux-gnu";' 'rosbag play /home/MSc/data/Rosbags/rotation_18_y.bag /cam0/image_raw:=/dvs/image_raw /cam0/events:=/dvs/events &']);
    pause(30);
    system("pkill roslaunch");
end


function myCleanupFun(cmdout)
    system('kill',cmdout)
end