function plotTrajs(mat_file)

%%% Example call:
%%% plotTrajs('tst_corner_room_tarde.mat')

START_VALUE = 1;
END_VALUE = 4000;

trajs = load(mat_file);
trajs = trajs.trajs;

ang = rotm2eul( trajs.trajR.Rot);

figure;
plot(-ang(START_VALUE:END_VALUE,:)*180/pi);
legend('X axis', 'Y axis', 'Z axis');
xlabel('Time [ms]');
ylabel('Rotation [deg]');
title('Orientation over time');

figure;
plot(trajs.trajR.x(1,START_VALUE:END_VALUE));
hold on;
plot(trajs.trajR.x(2,START_VALUE:END_VALUE));
plot(trajs.trajR.x(3,START_VALUE:END_VALUE));

legend('X axis', 'Y axis', 'Z axis');
xlabel('Time [ms]');
ylabel('Translation [deg]');
title('Position over time');

end