%addpath('../io');
%addpath('../preprocess');
%addpath('../classify');
%addpath('..');


[measurements, fnames] = imreads('../../img/Measurements/');
dark = {zeros(size(measurements{1}))};
flat = {ones(size(measurements{1}))};
bias = {zeros(size(measurements{1}))};

truth = [1 1 1 1 1 1; ...
         0 0 1 0 1 3; ...
         1 1 5 0 0 1; ...
         3 1 3 0 0 0; ...
         3 1 4 0 1 0; ...
         2 0 1 0 3 0; ...
         0 0 3 0 1 0; ...
         3 0 4 1 0 0; ...
         3 1 0 0 0 0; ...
         0 0 4 1 0 0; ...
         0 0 5 1 3 0; ...
         0 0 1 1 3 0];

n = length(measurements);
total_errors = 0;
for i = 1:n
    I = measurements{i};
    coins = estim_coins(I, dark{1}, flat{1}, bias{1});
    disp(fnames{i});
    disp(coins);
    err = coins-truth(i, :)
    total_errors = total_errors + sum(abs(err));
end

disp(sum(truth(:)));
disp(total_errors);
