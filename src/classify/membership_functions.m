% Create the membership functions for each feature for each currency.
function mfs = membership_functions()
    mfs = cell(4, 3);
    D = 1; H = 2; S = 3;

    nordig_gold_hue = @(x) trapmf(x, [0.06 0.07 0.12 0.13]);
    no_sat_diff = @(x) trapmf(x, [-0.15 -0.05 0.05 0.15]);
    normal_diameter = @(mean) (@(x) gaussmf(x, [1.8 mean+0.5]));
    
    % 5 cent coin
    mfs{1, D} = normal_diameter(21.25);
    mfs{1, H} = @(x) trapmf(x, [.02 .025 .06 .07]);
    mfs{1, S} = no_sat_diff;

    % 10 cent coin
    mfs{2, D} = normal_diameter(19.75);
    mfs{2, H} = nordig_gold_hue;
    mfs{2, S} = no_sat_diff;

    % 20 cent coin
    mfs{3, D} = normal_diameter(22.25);
    mfs{3, H} = nordig_gold_hue;
    mfs{3, S} = no_sat_diff;

    % 50 cent coin
    mfs{4, D} = normal_diameter(24.25);
    mfs{4, H} = nordig_gold_hue;
    mfs{4, S} = no_sat_diff;

    % 1 euro coin
    mfs{5, D} = normal_diameter(23.25);
    mfs{5, H} = nordig_gold_hue;
    mfs{5, S} = @(x) zmf(x, [-0.15 -0.03]);

    % 2 euro coin
    mfs{6, D} = normal_diameter(25.75);
    mfs{6, H} = nordig_gold_hue;
    mfs{6, S} = @(x) smf(x, [0.03 0.15]);
end
