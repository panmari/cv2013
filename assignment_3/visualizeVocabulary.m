%% Initialize workspace and vl
load('sift/twoFrameData.mat')
run('vlfeat-0.9.17/toolbox/vl_setup')
im = single(rgb2gray(im1));
%% Show error for different cluster sizes
es = [];
for k=1:100
    [~, ~, e] = vl_kmeans(descriptors1', k);
    es = [es, e];
end
plot(es);
%% Cluster with k=25 for showing bags
k = 25;
[centers, assignments, e] = vl_kmeans(descriptors1', k);
fprintf('Made %d words, error: %f \n', k, e);
%% show words
for i=randsample(1:k, 2)
    idxs = find(assignments == i);
    figure
    subplotpos = 1;
    for j=idxs
        d = getPatchFromSIFTParameters(positions1(j,:), scales1(j,:), orients1(j,:), im);
        if subplotpos <= 25
            subplot(5,5,subplotpos);
            imshow(d/255);
        end
        subplotpos = subplotpos + 1;
    end
    figure
    displaySIFTPatches(positions1(idxs,:),  scales1(idxs,:), orients1(idxs,:), im1);
end
