function helperPlotsAndErrors(trajs, trajReal, axis)

ang = rotm2eul( trajs.trajR.Rot);
ang = ang(:,axis);

figure;
plot(trajReal.phi*180/pi);
hold on
plot(-ang*180/pi);

%change for different axis
out = trajReal.phi(1:length(ang)) + ang';
mean(out)*180/pi;
max(out)*180/pi;
std(out)*180/pi;

end