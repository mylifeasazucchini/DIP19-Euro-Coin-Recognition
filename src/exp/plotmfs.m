addpath('../io');
addpath('../preprocess');
addpath('../classify');

mfs = membership_functions();
coinstrs = {"5c", "10c", "20c", "50c", "1eur", "2eur"};

flats = imreads('../../img/Flat/');
%flats = imreads('../../img/Test/flat4/');
flats = cellfun(@rescale, flats, 'UniformOutput', false);
Is = imreads('../../img/Measurements/');
%Is = imreads('../../img/Test/meas4/');
%n = 1;
n = length(Is);
for i = 1:n
    I = Is{i};
    %I = imread('../../img/Test/_DSC2032.JPG');
    I = rescale(I);

    [checkerboard_points, board_size] = detectCheckerboardPoints(flats{1});
    I = calibrate_intensity(I, ...
        zeros(size(I)), flats{1}, zeros(size(I)), ...
        checkerboard_points, board_size);
    [centers, radii] = segment_coins(I, checkerboard_points, board_size);
    k = scale_factor(checkerboard_points, board_size);

    nc = size(centers, 1);
    features = zeros(nc, 3);
    f = figure('visible', false); imshow(I)
    coins_c = zeros(0, 2);
    coins_r = zeros(0, 1);
    for j = 1:nc;
        c = centers(j, :);
        r = radii(j);
        features(j, :) = extract_features(c, r, I, k);
        coin = classify_coin(features(j, :), mfs);
        if coin > 0
            text(c(1), c(2), strcat(int2str(j), ':', coinstrs{coin}));
            coins_c(j, :) = c;
            coins_r(j) = r;
        else
            text(c(1), c(2), strcat(int2str(j)));
        end
    end
    viscircles(coins_c, coins_r);
    fname = strcat('../../out/circles', int2str(i), '.png');
    saveas(f, fname);

    coin_count = size(mfs, 1);
    feature_count = size(mfs, 2);
    f1 = figure();
    ranges = [17 0.1 28; 0 0.01 0.2; -0.3 0.01 0.3];
    for j = 1:nc;
        for l = 1:feature_count
            x = ranges(l, 1):ranges(l, 2):ranges(l, 3);
            subplot(nc, 3, (j-1)*3+l);
            axis([ranges(l, 1) ranges(l, 3) 0 1]);
            hold on;
            xline(features(j, l));
            hold on;
            title(num2str(features(j, l)));
            for k = 1:coin_count
                f = mfs{k, l};
                plot(x, arrayfun(mfs{k, l}, x));
                hold on;
            end
        end
    end
    fname = strcat('../../out/circles', int2str(i), 'graphs.png');
    saveas(f1, fname);
end
