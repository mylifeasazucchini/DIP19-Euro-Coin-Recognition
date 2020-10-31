% Read all images in a directory to a cell array, without recursion.
function [imgs, fnames] = imreads(dirpath)
    paths = dir(strcat(dirpath, '/*'));

    files = struct(paths(1));
    files(1) = [];
    for i = 1:length(paths)
        if ~paths(i).isdir
            files(end+1) = paths(i);
        end
    end
    fnames = arrayfun(@(f) strcat(f.folder, "/", f.name), files);

    imgs = arrayfun(@imread, fnames, 'UniformOutput', false);
end
