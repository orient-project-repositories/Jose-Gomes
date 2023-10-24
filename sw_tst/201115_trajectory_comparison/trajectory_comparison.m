function trajectory_comparison()

close all;

neurocams3_data( 'ev_translation_1_x' );


expected = readmatrix( neurocams3_data([], 'expected.csv') );
expected = expected (:,1:4);

real = readmatrix( neurocams3_data([], 'groundtruth.txt') );
real = real(:,1:4);

acc = readmatrix( neurocams3_data([], 'imu.txt') );
acc = acc(:,1:4);

% figure;
% plot3(expected(:,2),expected(:,3),expected(:,4));
% hold on;
% plot3(real(:,2),real(:,3),real(:,4));

% figure;
% plot(expected(:,1),expected(:,2));
% ylabel('Position in the axis [m]');
% xlabel('Time[ns]');
% title('Trajectory supplied to the simulator');
% 
% % hold on
% figure;
% plot(real(:,1),real(:,2));
% xlabel('Time[ns]');
% ylabel('Position in the axis [m]');
% title('Trajectory obtained from the simulator');

% jac_exp = gradient(expected(:,2));%,expected(3,1)-expected(2,1));
% jac_real = gradient(real(:,2));%,real(3,1)-real(2,1));

jac_exp = diff(expected(:,2)); %,expected(3,1)-expected(2,1));
jac_real = conv(real(:,2), [-1, 0, 1]/2, 'same'); %,real(3,1)-real(2,1));
% 
% figure;
% plot(jac_exp);
% hold on
 filtered1= medfilt1(jac_real,7);
% plot(filtered1);

% hess_real = gradient(jac_real);
hess_real = conv(filtered1, [-1, 0, 1]/2, 'same');
hess_real(end-10:end)=[];
figure;
plot(medfilt1(hess_real,9)*10^6);
ylabel('Accelerometer reading for single axis [m/s^2]');
xlabel('Time [ms]');
title('Accelerometer reading estimated from the trajectory');

figure;
plot(acc(:,2));
ylabel('Accelerometer reading for single axis [m/s^2]');
xlabel('Time [ms]');
title('Accelerometer reading obtained from the simulator');
end
