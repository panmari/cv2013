%% Initialize workspace and vl
run('vlfeat-0.9.17/toolbox/vl_setup')
%% Concatenate descriptors of all images
framesdir = 'images/';
siftdir = 'sift/';
% Get a list of all the .mat files in that directory.
% There is one .mat file per image.
fnames = dir([siftdir '/*.mat']);

fprintf('reading %d total files...\n', length(fnames));
all_descriptors = [];
all_positions = [];
all_scales = [];
all_orients = [];
img_idxs = [];
for i = 1:length(fnames)
    load([siftdir fnames(i).name], 'imname', 'descriptors', 'positions', 'scales', 'orients','numfeats');
    all_descriptors = [all_descriptors, descriptors];
    all_positions = [all_positions, positions];
    all_scales = [all_scales, scales];
    all_orients = [all_orients, orients];
    imgs(:,:,i) = single(rgb2gray(imread(imname)));
    img_idxs = [img_idxs, repmat(i, [1 length(descriptors)])];
end
%% Clustering with k clusters for showing bags
run('bagOfWords');
%% show words
for i=randsample(1:k, 2)
    idxs = find(assignments == i);
    figure
    subplotpos = 1;
    for j=idxs
        % find image belonging to idx j
        img_idx = img_idxs(j);
        d = getPatchFromSIFTParameters(all_positions(:,j), all_scales(:,j), ...
            all_orients(:,j), imgs(:,:,img_idx));
        if subplotpos <= 25
            subplot(5,5,subplotpos);
            imshow(d, [0 255]);
        end
        subplotpos = subplotpos + 1;
    end
end
