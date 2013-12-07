%% Make bag of words
%run('bagOfWords')
%% Do histograms
nrImages = size(imgs, 3);
queryImg = 30;
histograms = assembleHistograms(assignments, centers, img_idxs, nrImages);
%% find closest match
similarities = computeSimilarities(histograms, histograms(:, queryImg), nrImages);
% delete query img itself from similarity vector
similarities(similarities(:,2) == queryImg, :) = [];
%% show query img and 5 closest matches
% top left is query
% others sorted by similarity from left to right and top to bottom.
figure
subplot(4,2,1);
imshow(imgs(:,:,queryImg), [0 255]);
for similarImg=1:5
    subplot(4, 2, 2 + similarImg);
    imshow(imgs(:,:,similarities(similarImg, 2)), [0 255]);
end