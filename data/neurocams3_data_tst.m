function neurocams3_data_tst( tstId )
if nargin<1
    tstId= 50; %60; %50; %41; %40; %32; %30;
end

switch tstId
    case {30, 31}
        figure(30); clf
        if tstId==30
            ret= neurocams3_data( 'ims1_cam0' );
        else
            ret= neurocams3_data( 'ims1_cam1' );
        end
        imax= length(ret.iRange);
        for i= 1:imax
            fname= sprintf(ret.bfname, ret.iRange(i));
            imshow( fname )
            title( sprintf('img %i of %d', i, imax) )
            drawnow
            if aborttst, break; end
        end

    case 32
        figure(30); clf
        ret1= neurocams3_data( 'ims1_cam0' );
        ret2= neurocams3_data( 'ims1_cam1' );
        imax= length(ret1.iRange);
        for i= 1:imax
            f1= sprintf(ret1.bfname, ret1.iRange(i));
            f2= sprintf(ret2.bfname, ret2.iRange(i));
            % subplot(121); imshow( f1 )
            % subplot(122); imshow( f2 )
            img3= imread(f1); img3(:,:,2)= img3; img3(:,:,3)= imread(f2);
            imshow(img3)
            title( sprintf('img %i of %d', i, imax) )
            drawnow
            if aborttst, break; end
        end

    case 40
        figure(40); clf
        ret= neurocams3_data( 'ev_shapes_rotation' );
        imax= max(ret.iRange);
        for i= ret.iRange
            fname= sprintf(ret.bfname, i);
            imshow( fname )
            title( sprintf('img %i (max %d)', i, imax) )
            drawnow
            if aborttst, break; end
        end
        
    case 41
        pname= neurocams3_data( 'ev_shapes_rotation', struct('retJustPath',1) );
        fprintf(1, 'Main folder: %s\n', pname);

    case 42
        dataId= 'ev_shapes_rotation';
        ret= neurocams3_data( dataId );

        % example of one known filename
        fname= neurocams3_data( dataId, 'events.txt' );
        fprintf(1, '0: %s\n', fname);

        % example of *.txt
        d= dir( [ret.pname '*.txt'] );
        for i= 1:length(d)
            fname= neurocams3_data( dataId, d(i).name );
            fprintf(1, '%d: %s\n', i, fname);
        end
        

        
    case 50
        figure(50); clf
        ret= neurocams3_data( 'ev_boxes_rotation' );
        imax= max(ret.iRange);
        for i= ret.iRange
            fname= sprintf(ret.bfname, i);
            imshow( fname )
            title( sprintf('img %i (max %d)', i, imax) )
            drawnow
            if aborttst, break; end
        end
        
    case 60
        figure(60); clf
        ret= neurocams3_data( 'ev_translation_1_x' );
        imax= max(ret.iRange);
        for i= ret.iRange
            fname= sprintf(ret.bfname, i);
            imshow( fname )
            title( sprintf('img %i (max %d)', i, imax) )
            drawnow
            if aborttst, break; end
        end
        
    case 70
        figure(70); clf
        ret= neurocams3_data( 'ev_rotation_18_y' );
        imax= max(ret.iRange);
        for i= ret.iRange
            fname= sprintf(ret.bfname, i);
            imshow( fname )
            title( sprintf('img %i (max %d)', i, imax) )
            drawnow
            if aborttst, break; end
        end
        
    case 80
        figure(70); clf
        ret= neurocams3_data( 'ev_rotation_18_x' );
        imax= max(ret.iRange);
        for i= ret.iRange
            fname= sprintf(ret.bfname, i);
            imshow( fname )
            title( sprintf('img %i (max %d)', i, imax) )
            drawnow
            if aborttst, break; end
        end
        
    case 90
        figure(70); clf
        ret= neurocams3_data( 'ev_rotation_18_z' );
        imax= max(ret.iRange);
        for i= ret.iRange
            fname= sprintf(ret.bfname, i);
            imshow( fname )
            title( sprintf('img %i (max %d)', i, imax) )
            drawnow
            if aborttst, break; end
        end
    case 95
        figure(95); clf
        ret= neurocams3_data( 'ev_shapes_rotation' );
        imax= max(ret.iRange);
        for i= ret.iRange
            fname= sprintf(ret.bfname, i);
            imshow( fname )
            title( sprintf('img %i (max %d)', i, imax) )
            drawnow
            if aborttst, break; end
        end
        
    case 100
        figure(100); clf
        ret= neurocams3_data( 'tst_corner_room' );
        imax= max(ret.iRange);
        for i= ret.iRange
            fname= sprintf(ret.bfname, i);
            imshow( fname )
            title( sprintf('img %i (max %d)', i, imax) )
            drawnow
            if aborttst, break; end
        end
end
