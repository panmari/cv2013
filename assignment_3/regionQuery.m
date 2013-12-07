%% Make bag of words
%run('bagOfWords')

%% select region, compute bag of words of region
nrImages = size(imgs, 3);
queryImg = 30;
positions = all_positions(:, img_idxs == queryImg);
selected = selectRegion(imgs(:,:,queryImg)/255, positions');
assignments_img = assignments(:, img_idxs == queryImg);
assignments_region = assignments_img(:, selected);
hist = histc(assignments_region, 1:length(centers));

%% term frequency - inverse document frequency
hist_all = histc(assignments, 1:length(centers));
weighted_hist = hist/sum(hist).*log(sum(hist_all)/hist_all);

%% find images that match weighted hist closest
similarities = computeSimilarities(histograms, weighted_hist', nrImages);

%% Show 3 images with closest histograms
figure
for similarImg=1:3
    subplot(1, 3, similarImg);
    imshow(imgs(:,:,similarities(similarImg, 2)), [0 255]);
end