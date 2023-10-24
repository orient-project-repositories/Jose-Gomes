function check_output(txt_out)

if nargin < 1
    txt_file='/home/MSc/data/Texts/rotation_18_y_hs/groundtruth.txt';
end

out = readmatrix(txt_file);

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
plot(time,eul(:,3)+pi/2);
hold on
plot(time,eul(:,2));

for i =1:length(eul(:,1))
    if eul(i,1) < 0
        eul(i,1) = eul(i,1) + pi;
    else
        eul(i,1) = eul(i,1) - pi;
    end
end
plot(time,eul(:,1));
legend('X','Y','Z');


end