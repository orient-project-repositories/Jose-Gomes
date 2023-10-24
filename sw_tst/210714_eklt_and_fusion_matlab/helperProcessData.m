function helperProcessData()

%%% settings
listing = dir('./results/');
start_file = 4; %%%file start
end_file = 15;
% dataset = 'ev_rotation_18_y';
% dataset = 'ev_translation_1_x';

len = 4000;

% axis = 2;



for i = start_file:end_file
    eklt = [];
    file = listing(i).name;
    split = strsplit(file, '-');
    start = 3;
    dataset = split(2);
    eklt.freq = sscanf(split{start},'freq%d');
    eklt.batch = sscanf(split{start+1},'batch%f');
    eklt.block = sscanf(split{start+2},'block%f');
    eklt.dispx = sscanf(split{start+3},'dispx%f');
    eklt.lk = sscanf(split{start+4},'lk%f');
    eklt.maxc = sscanf(split{start+5},'maxc%f');
    eklt.minc = sscanf(split{start+6},'minc%f');
    eklt.maxiter = sscanf(split{start+7},'maxiter%f');
    eklt.mindist = sscanf(split{start+8},'mindist%f');
    eklt.pyr = sscanf(split{start+9},'pyr%f');
    eklt.patch = sscanf(split{start+10},'patch%f');
    eklt.qual = sscanf(split{start+11},'qual%f');
    eklt.scale = sscanf(split{start+12},'scale%f');
    eklt.trqual = sscanf(split{start+13},'trqual%f.mat');

    %%%
    neurocams3_data( dataset );
    groundtruth = readmatrix( neurocams3_data([], 'groundtruth.txt') );
    tReal = groundtruth(:,1);
    trajReal.x = groundtruth(:,2:4)';
    trajReal.x = trajReal.x / 10^8; %um to m
    trajReal.v = zeros(3,length(tReal));
    trajReal.a_b = zeros(3,length(tReal));
    trajReal.omega_b = zeros(3,length(tReal));
    trajReal.quat = [groundtruth(:,8), groundtruth(:,5), groundtruth(:,6), groundtruth(:,7)];
    ground_euler = quat2eul(trajReal.quat);
    trajReal.psi = ground_euler(:,1)';
    trajReal.phi = ground_euler(:,2)';
    trajReal.theta = ground_euler(:,3)';
    %%%
    
    trajs = load(strcat('./results/',file));
    trajs = trajs.trajs;
    
    ang = rotm2eul( trajs.trajR.Rot);
    ang_x = ang(:,3);
    ang_y = ang(:,2);
    ang_z = ang(:,1);

    fig = figure;
    plot(trajReal.theta(1:len)*180/pi +90);
    hold on
    plot(trajReal.phi(1:len)*180/pi);
    
    for j = 1:length(trajReal.psi)
        if trajReal.psi(j) < -pi/2 
            trajReal.psi(j) = trajReal.psi(j) + 2* pi;
        end
    end
    
    trajReal.psi(j) = trajReal.psi(j) - pi;
    
    plot(trajReal.psi(1:len)*180/pi -180);

    plot(-ang_x(1:len)*180/pi);
    plot(-ang_y(1:len)*180/pi);
    plot(-ang_z(1:len)*180/pi);

    xlabel('Time [ms]');
    ylabel('Rotation Angle [deg]');
    legend('Ground X', 'Ground Y', 'Ground Z', 'Est. X', 'Est. Y', 'Est. Z');
    title(file);
    
    
%     fig2 = figure;
%     plot(trajReal.x(1,:));
%     hold on
%     plot(trajReal.x(2,:));
%     plot(trajReal.x(3,:));
% 
%     plot(trajs.trajR.x(1,:));
%     plot(trajs.trajR.x(2,:));
%     plot(trajs.trajR.x(2,:));
% 
%     xlabel('Time [ms]');
%     ylabel('Position [m]');
%     legend('Ground X', 'Ground Y', 'Ground Z', 'Est. X', 'Est. Y', 'Est. Z');
%     title(file);
    
    %change for different axis
    out = trajReal.phi(1:length(ang)) + ang';
    mean(out)*180/pi;
    max(out)*180/pi;
    std(out)*180/pi;

end

end

