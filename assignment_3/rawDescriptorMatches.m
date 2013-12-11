%% Initialize workspace and select region
load('twoFrameData.mat')
figure
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
fprintf('Mean error for all matches: %f \n', mean(idxs(:, 1)));
idxs_show = idxs %idxs(1:10, :); % top ten
fprintf('Mean error for 10 best matches: %f \n', mean(idxs_show(:, 1)));
figure
displaySIFTPatches(positions2(idxs_show(:,2),:), ...
    scales2(idxs_show(:,2),:), orients2(idxs_show(:,2),:), im2);
