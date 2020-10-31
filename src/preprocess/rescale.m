% Rescale an image before processing.
function I_new = rescale(I)
    h_wanted = 520;
    h_current = size(I, 1);
    I_new = imresize(I, h_wanted/h_current);
end
