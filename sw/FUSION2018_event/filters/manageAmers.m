function [S,PosAmers,ParamFilter,trackerBis,myTracks,PosAmersNew,...
    IdxAmersNew,trackCov,pointsMain,validityMain, trackerMain] = manageAmers(S,...
    PosAmers,ParamFilter,ParamGlobal,trackerBis,trajFilter,I,...
    pointsMain,validityMain,IdxImage,myTracks,pointsBis, trackerMain)

PosAmersNew = [];
IdxAmersNew = [];
trackCov = [];
MaxAmersNew = 10;

minIMUReadings = 600;

if sum(validityMain) < ParamFilter.NbAmersMin && I>minIMUReadings
    P = S'*S; %not computianny efficient
    
    for iii = 1:length(validityMain)
        if trackerMain(iii,8) == 0 && trackerMain(iii,2) + ParamGlobal.tolerance > ParamGlobal.Slice.tEnd
            validityMain(iii) = 1;
        end
    end
    NbAmersNew = min(sum(validityMain == 0),MaxAmersNew); %saber qts landmarks nonvos sao precisos
    
    [PosAmersNew,trackPoints,trackerBis,myTracks,trackCov, trackerHelper] = ObserveAmersNew(ParamFilter,ParamGlobal,...
        trajFilter,I,IdxImage,trackerBis,myTracks,NbAmersNew,pointsMain,pointsBis,S); %escolher novos landmarks
    
    j = 1;
    IdxAmersNew = zeros(length(trackCov),1);
    IdxAmersOld = find(validityMain == 0); %localizacao de landmarks a substituir
    %if number of new landmarks is small
    IdxAmersOld = IdxAmersOld(1:length(trackCov)); %que raio?? esta a restringir caso nao tenha landmarks novas suficientes??
                                            %%%acho que e isso, ajuda me
                                            %%%neste caso
    
    for ii = 1:length(IdxAmersOld)
        idxAmersOld = IdxAmersOld(ii);
        idxP = 15+(3*idxAmersOld-2:3*idxAmersOld); %indices do landamrk a substituir (3 valores)
        P(:,idxP) = 0; %reset as covs da landmark
        P(idxP,:) = 0;
        P(idxP,idxP) = trackCov{j}; %inicializa com as covs da nova landamark
        PosAmers(:,idxAmersOld) = PosAmersNew(j,:)';  %incicializa a posicao da nova landmark
        pointsMain(idxAmersOld,:) = trackPoints(:,j); %!!!pointsAmers tem localizacao das features!!! inicia as featires novas a fazer track
        
        %%%%VERIFICAR 
        trackerMain(idxAmersOld,1:4) = trackerHelper(ii,1:4);
        trackerMain(idxAmersOld,8) = 1;

        validityMain(idxAmersOld) = 1; %validaity a 1
        IdxAmersNew(j) = idxAmersOld; %retorna os indices dos novos landmarks
        j = j+1;
    end
    if sum(pointsMain(:) < 0) > 0 %invalida pontos errados
        validityMain(pointsMain(:,1)<0) = 0;
        validityMain(pointsMain(:,2)<0) = 0;
        pointsMain(pointsMain(:)<0) = 1;
    end
    
    %%%%%%POR TRACKERMAIN AQUI ALGURES
    %%%PUS EM CIMA A VER SE DA
    
    S = chol(P); %not computianny efficient
end
end

%--------------------------------------------------------------------------
function [posAmersNew,trackPoints,trackerBis,myTracks,trackCov, trackerHelper] = ...
    ObserveAmersNew(ParamFilter,ParamGlobal,trajFilter,...
    I,IdxImage,trackerBis,myTracks,NbAmersNew,pointsMain,pointsBis,S)
% compute estimated locations for new landmarks
cameraParams = ParamFilter.cameraParams;

trackerHelper = [];

%%%%%MUDAR AQUI PARA REMOVER IMAGENS
% dirImage = ParamGlobal.dirImage;
% fileImages = ParamGlobal.fileImages;
% image = strcat(dirImage,int2str(fileImages(IdxImage)),'.png');
% dirImage = neurocams3_data( [], struct('retJustPath',1) );
% image = strcat(dirImage,fileImages{IdxImage});
% image = undistortImage(imread(image),cameraParams);
% 
% Newpoints = detectMinEigenFeatures(image); %detetar novos pontos de interesse
% Newpoints = selectUniform(Newpoints,NbAmersNew+150,size(image)); %selcioanr novos potnos
 
%number of views of candidate points
nbViews = zeros(1,length(myTracks));
for i = 1:length(myTracks)
    nbViews(i) = length(myTracks(i).ViewIds); %%% ESTE PASSO ESTA MEGA CONFUSO
                                            %%% ja esta claro - ir buscar
                                            %%% ao mytracks as features que
                                            %%% tem sido mais vistas
end

