    function plot3_bag(position, orientation_euler)
position = position - [position(1,1) position(1,2) position(1,3)];
figure;
for i = 1:length(orientation_euler)
    
    R = rotz(orientation_euler(i,1))*roty(orientation_euler(i,2))*rotx(orientation_euler(i,3));
    xvec = 0.1*R(:,1);
    yvec = 0.1*R(:,2);
    zvec = 0.1*R(:,3);

    plot3([0 xvec(1)]+position(i,1), [0 xvec(2)]+position(i,2), [0 xvec(3)]+position(i,3), 'LineWidth', 2);    hold on;
    plot3([0 yvec(1)]+position(i,1), [0 yvec(2)]+position(i,2), [0 yvec(3)]+position(i,3), 'LineWidth', 2);
    plot3([0 zvec(1)]+position(i,1), [0 zvec(2)]+position(i,2), [0 zvec(3)]+position(i,3), 'LineWidth', 2);
    plot3(position(1:i,1), position(1:i,2), position(1:i,3), '--');
    xlim([-0.2 0.2]);
    ylim([-0.2 0.2]);
    zlim([-0.2 0.2]);
    grid on; grid minor;
    title(sprintf('iteration %d', i))
    xlabel('x [m]'); ylabel('y [m]'); zlabel('z [m]');
    hold off;
    pause(0.01)
end