%% Initialize workspace and vl
load('sift/twoFrameData.mat')
run('vlfeat-0.9.17/toolbox/vl_setup')
im = single(rgb2gray(im1));
%% cluster!
[centers, assignments] = vl_kmeans(descriptors1', 1500/20);
%% show words
for i=1:2
    idxs = find(assignments == i);
    figure
    subplotpos = 1;
    for j=idxs
        d = getPatchFromSIFTParameters(positions1(j,:), scales1(j,:), orients1(j,:), im);
        subplot(5,5,subplotpos);
        imshow(d/255);
        subplotpos = subplotpos + 1;
    end
    figure
    displaySIFTPatches(positions1(idxs,:),  scales1(idxs,:), orients1(idxs,:), im1);
end
