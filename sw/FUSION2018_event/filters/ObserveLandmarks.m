function [y,yAmers,trackerMain,trackerBis,pointsMain,validityMain,myTracks,pointsBis, ParamGlobal] = ...
    ObserveLandmarks(trackerMain,trackerBis,dirImage,IdxImage,...
    fileImages,ParamFilter,Rot,x,PosAmers,I,S,myTracks, ParamGlobal)
%% trackerMain
cameraParams = ParamFilter.cameraParams;
chiC = ParamFilter.chiC;
RotC = chiC(1:3,1:3);
xC = chiC(1:3,4);
Pi = ParamFilter.Pi; 

ParamGlobal.Slice.tStart = ParamGlobal.Slice.tEnd;
ParamGlobal.Slice.tEnd = ParamGlobal.Slice.tStart + ParamGlobal.PerCam;

i = 1;
size_stopper = length(ParamGlobal.tracks(:,2));

%%%METER PROTECAO CASO NAO HAJA TRACKS
if(isempty(ParamGlobal.tracks))
    ParamGlobal.Slice.slice = [];
    y = []; %posicoes dos pixeis - td numa so coluna 
    yAmers = [];
    pointsMain = [];
    validityMain = [];
    pointsBis = [];
    return
end


while(ParamGlobal.tracks(i,2) < ParamGlobal.Slice.tEnd)
    if i == size_stopper
        break
    else
        i = i + 1;
    end
end

ParamGlobal.Slice.slice = ParamGlobal.tracks(1:i, :);
ParamGlobal.tracks(1:i, :) = [];

%%%Backup of previous tracks (foi razTrackerBis)
ParamGlobal.back_Slice = [ParamGlobal.back_Slice; ParamGlobal.Slice];


%%%%ACABAR ISTO; SELECIONAR FEATURES RELEVANTES
%%%ORDENACAO DUPLA, ESCOLHER ULTIMOS ELEMENTOS
[~,idx] = sort(ParamGlobal.Slice.slice(:,2)); % sort just the first column
ParamGlobal.Slice.slice = ParamGlobal.Slice.slice(idx,:);
[~,idx] = sort(ParamGlobal.Slice.slice(:,1)); % sort just the first column
ParamGlobal.Slice.slice = ParamGlobal.Slice.slice(idx,:);

% if I>500 && I<1500
%    ,pointsMain,,,pointsBis,
%     y = []; %zeros(2*sum(validityMain),1);
%     yAmers = []; %zeros(sum(validityMain),1);
%     validityMain = [];
%     return
% end

%Keep the last values of each ID
[a, b, c] =  unique(ParamGlobal.Slice.slice(:,1),'last');
ParamGlobal.Slice.slice = ParamGlobal.Slice.slice(b,:);

% orb_slam.trackerMain = Slice.slice(1:ParamGlobal.numFeatures, :);
% Slice.slice(1:ParamGlobal.numFeatures, :) = [];

% image = strcat(dirImage,int2str(fileImages(IdxImage)),'.png');
% dirImage = neurocams3_data( [], struct('retJustPath',1) );
% image = strcat(dirImage,fileImages{IdxImage});
% image = undistortImage(imread(image),cameraParams);

% Give "true" if the element in "a" is a member of "b".
c = ismember(ParamGlobal.Slice.slice(:,1), trackerMain(:,1));
% Extract the elements of a at those indexes.
%indices = find(c);

subset = ParamGlobal.Slice.slice(c,:);
%%%%fazer finds individualmente
j = 1;
trackerMain(:,8) = 0;
for i = subset(:,1)'
    d = ismember(trackerMain(:,1), i);
    % Extract the elements of a at those indexes.
%     idx = find(d);
    trackerMain(d,5:7) = trackerMain(d,2:4);
    trackerMain(d,1:4) = subset(j,:);
    trackerMain(d,8) = 1;
    j = j + 1;
end

pointsMain = trackerMain(:,3:4);
validityMain = trackerMain(:,8);

% [pointsMain,validityMain] = trackerMain.step(image); %usa o tracker para seguir os pontos
% validityMain(pointsMain(:,1)<=0) = 0;
% validityMain(pointsMain(:,2)<=0) = 0;
% pointsMain(pointsMain(:)<=0) = 1;

y = zeros(2*sum(validityMain),1);
yAmers = zeros(sum(validityMain),1);
EcartPixelMax = ParamFilter.EcartPixelMax;
EcartPixelOut = EcartPixelMax;
j = 1;

