function mainExperiment_2_tst( tstId )
if nargin<1
    tstId= 1;
end

    
switch tstId
    case 0, mainExperiment_2( dataset )

    case 1
        for freqCam= [50 100 200 400]
            opt= struct('freqCam', freqCam );
            mainExperiment_2( dataset, opt );
        end
     case 2
        for freqCam= [50 100 200 400]
            opt= struct('freqCam', freqCam , 'NbStepsMax', 400);
            mainExperiment_2( dataset, opt );
        end   
    otherwise
        error('inv tstId')
end





function ret= default_value( defaultOpt, options, optName )
if isfield(options, optName)
    ret= getfield( options, optName );
else
    ret= defaultOpt;
end

end
