%% Main script file to run the algorith

clear all;
close all;

nDir = 12;

% Put your code here
%method = 0; % default light directions
method = 1; % computed light directions from chrome sphere
L = getLightDir(method,'../Images/chrome/', nDir, true);

img_name = 'buddha';
img_folder = ['../Images/', img_name, '/'];
mask = imread([img_folder, img_name, '.mask.png']);
mask = mask(:,:,1) / 255.0;

parfor n=1:nDir
    fname = [img_folder, img_name, '.',num2str(n-1),'.png'];
    im = double(imread(fname, 'png'));
    imLuminances(:,:,n) = im(:,:,1)*0.299+im(:,:,2)*0.587+im(:,:,3)*0.114;  % computes luminance of each pixel
end

%% compute normals and albedo in grayscale
% todo: use masks?
[n, albedo] = fitReflectance(imLuminances, L);
% and show them
imshow((n+1)/2);
imshow(albedo/max(max(albedo)));

%% TODO: compute albedo of all color channels by using normal




