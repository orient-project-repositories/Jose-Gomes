function [ParamGlobal, orb_slam] = mainExperiment_init_orbSlam(ParamFilter, ParamGlobal)

orb_slam.omega_b = [0;0;0];
orb_slam.a_b = [0;0;0];

Slice.tStart = ParamGlobal.tIMU(1);
Slice.tEnd = ParamGlobal.tracks(1,2);

i = 1;
while(ParamGlobal.tracks(1,2) == ParamGlobal.tracks(i+1,2))
    i = i + 1;
end

numStartingFeatures = i;
% totalFeatures = max(ParamGlobal.tracks(:,1));

if numStartingFeatures < ParamGlobal.numFeatures
   return 
end

Slice.slice = ParamGlobal.tracks(1:numStartingFeatures, :);
ParamGlobal.tracks(1:numStartingFeatures, :) = [];

orb_slam.trackerMain = zeros(ParamGlobal.numFeatures,8);
orb_slam.trackerMain(1:ParamGlobal.numFeatures,1:4) = Slice.slice(1:ParamGlobal.numFeatures, :);
Slice.slice(1:ParamGlobal.numFeatures, :) = [];

orb_slam.PosAmers = zeros(3,ParamGlobal.numFeatures);

for i=1:ParamGlobal.numFeatures
    orb_slam.PosAmers(1,i) = (orb_slam.trackerMain(i,3) - ParamFilter.Pi(1,3)) / ParamFilter.Pi(1,1);
    orb_slam.PosAmers(2,i) = (orb_slam.trackerMain(i,4) - ParamFilter.Pi(2,3)) / ParamFilter.Pi(2,2);
    
    orb_slam.PosAmers(3,i) = 1;

end

num_tracks = 200;

for i=1:num_tracks
    orb_slam.myTracks(i) = pointTrack();
end

for i = 1:length(Slice.slice(:,1))
    orb_slam.myTracks(i) = pointTrack(1, Slice.slice(i, 3:4));
end


orb_slam.trackerBis = zeros(num_tracks, 8);
orb_slam.trackerBis(1:length(Slice.slice(:,1)),1:4) = Slice.slice;
ParamGlobal.Slice = Slice;
ParamGlobal.back_Slice = Slice;




