function event_tst()

vars.intrinsics = [200      0     120;
                     0		200   90;
                     0      0     1   ];
vars.tanDist = [0 0];
vars.radialDist = [0 0 0];

vars.minMatches = 3;
vars.maxMatches = 100;
vars.radius = 1;

vars.threshold = 0.015;
vars.thresholdMax = 0.2;

tracks = readmatrix('tracks_kinova_3_mixed.txt');



num_id = max(tracks(:,1)) + 1;
feat_mat = zeros(num_id, 7);

init_t = tracks(1,2); 

for j = 1:length(tracks(:,2))
    tracks(j,2) =     tracks(j,2) -init_t;
end
j = 1;

while(tracks(j,2) == init_t)
    feat_mat(j,2:4) = tracks(j,2:4);
    j=j+1;
end

[~,idx] = sort(tracks(:,2)); % sort just the first column
tracks = tracks(idx,:);   % sort the whole matrix using the sort indices

counter = 0;
paralel = 0;
time_par = 0;

i=1;
% for i = j:length(tracks(:,1))
while(j < length(tracks(:,1)))
    time = tracks(j,2);
    feat_mat(:,1) = 0; %reset validity
    
    feat_mat(:,5:7)= feat_mat(:,2:4);
    
    while(tracks(j,2) <= time + vars.threshold && j < length(tracks(:,1)) )
        
        if feat_mat(tracks(j,1)+1,2) ~= 0  && feat_mat(tracks(j,1)+1,2) - time < vars.thresholdMax 
            feat_mat(tracks(j,1)+1,1) = 1;
        end
        
        %%% TEM BUG, FEATURES REPETIDAS ESTAO A SER SUBSTITUIDAS
%         if feat_mat(tracks(j,1)+1,1) == 1
%             feat_mat(tracks(j,1)+1,2:4) = tracks(j,2:4);
%         else
%             feat_mat(tracks(j,1)+1,5:7) = feat_mat(tracks(j,1)+1,2:4);
            feat_mat(tracks(j,1)+1,2:4) = tracks(j,2:4);
%         end
        
        j=j+1;
        
    end

    idx = find(feat_mat(:,1));
        
    paralel(counter +1) = length(idx);
    time_par(counter + 1) = time;
    counter = counter + 1;
    
    [Roppr, T] = orthProcrustesProb(feat_mat(idx,6:7)', feat_mat(idx,3:4)', vars.radius, vars.intrinsics);
    rots{i} = Roppr;
    i = i +1;
    
end

ang = zeros(length(rots) - 1,3);

ang(1,:) = -rotm2eul(rots{1})*180/pi;

for i = 2:length(rots) - 1
    ang(i,:) = -rotm2eul(rots{i})*180/pi + ang(i-1,:);
end

figure;
plot(ang(:,3));
hold on
plot(ang(:,2));
plot(ang(:,1));


end
