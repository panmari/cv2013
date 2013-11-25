%% Initialize workspace and select region
load('sift/twoFrameData.mat')
selected = selectRegion(im1, positions1);

%% Match descriptors on other image and display
% TODO: possibly remove matched descs from descriptors2
idxs = [];
for desc=descriptors1(selected,:)'
    sum_diff2 = dist2(desc', descriptors2);
    [c, i] = min(sum_diff2);
    % if below some threshold, add match
    if (c < 0.2)
        idxs = [idxs, i];
    end
end
sprintf('Found %d matches', length(idxs))
%idxs = sum(dist) < 240;
displaySIFTPatches(positions2(idxs,:),  scales2(idxs,:), orients2(idxs,:), im2);