for i = 1:length(validityMain)
    if validityMain(i) == 1
        PosAmers_i = PosAmers(:,i);
        pointsEst = Pi*( (Rot*RotC)' * (PosAmers_i-(x+Rot*RotC*xC)) );
        pixelEst = pointsEst(1:2)/pointsEst(3);
        if norm(pixelEst-pointsMain(i,:)') < EcartPixelMax %reject outlier
            y(2*j-1:2*j) = pointsMain(i,:)';
            yAmers(j) = i;
            j = j+1;
        else %if norm(pixelEst-pointsMain(i,:)') > EcartPixelOut
            validityMain(i) = 0;
        end
    end
end
y(2*j-1:end) = []; %posicoes dos pixeis - td numa so coluna 
yAmers(j:end) = []; %ids

%for landmarks too close to each others
for ii = 1:2
    
    %%%% TESTE PARA FRAME RATES MT ELEVADOS
    if isempty(find(validityMain, 1))
       break 
    end
    
    idx = randsample(find(validityMain == 1),1);
    pointIdx = pointsMain(idx,:);
    mMin = 10;
    mDis = (mMin+1)*ones(ParamFilter.NbAmers,1);
    for i = 1:length(validityMain)
        if validityMain(i) == 1 && i ~= idx
            pointI = pointsMain(i,:);
            mDis(i)= norm(pointIdx-pointI);
        end
    end
    [mDis,idx2] = min(mDis);
    if mDis < mMin % remove the most uncertain location
        idxS = 15+(3*idx-2:3*idx);
        idxS2 = 15+(3*idx2-2:3*idx2);
        S1 = sum(diag(S(idxS,idxS)));
        S2 = sum(diag(S(idxS2,idxS2)));
        if S2 > S1
            idx = idx2;
        end
        validityMain(idx) = 0;
    end
end

for i = 1:length(validityMain)
    if trackerMain(i,2) + ParamGlobal.tolerance > ParamGlobal.Slice.tEnd
        validityMain(idx) = 1; %%%% TORNAR VALIDO AQUI PARA NAO SER SUBSTITUIDO PELO MANAGEAMERS 
    end
end

%% trackerBis

c = ismember(ParamGlobal.Slice.slice(:,1), trackerBis(:,1));
% Extract the elements of a at those indexes.
%indices = find(c);

subset = ParamGlobal.Slice.slice(c,:);
%%%%fazer finds individualmente
j = 1;
for i = subset(:,1)'
    d = ismember(trackerBis(:,1), i);
    % Extract the elements of a at those indexes.
%     idx = find(d);
    trackerBis(d,5:7) = trackerBis(d,2:4);
    trackerBis(d,1:4) = subset(j,:);
    trackerBis(d,8) = 1;
    j = j + 1;
end

%             for i = subset(:,1)'
%                 d = ismember(trackerMain(:,1), i);
%                 % Extract the elements of a at those indexes.
%             %     idx = find(d);
%                 trackerMain(d,5:7) = trackerMain(d,2:4);
%                 trackerMain(d,1:4) = subset(j,:);
%                 trackerMain(d,8) = 1;
%                 j = j + 1;
%             end

pointsBis = trackerBis(:,3:4);
validityBis = trackerBis(:,8);

% [pointsBis,validityBis] = trackerBis.step(image);
% validityBis(pointsBis(:,1)<=0) = 0;
% validityBis(pointsBis(:,2)<=0) = 0;
% pointsBis(pointsBis(:)<=0) = 1;

mMin = 4;
for ii = 1:5
    
        %%%% TESTE PARA FRAME RATES MT ELEVADOS
    if isempty(find(validityBis, 1))
       break 
    end
    
    idx = randsample(find(validityBis == 1),1);
    pointIdx = pointsBis(idx,:);
    mDis = (mMin+1)*ones(ParamFilter.NbAmers,1);
    for i = 1:length(validityBis)
        if validityBis(i) == 1 && i ~= idx
            pointI = pointsBis(i,:);
            mDis(i)= norm(pointIdx-pointI);
        end
    end
    [mDis,idx2] = min(mDis);
    if mDis < mMin
        nbView1 = length(myTracks(idx).ViewIds);
        nbView2 = length(myTracks(idx2).ViewIds);
        if nbView2 < nbView1
            idx = idx2;
        end
        validityBis(idx) = 0;
    end
end

%%%TAKE CARE OF THIS RESET PART
c = ismember(ParamGlobal.Slice.slice(:,1), trackerMain(:,1));
ParamGlobal.Slice.slice(c,:) = [];
c = ismember(ParamGlobal.Slice.slice(:,1), trackerBis(:,1));
ParamGlobal.Slice.slice(c,:) = [];
[a, b, c] =  unique(ParamGlobal.Slice.slice(:,1),'last');
ParamGlobal.Slice.slice = ParamGlobal.Slice.slice(b,:);
Newpoints = ParamGlobal.Slice.slice;

% Newpoints = detectMinEigenFeatures(image);
% Newpoints = selectUniform(Newpoints,sum(validityBis == 0)+30,size(image));
for i = 1:length(validityBis)
    if validityBis(i) == 1
        myTracks(i).ViewIds = [myTracks(i).ViewIds I];
        myTracks(i).Points  =  [myTracks(i).Points;pointsBis(i,:)];
    elseif validityBis(i) == 0
        
        %%% dont immediatelly ignore point if not detected, as this happens
        %%% always
        if trackerBis(i,2) + ParamGlobal.tolerance > ParamGlobal.Slice.tEnd && trackerBis(i,1) ~= 0
            continue
        end
        
        %%%%%%NOT YET DEBUGGED!!!!!!!
        if isempty(Newpoints)
            continue 
        end
        
        myTracks(i).ViewIds = I;
%         if isempty(Newpoints)
%             Newpoints = detectMinEigenFeatures(image);
%             Newpoints = selectUniform(Newpoints,sum(validityBis == 0)+30,size(image));
%         end
        j = randi(length(Newpoints(:,1)),1);
        location = Newpoints(j,3:4);
        myTracks(i).Points = location;
        pointsBis(i,:) = location;
        
        %%%Acrescentar ao TrackerBis, que nao da para fazer setpoints
        trackerBis(i,1:4) = Newpoints(j,:);

        Newpoints(j,:) = [];


    end
end
% trackerBis.setPoints(pointsBis);
end

