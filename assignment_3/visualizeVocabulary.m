%% Initialize workspace and vl
load('sift/twoFrameData.mat')
run('vlfeat-0.9.17/toolbox/vl_setup')
im = single(rgb2gray(im1));
%% cluster!
k = 1500/20; % number of clusters
[centers, assignments] = vl_kmeans(descriptors1', k);
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
