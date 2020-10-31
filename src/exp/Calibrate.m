clc
clear all

%% Unzipping files
% f_flat = untar('DIIP-images-flat');
% f_dark = untar('DIIP-images-dark');
% f_bias = untar('DIIP-images-bias');
% f_measurements_2 = untar('DIIP-images-measurements-2');
% f_measurements_1 = untar('DIIP-images-measurements-1');

%% Extracting Images from Folder and assigning Labels 

imds = imageDatastore('DIIP-images','IncludeSubfolders',true, 'LabelSource','foldernames');
imgs = readall(imds);

idd = find(imds.Labels == 'Dark');
dark = imgs(idd);
idf = find(imds.Labels == 'Flat');
flat = imgs(idf);
idb = find(imds.Labels == 'Bias');
bias = imgs(idb);
idm = find(imds.Labels == 'Measurements');
measurements = imgs(idm);

clearvars idd idf idb idm % clear redundant variables

%% RGB -> GRAYSCALE for intensity calibration 

dark_h = cellfun(@rgb2hsv,dark,'UniformOutput',false);
bias_h = cellfun(@rgb2hsv,bias,'UniformOutput',false);
flat_h = cellfun(@rgb2hsv,flat,'UniformOutput',false);
measurements_h = cellfun(@rgb2hsv,measurements,'UniformOutput',false);

%% Taking the Intensity Component

D_H = cellfun(@dim3,dark_h,'UniformOutput',false);
B_H = cellfun(@dim3,bias_h,'UniformOutput',false);
F_H = cellfun(@dim3,flat_h,'UniformOutput',false);
M_H = cellfun(@dim3,measurements_h,'UniformOutput',false);



%% Intensity Calibration Computation

dm = mean(cat(3, D_H{:}), 3);
bm = mean(cat(3, B_H{:}), 3);
fm = sum(cat(3, F_H{:}), 3);
normF = fm / (mean(fm(:)));

%% Removing Checkerboard from Flatfield
[imagePoints, boardSize] = detectCheckerboardPoints(normF);
normF2 = remove_checkerboard(normF, imagePoints, boardSize);
imshow(normF2)
%% Displaying and storing calibrated Images
destinationFolder = '/net/homes/LUTStudent/r7112/r7112/Documents/DIP/Calibrated_Images2';

for i=1:length(M_H)
    New = ((M_H{i} - bm - dm) ./ normF2);
    img = imshow(New);
    image = double(image);
    baseFileName = sprintf('%d.png', i); 
    fullFileName = fullfile(destinationFolder, baseFileName);
    imwrite(New, fullFileName)
    pause
end









