function fname = ObserveLandmarks_findfile(dirImage, fileImages, IdxImage, ext, fname)

if exist(fname, 'file')
    % do nothing
    return
end

% fname = strcat(dirImage, int2str(fileImages(IdxImage)), '.png');
% ^ this process failed because of the small mantissa in the input of int2str(.)

fname2= [dirImage int2str(fileImages(IdxImage))];
d= dir([fname2(1:end-4) '*' ext]);

if length(d)<1
    warning('found no files "%s"', fname2)
    return
end

if length(d)>1
    warning('found more than one files "%s"', fname2)
end

fname= [dirImage d(1).name];

return
