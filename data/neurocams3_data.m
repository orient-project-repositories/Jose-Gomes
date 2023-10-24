function ret = neurocams3_data(dataId, options)
% Function that returns the dataset informations
%
% Arguments:
%           dataId - Identifier of the dataset (same as the folder name of
%                    the dataset);
%           options - options - This struct contains information like:
%                     dataset dir, image_name, etc;
% Return:
%           Returns a struct with the dataset ID, name, path, pan/ tilt
%           information, zoom, etc.

% usages:
% ret= neurocams3_data( dataId )
% fullfilename= neurocams3_data( dataId, filename )

% to test this file: 
% neurocams3_data_tst

if nargin < 1
    dataId = 1;
end
if isnumeric(dataId)
    dataId = num2str(dataId);
end

persistent NC3_dataId
if isempty(dataId)
    dataId= NC3_dataId;
else
    NC3_dataId= dataId;
end

if nargin < 2
    options = [];
end
if ischar(options)
    % convert filename to a struct
    options= struct('getFullFilename', options);
end

ret = get_info(dataId, options);

return; % end of main function


function ret = get_info(dataId, options)

% get path into "p"
cfname= dbstack(1); cfname= cfname.file;
p= which(cfname); p= strrep(p,cfname,''); p= strrep(p,'\','/');

mydata = get_mydata(p);
ind = [];
for n = 1:size(mydata,1)
    % find dataset name or dataset folder
    if strcmp(dataId, mydata{n,1}) || strcmp(dataId, mydata{n,2})
        ind = n;
        break
    end
end
if isempty(ind)
    error(['dataset not found: ' dataId])
end

pname  = [p mydata{ind,2} '/'];
bfname = [pname mydata{ind,3}];
iRange =  mydata{ind,4};

% return general information
ret= struct('dataId',dataId, 'pname',pname, ...
    'bfname',bfname, 'iRange',iRange );

% if asked, return just a fullfilename
if isfield(options, 'retJustPath') && options.retJustPath
    ret= ret.pname;
elseif isfield(options, 'getFullFilename')
    ret= [ret.pname options.getFullFilename];
end

% expand encoded iRange
if isfield(ret, 'iRange') && ischar(ret.iRange)
    ret.iRange= eval(ret.iRange);
end

return


function mydata = get_mydata(p)

% use filename_complete.m to complete ims1_cam0 iRange
% this requires matlab.my updated >= 22.10.2020

ind2ims1_cam0= 'repmat(523912143104,1,1710) +(0:1709).*49999872 +floor((0:1709)/2).*256';

mydata= {
    '1', 'PTZ_and_laser_calib/calib_img1', 'img%d.jpg', 2:50; ...
    'vrml_1', '190600_vrml_chessboard/board_size_02_fov13', 'camara2_anim_%d.png', 1:7; ...
    'vrml_2', '190600_vrml_chessboard/board_size_03_fov16', 'camara2_anim_%d.png', 1:7; ...
    'ims1_cam0', 'im_V1_02_medium/mav0/cam0/data', '1403715%d.png', ind2ims1_cam0; ...
    'ims1_cam1', 'im_V1_02_medium/mav0/cam1/data', '1403715%d.png', ind2ims1_cam0; ...
    'ev_shapes_rotation', 'ev_shapes_rotation', 'images/frame_%08d.png', 0:1:1356; ...
    'ev_boxes_rotation', 'ev_boxes_rotation', 'images/frame_%08d.png', 0:1:1298; ...
    'ev_translation_1_x', 'ev_translation_1_x', 'images/frame%04d.png', 0:1:63; ...
    'ev_rotation_18_y', 'ev_rotation_18_y', 'images/frame%04d.png', 0:1:45; ...
    'ev_rotation_18_x', 'ev_rotation_18_x', 'images/frame%04d.png', 0:1:55; ...
    'ev_rotation_18_z', 'ev_rotation_18_z', 'images/frame%04d.png', 0:1:67; ...
    'ev_translation_1_y', 'ev_translation_1_y', 'images/frame%04d.png', 0:1:61; ...
    'ev_translation_1_z', 'ev_translation_1_z', 'images/frame%04d.png', 0:1:67; ...
    'ev_shapes_rotation', 'ev_shapes_rotation', 'images/frame_%08d.png', 0:1:1356; ...
    'ev_kinova_3_mixed', 'ev_kinova_3_mixed', 'images/frame_%08d.png', 0:1:0; ...
    'ev_kinova_3_frames', 'ev_kinova_3_frames', 'images/frame_%08d.png', 0:1:644; ...
    'tst_corner_room', 'tst_corner_room', 'images/frame%04d.png', 0:1:350; ...
    };
return
