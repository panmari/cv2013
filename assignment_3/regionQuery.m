%% Make bag of words
%run('bagOfWords')

%% select region
nrImages = size(imgs, 3);
queryImg = 30;
positions = all_positions(:, img_idxs == img);
selected = selectRegion(imgs(:,:,queryImg)/255, positions);