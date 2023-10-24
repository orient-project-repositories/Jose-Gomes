function datasets= data_download_info
datasets= {...
    struct('dataId','PTZ_and_laser_calib',	'ofname',	'PTZ_and_laser_calib.zip',		'url', 'https://www.dropbox.com/s/d60mmro2vpu1l44/PTZ_and_laser_calib.zip?dl=1'), ...
    struct('dataId','vrml',         'ofname',	'190600_vrml_chessboard.zip',       'url', 'https://www.dropbox.com/s/z1tnul4hdfe0rej/190600_vrml_chessboard.zip?dl=1'), ...
    ... %struct('dataId','imdata1', 'ofname', 'im_V1_02_medium.zip',	'url', 'http://robotics.ethz.ch/~asl-datasets/ijrr_euroc_mav_dataset/vicon_room1/V1_02_medium/V1_02_medium.zip'), ...
    ... %struct('dataId','evdata1', 'ofname', 'ev_shapes_rotation.zip', 'url', 'http://rpg.ifi.uzh.ch/datasets/davis/shapes_rotation.zip'), ...
    mkData1, ...
    mkData1x, ...
    mkData2( 'evdata1', 'shapes_rotation' ), ...
    mkData2( 'evdata2', 'boxes_rotation' ), ...
   };
return


function ret= mkData1
dataId= 'imdata1';
urlPath= 'http://robotics.ethz.ch/~asl-datasets/ijrr_euroc_mav_dataset/vicon_room1/V1_02_medium/';
urlFilename= 'V1_02_medium';
urlFileext= '.zip';
localPathPrefix= 'im_';
ret= mkDataInfo( dataId, urlPath, urlFilename, urlFileext, localPathPrefix );
return


function ret= mkData1x
dataId= 'imdata1x';
urlPath= 'http://www.isr.tecnico.ulisboa.pt/~jag/data/vi_odometry/';
urlFilename= 'im_V1_02_medium_extra';
urlFileext= '.zip';
localPathPrefix= '';
ret= mkDataInfo( dataId, urlPath, urlFilename, urlFileext, localPathPrefix );
ret.mkfolder= 'im_V1_02_medium/mav0/cam0/data_extra';
return


function ret= mkData2( dataId, fname )
ret= mkDataInfo( dataId, 'http://rpg.ifi.uzh.ch/datasets/davis/', ...
    fname, '.zip', 'ev_');
return


function ret= mkDataInfo( dataId, urlPath, urlFilename, urlFileext, localPathPrefix )
dname=  [localPathPrefix urlFilename];
ofname= [dname urlFileext];
ret= struct('dataId',dataId, ...
    'url', [urlPath, urlFilename, urlFileext], ...
    'ofname', ofname, ...
    'mkfolder', dname );