% tracking new points
posAmersNew = zeros(NbAmersNew,3);
trackPoints = ones(2,NbAmersNew);
trackCov = {}; %cell(NbAmersNew,1); %%%CENAS QUE MUDEI
i = 1;
nbViewsMin = 4;
errorMax = 0.5;
PixelMin = 3; %%%%%MUDEI AQUI, ERA 10
while i <= NbAmersNew
    ok = 0;
    % find possible new point.
    
    %%%Desistir se nao ha pontos novos validos
    if isempty(find(trackerBis(:,8), 1))
       break 
    end
    
    while ok == 0
        nbViews2 = find(nbViews>nbViewsMin); %filtra IDs com minimo de views
        if isempty(nbViews2)
            if(nbViewsMin > 3) %%%3 pontos para triangular
                nbViewsMin = nbViewsMin - 1;
            else
                idx = [];
                break %%% nao ha pontos de vista suficientes, continuar
            end
%             [trackerBis,myTracks] = razTrackerBis(ParamGlobal,ParamFilter,I,IdxImage,myTracks);
%             for ii = 1:length(myTracks)
%                 nbViews(ii) = length(myTracks(ii).ViewIds);
%             end
            errorMax = errorMax+1;
            nbViews2 = find(nbViews>nbViewsMin);
        end
        
        if isempty(nbViews2)
            continue
        end
        
        idx = randsample(nbViews2,1);
        ok = 1;
        pNew = myTracks(idx).Points(end,:); %vai buscar o ultimo ponto de um point tracker aleatorio
        idxViewNew = myTracks(idx).ViewIds(end);
        for ii = 1:ParamFilter.NbAmers
            if norm(pNew-pointsMain(ii,:)) < PixelMin || idxViewNew < I %1a condicao - pontos longe, 2a condicao - ponto detetado nesta imagem (Atual)
                ok = 0;
                break
            end
        end
        nbIdx = nbViews(idx);
        nbViews(idx) = 0;
    end
    
    if isempty(idx)
       break 
    end
    
    % estimate location
    iReal = myTracks(idx).ViewIds(1);
    Rot = squeeze(trajFilter.Rot(:,:,iReal));
    x = trajFilter.x(:,iReal);
    camPoses = struct('ViewId',myTracks(idx).ViewIds(1),...
        'Orientation',Rot,'Location',x,'S',S);
    try
        for ii = 2:nbViewsMin% to be more time efficient (else use 2:nbIdx)
            iReal = myTracks(idx).ViewIds(round(ii/nbViewsMin*nbIdx));
            Rot = squeeze(trajFilter.Rot(:,:,iReal));
            x = trajFilter.x(:,iReal);
            camPoses(ii).ViewId = iReal;
            camPoses(ii).Orientation = Rot;
            camPoses(ii).Location = x;
            camPoses(ii).S = S;
        end
        myTracks(idx).ViewIds = myTracks(idx).ViewIds([1 round((2:nbViewsMin)*nbIdx/nbViewsMin)]);
        myTracks(idx).Points = myTracks(idx).Points([1 round((2:nbViewsMin)*nbIdx/nbViewsMin)],:);
        [xyzPoint,covariance] = myEsimatePosAmers(myTracks(idx),camPoses,cameraParams,ParamFilter);
        errors = sum(diag(covariance(end-2:end,end-2:end)));
    catch
        xyzPoint = ones(1,3);
        errorMax = errorMax*2;
        errors = errorMax+1;
        for iii = 1:length(myTracks)
            nbViews(iii) = length(myTracks(iii).ViewIds);
        end
        PixelMin = PixelMin/2;
    end
    
    % add is error is suficiently small
%     if isempty(Newpoints)
%         Newpoints = detectMinEigenFeatures(image);
%         Newpoints = selectUniform(Newpoints,NbAmersNew+150,size(image));
%     end
%     idxNew = randi(length(Newpoints),1);
    if (errors < errorMax)
        posAmersNew(i,:) =  xyzPoint';
        trackPoints(:,i) = myTracks(idx).Points(end,:)';
        trackCov{i} = 3*10^-3*eye(3);%covariance(end-2:end,end-2:end);%2*10^-3*eye(3);
        %%%%% NAO GOSTO DISTO
%         myTracks(idx).ViewIds = I;
%         myTracks(idx).Points = Newpoints(idxNew).Location;
%         pointsBis(idx,:) = Newpoints(idxNew).Location;
%         Newpoints(idxNew) = [];

        trackerHelper = [trackerHelper; trackerBis(idx,:)];

        myTracks(idx).ViewIds = 0;
        myTracks(idx).Points = [0 0];
%         pointsBis(idx,:) = Newpoints(idxNew).Location;
        trackerBis(idx,:) = zeros(8,1);
        i = i+1;
    end
end

% pointsBis(pointsBis(:)<=0) = 1;
% trackerBis.setPoints(pointsBis);

end


