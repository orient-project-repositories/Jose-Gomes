function event_frame_tst()

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
vars.radius = 5;

vars.ransac.on = 1;
vars.ransac.outlierPer          = 0.70; 
vars.ransac.goodMatches         = round(vars.maxMatches*0.5);
vars.ransac.maxErr              = 0.001;   % in meters

cameraParams = cameraParameters('IntrinsicMatrix', vars.intrinsics', 'RadialDistortion', vars.radialDist, 'TangentialDistortion', vars.tanDist); 
I = [1 0 0; 0 1 0; 0 0 1];

img1 = imread('../../data/rotation_18_y/images/frame0000.jpg');
img2 = imread('../../data/rotation_18_y/images/frame0001.jpg');

img1 = rgb2gray(img1);
img2 = rgb2gray(img2);

uimg1 = undistortImage(img1, cameraParams);
uimg2 = undistortImage(img2, cameraParams);



p1 = detectSURFFeatures(uimg1, 'MetricThreshold', 100);
p2 = detectSURFFeatures(uimg2, 'MetricThreshold', 100);

[f1, vpts1] = extractFeatures(uimg1, p1);
[f2, vpts2] = extractFeatures(uimg2, p2);
matches = matchFeatures(f1, f2, 'Method', 'Exhaustive', 'Unique', true, 'MatchThreshold', 100);
m1a = vpts1(matches(:,1));
m2a = vpts2(matches(:,2));
[m1, m2, err, ~] = ransacByProcrustes(m1a.Location', m2a.Location', vars.intrinsics, vars.radius, vars.minMatches, vars.maxMatches, vars.ransac);

%figure; showMatchedFeatures(uimg1, uimg2, m1a.Location, m2a.Location); 
figure; showMatchedFeatures(uimg1, uimg2, m1', m2'); 

%m1 = double(m1a.Location');
%m2 = double(m2a.Location');

% vars.nMatches = 20;
% vars.currDistToCam.max = vars.radius;
% vars.currDistToCam.min = 0.05;
% R = eul2rotm(-rotm2eul(Rgt));
% T = (R-I)*vars.currBaseline;
% [Mw, M1, M2, m1, m2, err] = simulator(vars.nMatches, R, T, vars.currDistToCam.max, vars.currDistToCam.min, vars.currBaseline, vars.intrinsics, vars.imgDim);

[Roppr, T] = orthProcrustesProb(m1, m2, vars.radius, vars.intrinsics);
-rotm2eul(Roppr)*180/pi
% [Rmbpe, T] = minBackProject(m1, m2, vars.currBaseline, rotm2eul(Roppr), vars.radius, vars.intrinsics); 
% -rotm2eul(Rmbpe)*180/pi
[Rgrat, T] = minEpipolarGradient(m1, m2, vars.currBaseline, vars.intrinsics, rotm2eul(Roppr));
-rotm2eul(Rgrat)*180/pi

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