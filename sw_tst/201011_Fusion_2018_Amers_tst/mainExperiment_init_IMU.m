function [ParamGlobal, IMU_img_struct] = mainExperiment_init_IMU(tMin, tImagesMin)

ParamGlobal.dirImage = 'C:\MSc\git\FUSION2018\data\mav0\cam0\data\';
fileData = 'DATA_MEDIUM.mat';
fileImages = 'fileImages_MEDIUM.mat';

% IMU and frame date
fileData = load(fileData);

tIMU = fileData.tIMU;
omega = fileData.omega;
acc = fileData.acc;
tReal = fileData.tReal;
trajReal = fileData.trajReal;

t = tIMU;
t = t/10^9; % ns -> s
g = 9.81*[0;0;-1]; %gravity field
omega = omega(:,tMin:end);
acc = acc(:,tMin:end);
t = t(tMin:end);
tIMU = tIMU(tMin:end);
ParamGlobal.tIMU = tIMU;
NbSteps = length(tIMU);

fileImages = load(fileImages); 
tImages = fileImages.tImages(tImagesMin:end);
fileImages = fileImages.fileImages(tImagesMin:end);
ParamGlobal.fileImages = fileImages;

IMU_img_struct.tIMU = tIMU;
IMU_img_struct.t = t;
IMU_img_struct.acc = acc;
IMU_img_struct.omega = omega;
IMU_img_struct.NbSteps = NbSteps;
IMU_img_struct.tImages = tImages;
IMU_img_struct.tReal = tReal;
IMU_img_struct.trajReal = trajReal;
IMU_img_struct.g = g;
