function [S, PosAmers, ParamFilter, trackerBis, myTracks, PosAmersNew, ...
    IdxAmersNew, trackCov, pointsMain, validityMain] = manageAmers_my(S, ...
    PosAmers, ParamFilter, ParamGlobal, trackerBis, trajFilter, I, ...
    pointsMain, validityMain, IdxImage, myTracks, pointsBis)

% Understand dimensions of input/output parameters
% list input data:
diary manageAmers_my_diary.txt
whos

[S, PosAmers, ParamFilter, trackerBis, myTracks, PosAmersNew, ...
    IdxAmersNew, trackCov, pointsMain, validityMain] = manageAmers(S, ...
    PosAmers, ParamFilter, ParamGlobal, trackerBis, trajFilter, I, ...
    pointsMain, validityMain, IdxImage, myTracks, pointsBis);

% list input and output data:
whos

diary off
