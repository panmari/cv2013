% This script reads in all images, does compile words, and bag of words

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
k = 1500;
fprintf('Clustering %d words with %d descriptors, this might take some time... ', k, length(all_descriptors));
tic
% See http://www.vlfeat.org/sandbox/overview/kmeans.html for a description
% of available algorithms for kmeans
[centers, assignments, energy] = vl_kmeans(single(all_descriptors), k, ...
    'Algorithm', 'ANN', 'MaxNumComparisons', ceil(k / 50));
toc
fprintf('Done! Energy: %f \n', energy);
