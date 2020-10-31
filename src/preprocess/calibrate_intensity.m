% Calibrate the intensity of an image.
function calibrated = calibrate_intensity(measurement, dark, flat, bias, ...
                                          checkerboard_points, board_size)
    D_hsv = rgb2hsv(dark);
    B_hsv = rgb2hsv(bias);
    F_hsv = rgb2hsv(flat);
    M_hsv = rgb2hsv(measurement);

    d = D_hsv(:, :, 3);
    b = B_hsv(:, :, 3);
    f = F_hsv(:, :, 3);
    m = M_hsv(:, :, 3);

    normF = f / (mean(f(:)));
    normF2 = remove_checkerboard(normF, checkerboard_points, board_size);

    calibrated_v = ((m - b - d) ./ normF2);
    calibrated_hsv = M_hsv;
    calibrated_hsv(:, :, 3) = calibrated_v;
    calibrated = hsv2rgb(calibrated_hsv);
end
