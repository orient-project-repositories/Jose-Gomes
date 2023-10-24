for i = 1:185
   for j = 1:46
      x(j,i) = j;
      y(j,i) = features_loc{j}(i,1);
      z(j,i) = features_loc{j}(i,2);
   end
end

figure

plot3(x(:,1),y(:,1),z(:,1));
xlabel('X')
ylabel('Y')
zlabel('Z')
hold on

for i = 1:185
    plot3(x(:,i),y(:,i),z(:,i));
end