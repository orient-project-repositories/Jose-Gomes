rosinit('http://localhost:11311');

%%
bag_file = '../../data/rotation_18_y.bag';

bag = rosbag(bag_file);

images = select(bag, 'Topic', '/cam0/image_raw');
events = select(bag, 'Topic', '/cam0/events');
cam_info = select(bag, 'Topic', '/cam0/camera_info');
imu = select(bag, 'Topic', '/imu');
tf = select(bag, 'Topic', '/tf');

images_read = readMessages(images);
events_read = readMessages(events);
cam_info_read = readMessages(cam_info);
imu_read = readMessages(imu);
tf_read = readMessages(tf);


%%

pub_img_raw = rospublisher("/dvs/image_raw","sensor_msgs/Image");
pub_ev = rospublisher("/dvs/events","dvs_msgs/EventArray");
pub_cam_info = rospublisher("/dvs/camera_info","sensor_msgs/CameraInfo");
pub_imu = rospublisher("/imu","sensor_msgs/Imu");
pub_tf = rospublisher("/tf","tf/tfMessage");


%%
start = 1;

imu_cur=1;
img_raw_cur=1;
ev_cur=1;
cam_info_cur=1;
tf_cur=1;

imu_idx = find(bag.MessageList.Topic == '/imu');

for i = start:16705
    
    switch bag.MessageList.Topic(i) 
%         case '/imu'    
%             send(pub_imu,imu_read{imu_cur});
%             imu_cur=imu_cur+1;
        case '/cam0/image_raw'
            send(pub_img_raw,images_read{img_raw_cur});
            img_raw_cur=img_raw_cur+1;
        case '/cam0/events'
            send(pub_ev,events_read{ev_cur});
            ev_cur=ev_cur+1;
%         case '/cam0/camera_info'
%             send(pub_cam_info,cam_info_read{cam_info_cur});
%             cam_info_cur=cam_info_cur+1;
%         case '/tf'
%             send(pub_tf,tf_read{tf_cur});
%             tf_cur=tf_cur+1;
        otherwise
            warning('Unexpected type.')
    end
    
    if ismember(i, imu_idx)
        disp('break'); 
    end
end

    

% %%
% 
% for i = 1:46
%     send(chatpub,images_read{i});
% end
% 
% %%
% ev_pub = rospublisher("/ev","dvs_msgs/EventArray");
% %%
% 
% for i = 1:81
%     send(ev_pub,events_read{i});
% end