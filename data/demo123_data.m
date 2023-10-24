function ret = demo123_data(dataId, options)
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

if nargin < 2
    options = [];
end
if nargin < 1
    dataId = 1;
end
if isnumeric(dataId)
    dataId = num2str(dataId);
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

ret= struct('dataId',dataId, 'pname',pname, ...
    'bfname',bfname, 'iRange',iRange );

return


function mydata = get_mydata(p)

mydata= {
    '1', 'PTZ_and_laser_calib/calib_img1', 'img%d.jpg', 2:50; ...
    'vrml_1', '190600_vrml_chessboard/board_size_02_fov13', 'camara2_anim_%d.png', 1:7; ...
    'vrml_2', '190600_vrml_chessboard/board_size_03_fov16', 'camara2_anim_%d.png', 1:7; ...
    };

return
