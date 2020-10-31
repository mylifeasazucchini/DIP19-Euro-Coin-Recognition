addpath('../io');
addpath('../preprocess');

%Is = imreads('../../img/Teams6-7');

%n = length(Is)
n = 1;
for i = 1:n
    %I = Is{i};
    I = imread('../../img/Teams6-7/_DSC1922.JPG');
    [imagePoints, boardSize] = detectCheckerboardPoints(I);
    h = boardSize(1)-2;
    w = boardSize(2)-2;
    f = figure;
    imshow(I);
    hold on;
    plot(imagePoints(:, 1), imagePoints(:, 2), 'ro');
    topleft = imagePoints(1, :);
    botleft = imagePoints(1+h, :);
    topright = imagePoints(end-h, :);
    botright = imagePoints(end, :);
    scale_factor(imagePoints, boardSize)*norm(topleft-botleft)/h
    plot(topleft(1), topleft(2), 'bo');
    plot(botleft(1), botleft(2), 'bo');
    plot(topright(1), topright(2), 'bo');
    plot(botright(1), botright(2), 'bo');
    fname = strcat('../../out/plot', int2str(i), '.png');
    saveas(f, fname);
end
