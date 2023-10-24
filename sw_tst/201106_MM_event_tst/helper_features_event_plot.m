% x = zeros(1,500);
% y = zeros(1,500);
% z = zeros(1,500);
tracks = readmatrix('tracks_kinova.txt');

[~,idx] = sort(tracks(:,2)); % sort just the first column
tracks = tracks(idx,:);   % sort the whole matrix using the sort indices

[S, iSorted] = sort(tracks(:,1));
S = tracks(iSorted,:);

j = 0;
k = 1;
i=1;

while i < 452
   k = 1;
   while S(i,1) == j
      x(k,j+1) = S(i,2);
      y(k,j+1) = S(i,3);
      z(k,j+1) = S(i,4);

      i = i+1;
      k = k+1;
   end
   j=j+1;
end

% markers = [0; find(diff(S(:,1))); numel(tracks(:,1))];
% 
% for i = 1:numel(markers)-1
%   uM(i,:) = S(markers(i)+1,:);
%   I{i} = iSorted(markers(i)+1:markers(i+1));
% end

% 
% for i = 0:max(tracks(:,1)+1)
%     for j = 1:length(tracks(:,1))
%        if  tracks(j,1) == i
%            x(end + 1,i+1) = tracks(j,2);
%            y(end + 1,i+1) = tracks(j,3);
%            z(end + 1,i+1) = tracks(j,4);
%        end
%     end   
% end

figure

plot3(x(:,1),y(:,1),z(:,1));
xlabel('X')
ylabel('Y')
zlabel('Z')
hold on

for i = 2:406
    plot3(x ( find(x(:,i) ),i),y( find(x(:,i)),i),z( find(x(:,i)),i));
end
