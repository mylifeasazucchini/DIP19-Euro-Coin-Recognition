function coins = estim_coins(meas, dark, flat, bias)
    CALIBRATE_INTENSITY = 1;
    mfs = membership_functions();

    meas = rescale(meas);
    dark = rescale(dark);
    flat = rescale(flat);
    bias = rescale(bias);

    [checkerboard_points, board_size] = detectCheckerboardPoints(meas);
    if CALIBRATE_INTENSITY
        I = calibrate_intensity(meas, dark, flat, bias, ...
            checkerboard_points, board_size);
    else
        I = meas;
    end

    [centers, radii] = segment_coins(I, checkerboard_points, board_size);
    k = scale_factor(checkerboard_points, board_size);

    coins = zeros(1, 6);
    n = size(centers, 1);
    for j = 1:n;
        features = extract_features(centers(j, :), radii(j), I, k);
        coin = classify_coin(features, mfs);
        if coin > 0
            coins(coin) = coins(coin) + 1;
        end
    end
end
