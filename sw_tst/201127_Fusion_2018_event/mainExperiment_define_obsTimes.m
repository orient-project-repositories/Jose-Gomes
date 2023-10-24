function obsTimes = mainExperiment_define_obsTimes(tIMU, ParamGlobal)

obsTimes = zeros(length(tIMU),1);

offset = 0.02;

j=1;
next = ParamGlobal.Slice.tEnd + j * ParamGlobal.PerCam +offset;

for i = 2:length(tIMU)-1
    if next > tIMU(i) && next < tIMU(i+1)
        obsTimes(i) = 1;
        j = j + 1;
        next = ParamGlobal.Slice.tEnd + j * ParamGlobal.PerCam +offset;
    end
end

%
