% Calculate k such that distance_mm = k * distance_px
% using a checkerboard with known square widths.
function k = scale_factor(checkerboard_points, board_size);
    if size(checkerboard_points, 1) > 0
        [topleft, botleft, botright, topright] = ...
            checkerboard_corners(checkerboard_points, board_size);

        h = board_size(1);
        w = board_size(2);
        WIDTH_MM = 12.5;
        width_px = mean([norm(topleft-botleft)/h...
                         norm(botleft-botright)/w...
                         norm(botright-topright)/h...
                         norm(topright-topleft)/w
                        ]);
        k = WIDTH_MM / width_px;
    else
        k = 1;
    end
end
