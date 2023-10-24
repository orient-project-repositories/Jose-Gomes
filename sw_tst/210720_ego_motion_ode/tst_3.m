function tst_3

rng(2021);

vx = 0;
vy = 0;
vz = 0;
wx = 0;
wy = 0;
wz = 1;

f = 200;
Z = 1;

out = [];

delta_t = 0.2;
num_points = 30;

for point = 1:num_points
    
    y = [randi(240) - 120 ; randi(180) - 90 ];

    for i = 1:3

    % dydt = [(1/Z)* (-f*vx + y(1)*vz) + wx*y(1)*y(2)/f - wy*(f+y(1)*y(1)/f) + wz*y(2); 
    % (1/Z)* (-f*vy + y(2)*vz) + wx * (f+y(2)*y(2)/f) - wy * y(1)*y(2)/f -wz*y(1)];
        dydt(1) = (1/Z)* (-f*vx + y(1,i)*vz) + wx*y(1,i)*y(2,i)/f - wy*(f+y(1,i)*y(1,i)/f) + wz*y(2,i);  
        dydt(2) = (1/Z)* (-f*vy + y(2,i)*vz) + wx * (f+y(2,i)*y(2,i)/f) - wy * y(1,i)*y(2,i)/f -wz*y(1,i);

        y(1,i+1)= y(1,i) + dydt(1) * delta_t;
        y(2,i+1) =y(2,i) + dydt(2) * delta_t;

    end

    out = [out; y(1,:);y(2,:)];
    
end


col = 1:length(out(1,:));

% figure
for point = 1:2: (num_points-1)
    plot(out(point,:),out(point+1,:),'-');
    hold on
    
end
xlim([-120 120])
ylim([-90 90])
ylabel('y position in camera frame')
xlabel('x position in camera frame')


end