function testRotMatrix

rotm2eul(Rot0)*360/(2*pi)


quat2rotm(groundtruth(1,5:end)

eul2rotm([trajReal.psi(1), trajReal.phi(1), trajReal.theta(1)])

ang = quat2eul([quats(:,4), quats(:,1),quats(:,2),quats(:,3)], 'XYZ')
plot(ang(:,3)*180/pi)

