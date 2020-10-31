%pkg load image;

addpath('../io');
addpath('../preprocess');
addpath('../classify');

mfs = membership_functions();
coinstrs = {"5c", "10c", "20c", "50c", "1eur", "2eur"};

Is = imreads('../../img/Measurements/');
n = 1;
n = length(Is);
for i = 1:n
    I = Is{i};
    %I = imread('../../img/Measurements/_DSC1774.JPG');
    I = imresize(I, 0.2);

    [checkerboard_points, board_size] = detectCheckerboardPoints(I);
    k = scale_factor(checkerboard_points, board_size);
    I_hsv = rgb2hsv(I);
    Iv = I_hsv(:, :, 3);

    Iv_covered = remove_checkerboard(Iv, checkerboard_points, board_size);
    [centers, radii] = segment_coins(Iv, Iv_covered);

    nc = size(centers, 1);
    features = zeros(nc, 3);
    f = figure('visible', false); imshow(I)
    for j = 1:nc;
        c = centers(j, :);
        r = radii(j);
        features(j, :) = extract_features(c, r, I_hsv, k);
        coin = classify_coin(features(j, :), mfs);
        text(c(1), c(2), strcat(int2str(j), ':', coinstrs{coin}));
    end
    features

    viscircles(centers, radii);
    fname = strcat('../../out/circles', int2str(i), '.png');
    saveas(f, fname);
end
