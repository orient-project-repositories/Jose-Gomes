function orb_slam = mainExperiment_init_orbSlam(ParamFilter, ParamGlobal)

num_tracks = 200;

orb_slam.omega_b = [0;0;0];
orb_slam.a_b = [0;0;0];

cameraParams = ParamFilter.cameraParams;
dirImage = ParamGlobal.dirImage;
fileImages = ParamGlobal.fileImages;
<<<<<<< HEAD
image = fileImages{1};
image = undistortImage(imread(image),cameraParams);
=======
% image = fileImages{1};
% % image = strcat(dirImage,'images\frame_00000000.png');
% image = undistortImage( imread(image),cameraParams);
image = undistortImage( imread( [dirImage fileImages{1}] ), cameraParams );
>>>>>>> d0c4368c63852f879db05aafa81645bb00954526

init_points = detectMinEigenFeatures(image); %detetar novos pontos de interesse
init_points = selectUniform(init_points,num_tracks+30,size(image)); %selcioanr novos potnos

for i=1:num_tracks
    orb_slam.myTracks(i) = pointTrack(1, init_points(i).Location);
end

orb_slam.trackerBis = vision.PointTracker('MaxBidirectionalError',1);
initialize(orb_slam.trackerBis,init_points(1:num_tracks).Location,image);

init_points = init_points(201:end);% = selectUniform(init_points,30,size(image)); %selcioanr novos potnos

orb_slam.trackerMain = vision.PointTracker('MaxBidirectionalError',1);
initialize(orb_slam.trackerMain,init_points.Location,image);

orb_slam.PosAmers = zeros(3,30);

for i=1:30
    orb_slam.PosAmers(1,i) = init_points.Location(i,1) / ParamFilter.Pi(1,1);
    orb_slam.PosAmers(2,i) = init_points.Location(i,2) / ParamFilter.Pi(2,2);
    orb_slam.PosAmers(3,i) = 1;

end


