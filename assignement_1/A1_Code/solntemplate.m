%% Main script file to run the algorith

clear all;
close all;
tic
nDir = 12;

% Put your code here
%method = 0; % default light directions
method = 1; % computed light directions from chrome sphere
L = getLightDir(method,'../Images/chrome/', nDir, true);

img_name = 'rock';
img_folder = ['../Images/', img_name, '/'];
mask = imread([img_folder, img_name, '.mask.png']);
mask = mask(:,:,1) / 255.0;

parfor n=1:nDir
    fname = [img_folder, img_name, '.',num2str(n-1),'.png'];
    im = double(imread(fname, 'png'));
    imLuminances(:,:,n) = im(:,:,1)*0.299+im(:,:,2)*0.587+im(:,:,3)*0.114;  % computes luminance of each pixel
    imData(:,:,:,n) = im(:,:,:);
end

%% compute normals and albedo in grayscale
% todo: use masks?
[n, albedo] = fitReflectance(imLuminances, L);

%% compute albedo of all color channels by using normal
[x_max, y_max, ndir, ~] = size(imData);
color_albedo = zeros(x_max, y_max, 3);
parfor x=1:x_max
    for y=1:y_max
        % normals not on buddha may be nan -> only compute for buddha
        if mask(x,y) == 1
            colors_xy = reshape(imData(x,y,:,:), 3, []);
            normals_xy = reshape(n(x,y,:), 3, []);
            % problematic step for nans:
            color_albedo(x,y,:) = colors_xy*pinv(normals_xy'*L);
        end
    end
end

%% compute depth using normals
depthmap = getDepthFromNormals(n, mask);

%% stops timer
toc

%% show of stuff
subplot(2,2,1), imshow((n+1)/2)
subplot(2,2,2), imshow(albedo/max(max(albedo)));
subplot(2,2,3), imshow(color_albedo/255)

