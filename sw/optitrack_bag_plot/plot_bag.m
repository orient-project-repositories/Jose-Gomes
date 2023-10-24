function plot_bag(bag_path)

bag = rosbag(bag_path);

poses_topic = select(bag,'Topic','/vrpn_client_node/Robot_1/pose');
poses_msg = readMessages(poses_topic,'DataFormat','struct');

qx = zeros(1,length(poses_msg));
qy = zeros(1,length(poses_msg));
qz = zeros(1,length(poses_msg));
qw = zeros(1,length(poses_msg));

x = zeros(1,length(poses_msg));
y = zeros(1,length(poses_msg));
z = zeros(1,length(poses_msg));


for i = 1:length(poses_msg)
    poses(i) = poses_msg{i}.Pose;
%     position(i) = poses(i).Position;
%     orientation(i) = poses(i).Orientation;
    x(i) = poses_msg{i}.Pose.Position.X;
    y(i) = poses_msg{i}.Pose.Position.Y;
    z(i) = poses_msg{i}.Pose.Position.Z;

    qx(i) = poses_msg{i}.Pose.Orientation.X;
    qy(i) = poses_msg{i}.Pose.Orientation.Y;
    qz(i) = poses_msg{i}.Pose.Orientation.Z;
    qw(i) = poses_msg{i}.Pose.Orientation.W;

end

position = [x', y', z'];
orientation = [ qw', qx', qy', qz'];
orientation_euler = quat2eul(orientation) * 180/pi;

figure
plot(1:length(poses_msg), x - x(1));
figure
plot(1:length(poses_msg), y - y(1));
figure
plot(1:length(poses_msg), z - z(1));

figure
plot(1:length(poses_msg), orientation_euler(:,1)' - orientation_euler(1,1));
figure
plot(1:length(poses_msg), orientation_euler(:,2)' - orientation_euler(1,2));
figure
plot(1:length(poses_msg), orientation_euler(:,3)' - orientation_euler(1,3));


end