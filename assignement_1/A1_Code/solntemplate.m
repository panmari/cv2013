%% Main script file to run the algorith

clear all;
close all;

nDir = 12;

% Put your code here
%method = 0; % default light directions
method = 1; % computed light directions from chrome sphere
L = getLightDir(method,'../Images/chrome/', nDir, true);

img_name = 'buddha'
img_folder = ['../Images/', img_name, '/']
mask = imread([img_folder, img_name, '.mask.png']);
mask = mask(:,:,1) / 255.0;

for n=1:nDir
    fname = [img_folder, img_name, '.',num2str(n-1),'.png'];
    im = imread(fname, 'png');
    imData(:,:,n) = im(:,:,1);           % red channel
end

