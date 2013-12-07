%% Make bag of words
%run('bagOfWords')
%% Assemble histograms (same as in FullFrameQueries)
histograms = assembleHistograms(assignments, centers, img_idxs, nrImages);

%% select region, compute bag of words of region
nrImages = size(imgs, 3);
queryImg = 15;
positions = all_positions(:, img_idxs == queryImg);
selected = selectRegion(imgs(:,:,queryImg)/255, positions');
fprintf('Number of descriptors in region: %d', sum(selected));
assignments_img = assignments(:, img_idxs == queryImg);
assignments_region = assignments_img(:, selected);
hist = histc(assignments_region, 1:length(centers));

%% term frequency - inverse document frequency
hist_all = histc(assignments, 1:length(centers));
weighted_hist = hist/sum(hist).*log(sum(hist_all)./hist_all);
%plot(weighted_hist);           % show weighted hist for debugging

%% find images that match weighted hist closest
similarities = computeSimilarities(histograms, weighted_hist', nrImages);

%% Show 3 images with closest histograms
figure
iptsetpref('ImshowBorder','tight');
subplot(2,3, 2);
imshow(imgs(:,:,queryImg), [0 255]);
hold on;
scatter(positions(1,selected), positions(2,selected), 'r.');
for similarImg=1:3
    subplot(2, 3, 3 + similarImg);
    imshow(imgs(:,:,similarities(similarImg, 2)), [0 255]);
end