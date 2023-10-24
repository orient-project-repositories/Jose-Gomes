function helperSaveData(trajs, dataset, ParamGlobal, eklt)

% file_out = sprintf('./results/trajs_%s_freq%d_batch%.2f_block%.2f_dispx%.2f_lk%.2f_maxc%.2f_minc%.2f_maxiter%.2f_mindist%.2f_pyr%.2f_patch%.2f_qual%.2f_scale%.2f_trqual%.2f.mat', dataset, ParamGlobal.freqCam, eklt.batches,eklt.blocks, eklt.EKLT_DISPLACEMENT_PX, eklt.windows, eklt.EKLT_MAX_CORNERS, eklt.EKLT_MIN_CORNERS, eklt.EKLT_MAX_NUM_ITERATIONS, eklt.min_dists, eklt.pyr_layers, eklt.patches, eklt.quals, eklt.EKLT_SCALE, eklt.track_quals);

file_out = sprintf('./results/trajs-%s-freq%d-batch%.2f-block%.2f-dispx%.2f-lk%.2f-maxc%.2f-minc%.2f-maxiter%.2f-mindist%.2f-pyr%.2f-patch%.2f-qual%.2f-scale%.2f-trqual%.2f.mat', dataset, ParamGlobal.freqCam, eklt.batches,eklt.blocks, eklt.EKLT_DISPLACEMENT_PX, eklt.windows, eklt.EKLT_MAX_CORNERS, eklt.EKLT_MIN_CORNERS, eklt.EKLT_MAX_NUM_ITERATIONS, eklt.min_dists, eklt.pyr_layers, eklt.patches, eklt.quals, eklt.EKLT_SCALE, eklt.track_quals);
save(file_out, 'trajs');

end
