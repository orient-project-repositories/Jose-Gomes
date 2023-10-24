function generate_trajectory_CSV

    pos.time = 0;
    pos.x = 0;
    pos.y = 0;
    pos.z = 0;
    pos.qx = 0;
    pos.qy = 0;
    pos.qz = 0;
    pos.qw = 1;
    
    fid = fopen( 'rotation_18_z_hs.csv', 'w' );
    fprintf(fid, "# timestamp, x, y, z, qx, qy, qz, qw,\n");
    fprintf(fid, "%u,%f,%f,%f,%f,%f,%f,%f,\n", pos.time, pos.x, pos.y, pos.z, pos.qx, pos.qy, pos.qz, pos.qw);
%     pos = walk_x(1, 1, 1, pos, fid);
%     pos = walk_x(1, 2, -1, pos, fid);
%     pos = walk_x(1, 1, 1, pos, fid);
%     pos = walk_y(1, 1, 1, pos, fid);
%     pos = walk_y(1, 2, -1, pos, fid);
%     pos = walk_y(1, 1, 1, pos, fid);
%     pos = walk_z(1, 1, 1, pos, fid);
%     pos = walk_z(1, 2, -1, pos, fid);
%     pos = walk_z(1, 1, 1, pos, fid);
    
%     pos = tilt_x(1/2, 1, 1, pos, fid);
%     pos = tilt_x(1/2, 2, -1, pos, fid);
%     pos = tilt_x(1/2, 1, 1, pos, fid);
%     pos = tilt_y(1/2, 1, 1, pos, fid);
%     pos = tilt_y(1/2, 2, -1, pos, fid);
%     pos = tilt_y(1/2, 1, 1, pos, fid);
%     pos = tilt_z(1/2, 1, 1, pos, fid);
%     pos = tilt_z(1/2, 2, -1, pos, fid);
%     pos = tilt_z(1/2, 1, 1, pos, fid);
%     pos = tilt_y(1,0.2,1,pos,fid);
%     for i = 1:5
%         pos = tilt_y(1,0.4,-1,pos,fid);
%         pos = tilt_y(1,0.4,1,pos,fid);
%     end
%     pos = tilt_y(1,0.2,-1,pos,fid);
    pos = tilt_z(1,0.2,1,pos,fid);
    for i = 1:5
        pos = tilt_z(1,0.4,-1,pos,fid);
        pos = tilt_z(1,0.4,1,pos,fid);
    end
    pos = tilt_z(1,0.2,-1,pos,fid);

%     walk_x(1,1,1,pos,fid);
%     walk_y(1,1,1,pos,fid);
%     walk_z(1,1,1,pos,fid);
%     tilt_x(1,1,1,pos,fid);
%     tilt_y(1,1,1,pos,fid);
%     tilt_z(1,1,1,pos,fid);

end 
% (speed, duration, direction, pos, fid)
%10ms
%duration in secs
%speed m/s
%speed 90deg/s

function pos = tilt_x(speed, duration, direction, pos, fid)
    time = pos.time;
    ang = quat2eul([pos.qw,pos.qx, pos.qy, pos.qz]);
    ang_x = ang(3);
    ang_y = ang(2);
    ang_z = ang(1);
    
    for i = 1:(duration*100)
        quat = eul2quat([ ang_z, ang_y,ang_x + i * 0.01 * 90 *pi / 180 * speed * direction]);
        %[qw, qx, qy, qz] = parts(quat);
        fprintf(fid, "%u,%f,%f,%f,%f,%f,%f,%f,\n", time + i*10000000, pos.x, pos.y, pos.z, quat(2), quat(3), quat(4), quat(1));
%                 fprintf(fid, "%u,%f,%f,%f,%f,%f,%f,%f,\n", time + i*10000000, pos.x, pos.y, pos.z, qx, qy, qz, qw);

    end
    pos.time = pos.time + i*10000000;
    pos.qx = quat(2);
    pos.qy = quat(3);
    pos.qz = quat(4);
    pos.qw = quat(1);
end

function pos = tilt_y(speed, duration, direction, pos, fid)
    time = pos.time;
    ang = quat2eul([pos.qw,pos.qx, pos.qy, pos.qz]);
    ang_x = ang(3);
    ang_y = ang(2);
    ang_z = ang(1);
    
    for i = 1:(duration*100)
        quat = eul2quat([ ang_z, ang_y + i * 0.01 * 90 *pi / 180 * speed * direction,ang_x ]);
        %[qw, qx, qy, qz] = parts(quat);
        fprintf(fid, "%u,%f,%f,%f,%f,%f,%f,%f,\n", time + i*10000000, pos.x, pos.y, pos.z, quat(2), quat(3), quat(4), quat(1));
%                 fprintf(fid, "%u,%f,%f,%f,%f,%f,%f,%f,\n", time + i*10000000, pos.x, pos.y, pos.z, qx, qy, qz, qw);

    end
    pos.time = pos.time + i*10000000;
    pos.qx = quat(2);
    pos.qy = quat(3);
    pos.qz = quat(4);
    pos.qw = quat(1);
end

function pos = tilt_z(speed, duration, direction, pos, fid)
    time = pos.time;
    ang = quat2eul([pos.qw,pos.qx, pos.qy, pos.qz]);
    ang_x = ang(3);
    ang_y = ang(2);
    ang_z = ang(1);
    
    for i = 1:(duration*100)
        quat = eul2quat([ ang_z + i * 0.01 * 90 *pi / 180 * speed * direction, ang_y,ang_x ]);
        %[qw, qx, qy, qz] = parts(quat);
        fprintf(fid, "%u,%f,%f,%f,%f,%f,%f,%f,\n", time + i*10000000, pos.x, pos.y, pos.z, quat(2), quat(3), quat(4), quat(1));
%                 fprintf(fid, "%u,%f,%f,%f,%f,%f,%f,%f,\n", time + i*10000000, pos.x, pos.y, pos.z, qx, qy, qz, qw);

    end
    pos.time = pos.time + i*10000000;
    pos.qx = quat(2);
    pos.qy = quat(3);
    pos.qz = quat(4);
    pos.qw = quat(1);
end

function pos = walk_x(speed, duration, direction, pos, fid)
    time = pos.time;
    pos_x = pos.x;
    for i = 1:(duration*100)
        fprintf(fid, "%u,%f,%f,%f,%f,%f,%f,%f,\n", time + i*10000000, pos_x + i*0.01*speed*direction, pos.y, pos.z, pos.qx, pos.qy, pos.qz, pos.qw);
    end
    pos.time = pos.time + i*10000000;
    pos.x = pos.x + i*0.01*speed*direction;
end

function pos = walk_y(speed, duration, direction, pos, fid)
    time = pos.time;
    pos_y = pos.y;
    for i = 1:(duration*100)
        fprintf(fid, "%u,%f,%f,%f,%f,%f,%f,%f,\n", time + i*10000000, pos.x , pos_y + i*0.01*speed*direction, pos.z, pos.qx, pos.qy, pos.qz, pos.qw);
    end
    pos.time = pos.time + i*10000000;
    pos.y = pos.y + i*0.01*speed*direction;
end

function pos = walk_z(speed, duration, direction, pos, fid)
    time = pos.time;
    pos_z = pos.z;
    for i = 1:(duration*100)
        fprintf(fid, "%u,%f,%f,%f,%f,%f,%f,%f,\n", time + i*10000000, pos.x, pos.y, pos_z + i*0.01*speed*direction, pos.qx, pos.qy, pos.qz, pos.qw);
    end
    pos.time = pos.time + i*10000000;
    pos.z = pos.z + i*0.01*speed*direction;
end