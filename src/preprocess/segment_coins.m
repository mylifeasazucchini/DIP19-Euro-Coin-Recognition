% Detect coins in a calibrated image.
function [centers, radii] = segment_coins(I, checkerboard_points, board_size)
    I_hsv = rgb2hsv(I);
    Iv = I_hsv(:, :, 3);
    Iv_covered = remove_checkerboard(Iv, checkerboard_points, board_size);
    T = graythresh(Iv_covered);

    I_otsu = ~imbinarize(Iv, T);
    I_otsu = imopen(imclose(I_otsu, ones(10)), ones(3));

    [centers, radii, metric] = imfindcircles(I_otsu, [10 size(Iv, 1)], ...
                                             'ObjectPolarity', 'bright', ...
                                             'Sensitivity', 0.9);
    METRIC_THRESHOLD = 0.15;
    centers = centers(metric > METRIC_THRESHOLD, :);
    radii = radii(metric > METRIC_THRESHOLD, :);
end
