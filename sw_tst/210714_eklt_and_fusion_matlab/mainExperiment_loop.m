function [orb_slam, trajs, i] = mainExperiment_loop(orb_slam, IMU_img_struct, state_camera_struct, NbStepsMax, obsTimes, ParamFilter, ParamGlobal)

% global flag;
% 
% flag = 0;

trajReal = IMU_img_struct.trajReal;
NbSteps = IMU_img_struct.NbSteps;
t = IMU_img_struct.t;
omega = IMU_img_struct.omega;
acc = IMU_img_struct.acc;
g = IMU_img_struct.g;

P0 = state_camera_struct.P0;
Q = state_camera_struct.Q;
Qc = state_camera_struct.Qc;
R = state_camera_struct.R;

dirImage = ParamGlobal.dirImage;
fileImages = ParamGlobal.fileImages;

pub_twist = rospublisher("pos_twist","dvs_msgs/Motion");
twist_msg = rosmessage('dvs_msgs/Motion');
pub_ok = rospublisher("ok_from_fusion","std_msgs/String");
ok_msg = rosmessage('std_msgs/String');
ok_msg.Data = "OK";

sub_feat = rossubscriber('/features', @updateFeaturesCall);
sub_ok = rossubscriber('/ok_from_eklt');
pause(2) 

% Rot0 = eul2rotm([trajReal.psi(1),trajReal.theta(1),trajReal.phi(1)]);
Rot0 = eul2rotm([0 0 0]);
x0 = trajReal.x(:,1);
v0 = trajReal.v(:,1);
omega_b0 = orb_slam.omega_b;
a_b0 = orb_slam.a_b;
PosAmers0 = orb_slam.PosAmers;
trackerMain = orb_slam.trackerMain;
trackerBis = orb_slam.trackerBis;
myTracks = orb_slam.myTracks;

IdxImage = 2; % image index

trajR = initTraj(NbSteps);
RotR = Rot0;
vR = v0;
xR = x0;
omega_bR = omega_b0;
a_bR = a_b0;
PosAmersR = PosAmers0;
P_R = P0;
S_R = chol(P_R);
chiR = state2chi(RotR,vR,xR,PosAmersR);



%% Filtering
for i = 2:NbStepsMax
    
    % propagation
    dt = t(i)-t(i-1);
    omega_i = omega(:,i);
    acc_i = acc(:,i);
    
    chiAntR = chiR;
    RotR = RotR*expSO3((omega_i-omega_bR)*dt);
    vR = vR+(RotR*(acc_i-a_bR)+g)*dt;
    xR = xR+vR*dt;
    chiR = state2chi(RotR,vR,xR,PosAmersR);
    S_R = rukfPropagation(dt,chiR,chiAntR,omega_bR,a_bR,S_R,omega_i,...
        acc_i,Qc,g);
    
   
    % if measurement
    if obsTimes == 1
        % track points in image
        [y,yAmers,trackerMain,trackerBis,pointsMain,validityMain,...
            myTracks,pointsBis, ParamGlobal] = ...
            ObserveLandmarks(trackerMain,trackerBis,dirImage,IdxImage,...
            fileImages,ParamFilter,RotR,xR,PosAmersR,i,S_R,myTracks, ParamGlobal);
        
%         if i > 500 && i < 1000
%             continue
%         end

        if isempty(y)
            disp('empty y');
            disp(i);
            continue
        end
        
        % update state
        param.yAmers = yAmers;
        [chiR,omega_bR,a_bR,S_R] = rukfUpdate(chiR,omega_bR,...
            a_bR,S_R,y,param,R,ParamFilter);
        [RotR,vR,xR,PosAmersR] = chi2state(chiR);
        
        
        % save trajectory
        %%%MOVED DOWN TESTING
%         trajR = updateTraj(trajR,RotR,vR,xR,omega_bR,a_bR,i);
%         trajL = updateTraj(trajL,RotL,vL,xL,omega_bL,a_bL,i);
%         trajRef = updateTraj(trajRef,RotRef,vRef,xRef,omega_bRef,a_bRef,i);
%         trajU = updateTraj(trajU,RotU,vU,xU,omega_bU,a_bU,i);
%         trajI = updateTraj(trajI,RotI,vI,xI,omega_bI,a_bI,i);
        
        % remplace non visible landmarks
        [S_R,PosAmersR,ParamFilter,trackerBis,myTracks,PosAmersNew,...
            IdxAmersNew,trackCov,pointsMain,validityMain, trackerMain] = manageAmers(S_R,...
            PosAmersR,ParamFilter,ParamGlobal,trackerBis,...
            trajR,i,pointsMain,validityMain,IdxImage,myTracks,pointsBis, trackerMain);
        chiR = state2chi(RotR,vR,xR,PosAmersR);
        
        
        %%%DO THIS INSIDE MAANGE AMERS!!!!!!!%%%
%         setPoints(trackerMain,pointsMain,validityMain);
        

        disp(i/1000);
        IdxImage = IdxImage+1;
        obsTimes = 0;
    end
    
    trajR = updateTraj(trajR,RotR,vR,xR,omega_bR,a_bR,i);

    
    twist_msg.Vx = - trajR.v(1,i);
    twist_msg.Vy = trajR.v(3,i);
    twist_msg.Vz = trajR.v(2,i);
    twist_msg.Wx = - IMU_img_struct.omega(1,i);
    twist_msg.Wy = IMU_img_struct.omega(3,i);
    twist_msg.Wz = IMU_img_struct.omega(2,i);
    secs = fix(IMU_img_struct.tIMU(i));
    twist_msg.Ts.Sec = secs;
    twist_msg.Ts.Nsec = cast(((IMU_img_struct.tIMU(i) - secs) * 10^9), 'uint32');
    send(pub_twist,twist_msg);
    
    %wait OK
    
    rec_ok = receive(sub_ok);
    
    %send OK
    send(pub_ok,ok_msg);

end

trajs.trajR = trajR;

orb_slam.trackerBis = trackerBis;
orb_slam.trackerMain = trackerMain;

end

function updateFeaturesCall(~, msg)
    global flag;
    flag = 1;
    disp('Received');
    
    obsTimes = 1;
end
