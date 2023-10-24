function ang = helperAngles(ang)

for i = 1:length(ang(:,1))
   if ang(i,1)*180/pi >= 100
       ang(i,1) = ang(i,1) - 2*pi;
   end
end

quats = groundtruth(:,5:end);
ang = quat2eul([quats(:,4), quats(:,1),quats(:,2),quats(:,3)])
figure;
plot(ang(:,3)*180/pi);
hold on
plot(ang(:,2)*180/pi);
plot(ang(:,1)*180/pi);
