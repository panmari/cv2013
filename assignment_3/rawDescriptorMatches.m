%% Initialize workspace and select region
load('sift/twoFrameData.mat')
selected = selectRegion(im1, positions1);

%% Match descriptors on other image
% TODO: possibly remove matched descs from descriptors2
idxs = [];
for desc=descriptors1(selected,:)'
    sum_diff2 = dist2(desc', descriptors2);
    [c, i] = min(sum_diff2);
    idxs = [idxs; c, i];
end
%% Display 10 best matches
idxs = sortrows(idxs, 1);
fprintf('Mean error for 10 best matches: %f \n', mean(idxs(1:10, 1)));
idxs = idxs(1:10, 2);
displaySIFTPatches(positions2(idxs,:),  scales2(idxs,:), orients2(idxs,:), im2);
