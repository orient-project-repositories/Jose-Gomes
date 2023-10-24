function demo123_data_tst( tstId )
if nargin<1
    tstId= 2; %1;
end

switch tstId
    case 1
        show_dataset( '1' )
    case 2
        show_dataset( 'vrml_1' )
        show_dataset( 'vrml_2' )
        
    otherwise, error('inv tstId');
end

return; % end of main function


function show_dataset( dataId )
d1= demo123_data( dataId );
N= length( d1.iRange );
for i= 1:N
    figure(201); clf
    show_image( d1.bfname, d1.iRange, i );
    drawnow
    if aborttst, break; end % put mouse pointer on the windows "start" button
end


function show_image( bfname, iRange, i, options )
if nargin<4
    options= [];
end

N= length( iRange );
f1= filename_complete( bfname, iRange, i );

if isempty( options )
    imshow( f1 ); % ~101microsec/img
else
    img= imread(f1);
    if isfield(options, 'ssample')
        ss= options.ssample;
        img= img(1:ss:end, 1:ss:end, :);
    end
    image( img ); axis equal; % ~70microsec/img
end

mytitle( f1 )
xlabel( sprintf('%d of %d', i, N) )


function mytitle( fname )
[~, fn, ext]= fileparts( fname );
fn= strrep(fn, '_', '\_');
title( [fn ext] )
