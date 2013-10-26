%% Main script file to run the algorithm

%clear all;
close all;
tic
nDir = 12;

method = 1; % 1 for computed light directions from chrome sphere, 0 for default
L = getLightDir(method,'../Images/chrome/', nDir, true);
scene_names = {'rock', 'buddha', 'owl', 'horse', 'cat', 'gray'};  
%scene_names = {'rock'};
for img_name_str = scene_names;
    img_name = char(img_name_str);
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
            % normals not on object may be nan -> only compute on object
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
    figure
    %subplot(2,2,1), imshow((n+1)/2)
    img_n = abs(n);
    mask3d = repmat(mask, [1,1,3]);
    img_n(mask3d == 0) = 0;
    subplot(2,2,1), imshow(img_n);
    img_albedo = albedo/max(max(albedo));
    subplot(2,2,2), imshow(img_albedo);
    img_color_albedo = color_albedo/255;
    subplot(2,2,3), imshow(img_color_albedo);
    imwrite(img_n, [img_name, '_n.png']);
    imwrite(img_albedo, [img_name, '_a.png']);
    imwrite(img_color_albedo, [img_name, '_ca.png']);

    %% show depthmap
    depthmap_img = depthmap;
    depthmap_img(mask == 0) = 0;
    depthmap_img(mask == 1) = depthmap(mask == 1) + abs(min(min(depthmap(mask == 1))));
    depthmap_img(mask == 1) = depthmap_img(mask == 1)/max(max(depthmap_img(mask == 1)));
    depthmap_img(mask == 1) = 1 - depthmap_img(mask == 1); % invert to have dark colors far away
    subplot(2,2,4), imshow(depthmap_img);
    imwrite(depthmap_img, [img_name, '_d.png']);
end
%% create latex matrix of light directions
latex_lights = '';
row = 0;
for l=reshape(L, 1, [])
    latex_lights = [latex_lights, sprintf('%0.4f',l), ' & '];
    row = row + 1;
    if mod(row, 3) == 0
        latex_lights = [latex_lights(1:(length(latex_lights)-2)), '\\ '];
    end
end
s = sprintf('%s',latex_lights);
disp(s);
L_def = getLightDir(0,'../Images/chrome/', nDir, true);
mean_square_error_lights = mean(sum((L - L_def).^2))
