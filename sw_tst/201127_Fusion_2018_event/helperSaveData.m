function helperSaveData(trajs, dataset, ParamGlobal)

file_out = sprintf('./results/trajs_%s_%d', dataset, ParamGlobal.freqCam);
save(file_out, 'trajs');

end
