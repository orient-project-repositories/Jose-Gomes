function check_CSV(csv_file)

if nargin < 1
    csv_file='rotation_18_y_hs.csv';
end

out = readmatrix(csv_file);

time = out(:,1);
pos = out(:,2:4);
quat = out(:,5:8);

eul = quat2eul([quat(:,4),quat(:,1),quat(:,2),quat(:,3)]);

figure
plot(time, pos(:,1));
hold on
plot(time, pos(:,2));
plot(time, pos(:,2));
legend('X','Y','Z');


figure
plot(time,eul(:,3));
hold on
plot(time,eul(:,2));
plot(time,eul(:,1));
legend('X','Y','Z');
end
