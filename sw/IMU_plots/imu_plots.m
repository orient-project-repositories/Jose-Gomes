function imu_plots

step = 0.01;
t = 0:step:1;
bias = 0.02;
% noise = wgn(length(t), 1, 10^-9);
sigma = 0.01;
noise = normrnd(0, sigma, length(t), 1);

vel(1:length(t)) = 0.05;
vel_bias = vel + bias;
vel_noise = vel + noise;
vel_noise_bias = vel + bias + noise;

figure;
plot(t, vel);
hold on;
plot(t, vel_bias);
plot(t, vel_noise);
plot(t, vel_noise_bias);

xlabel('Time [s]');
ylabel('Angular velocity [deg/s]');
legend('Groundtruth','With bias','With noise','With noise and bias');
title('Gyroscope readings with different combinations of noise');

angle = zeros(length(t),1);
angle_bias = zeros(length(t),1);
angle_noise = zeros(length(t),1);
angle_noise_bias = zeros(length(t),1);

for i = 2:length(t)
    angle(i) = angle(i-1) + vel(i)*step;
    angle_bias(i) = angle_bias(i-1) + vel_bias(i)*step;
    angle_noise(i) = angle_noise(i-1) + vel_noise(i)*step;
    angle_noise_bias(i) = angle_noise_bias(i-1) + vel_noise_bias(i)*step;
end

figure;
plot(t, angle);
hold on;
plot(t, angle_bias);
plot(t, angle_noise);
plot(t, angle_noise_bias);

xlabel('Time [s]');
ylabel('Orienation [deg]');
legend('Groundtruth','With bias','With noise','With noise and bias');
title('Orientation estimation for different combinations of noise');

end