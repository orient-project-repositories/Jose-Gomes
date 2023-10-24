function event_frame_tracker_tst()

% calib_fileID = fopen( neurocams3_data([], 'calib.txt'), 'r' );
% calib_param = fscanf(calib_fileID,'%f %f %f %f %f %f %f %f %f');
% fx = calib_param(1);
% fy = calib_param(2);
% cx = calib_param(3);
% cy = calib_param(4);
% 
% k1 = calib_param(5);
% k2 = calib_param(6);
% p1 = calib_param(7);
% p2 = calib_param(8);
% 
% ParamFilter.Pi = [fx 0 0; 0 fy 0; cx, cy 1]';%camera calibration matrix
% ParamFilter.cameraParams = cameraParameters('IntrinsicMatrix', ParamFilter.Pi',...
%     'RadialDistortion',[k1, k2],...
%     'TangentialDistortion',[p1, p2]);

vars.intrinsics = [200      0     120;
                     0		200   90;
                     0      0     1   ];
vars.tanDist = [0 0];
vars.radialDist = [0 0 0];

vars.minMatches = 3;
vars.maxMatches = 100;
vars.radius = 1;


cameraParams = cameraParameters('IntrinsicMatrix', vars.intrinsics', 'RadialDistortion', vars.radialDist, 'TangentialDistortion', vars.tanDist); 

Images = readtable( '../../data/ev_rotation_18_y/images.txt' );
tImages = table2array(Images(:,1));
fileImages = table2array(Images(:,2));

loc= sprintf('/home/MSc/data/Texts/rotation_18_y_hs/%s', fileImages{1});

img1 = imread(loc);
img1 = undistortImage(img1, cameraParams);
points1 = detectMinEigenFeatures(img1);
tracker = vision.PointTracker('MaxBidirectionalError',1);
initialize(tracker,points1.Location,img1);

features_loc = cell(length(fileImages) - 1, 1);
features_val = cell(length(fileImages) - 1, 1);

features_loc{1} = points1.Location;
features_val{1} = 1;
% 
% pointImage = insertMarker(img1,points1.Location,'+','Color','white');
% figure;
% imshow(pointImage);

rots = cell(length(fileImages) - 1, 1);

for i = 2:length(fileImages)
    loc= sprintf('/home/MSc/data/Texts/rotation_18_y_hs/%s', fileImages{i});

    img = imread(loc);
    img = undistortImage(img, cameraParams);
    [points,validity] = tracker(img);
    

    
    validity(points(:,1)<=0) = 0;
    validity(points(:,2)<=0) = 0;
    points(points(:)<=0) = 1;
    
    features_loc{i} = points;
    features_val{i} = validity;
    
    if(length(find(validity)) < vars.minMatches)
        points = detectMinEigenFeatures(img);
        release(tracker);
        initialize(tracker,points.Location,img);
        
        %reset da referencia INCOMPLETO
        
    else
        setPoints(tracker, points, validity);
    end
    
    [Roppr, T] = orthProcrustesProb(points1.Location', points', vars.radius, vars.intrinsics);
    rots{i-1} = Roppr;
    
end

ang = zeros(length(fileImages) - 1,3);
for i = 1:length(fileImages) - 1
    ang(i,:) = -rotm2eul(rots{i})*180/pi;
end

ground = readmatrix('/home/MSc/data/Texts/rotation_18_y_hs/groundtruth.txt');
quats = [ground(:,8),ground(:,5),ground(:,6),ground(:,7)];
eul = quat2eul(quats)*180/pi;

figure;
plot(ang(:,3));
hold on
plot(ang(:,2));
plot(ang(:,1));
figure;
plot(eul(:,3));
hold on;
plot(eul(:,2));
% plot(eul(:,1));



figure; showMatchedFeatures(img1, img2, points1.Location, points2); 


[Roppr, T] = orthProcrustesProb(points1.Location', points2', vars.radius, vars.intrinsics);
-rotm2eul(Roppr)*180/pi

rreal = rotm2eul(Rgt);
treal = t1-t2;
eR(1) = norm((-rotm2eul(Roppr))-rreal)*180/pi;
eR(2) = norm((-rotm2eul(Rmbpe))-rreal)*180/pi;
eT(2) = norm(T-treal);
eR(3) = norm((-rotm2eul(Rgrat))-rreal)*180/pi;
eT(3) = norm(T-treal);

sections = zeros(6, 6);
entropy = zeros(4, 1);
nentropy = zeros(2, 1);
maxeR = max(eR);
if(maxeR < vars.entropyThreshold) 
    sections(1:3, 1:3) = whichImageSections(m1, vars.imgDim);
    sections(1:3, 4:6) = whichImageSections(m2, vars.imgDim);
    entropy(1) = entropy(1) + findEntropy(sections(1:3, 1:3));
    entropy(2) = entropy(2) + findEntropy(sections(1:3, 4:6));
    nentropy(1) = nentropy(1) + 1;
else
    sections(4:6, 1:3) = whichImageSections(m1, vars.imgDim);
    sections(4:6, 4:6) = whichImageSections(m2, vars.imgDim);
    entropy(3) = entropy(3) + findEntropy(sections(4:6, 1:3));
    entropy(4) = entropy(4) + findEntropy(sections(4:6, 4:6));
    nentropy(2) = nentropy(2) + 1;
end

entropy(1) = entropy(1)/nentropy(1);
entropy(2) = entropy(2)/nentropy(1);
entropy(3) = entropy(3)/nentropy(2);
entropy(4) = entropy(4)/nentropy(2);

fprintf('Error per method in degrees:\n OPPR %f\n MBPE %f\n GRAT %f\n', eR(1), eR(2), eR(3));
fprintf('Entropy < 3 degrees: %f and %f\n', entropy(1), entropy(2));
fprintf('Entropy > 3 degrees: %f and %f\n', entropy(3), entropy(4));






end