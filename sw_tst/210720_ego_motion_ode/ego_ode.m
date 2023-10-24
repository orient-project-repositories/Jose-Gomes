function ego_ode

[t,y] = ode45(@ego,[0:1:3],[1; 1]);

end


function dydt = ego(t,y)
vx = 0;
vy = 0;
vz = 0;
wx = 0;
wy = 0;
wz = 1;

f = 200;
Z = 1;

% dydt = [(1/Z)* (-f*vx + y(1)*vz) + wx*y(1)*y(2)/f - wy*(f+y(1)*y(1)/f) + wz*y(2); 
% (1/Z)* (-f*vy + y(2)*vz) + wx * (f+y(2)*y(2)/f) - wy * y(1)*y(2)/f -wz*y(1)];
dydt = [ + wz*y(2);  -wz*y(1)];

end