%% Make bag of words
%run('bagOfWords')
%% Do histograms
nrImages = size(imgs, 3);
queryImg = 30;

for img=1:nrImages
    img_assignments = assignments(find(img_idxs == img));
    histograms(:,img) = histc(img_assignments, 1:length(centers));
end
%% find closest match
similarities = [];

for img=1:nrImages
    if img == queryImg
        continue;
    end
    sim = sum(histograms(:,img).*histograms(:,queryImg))/...
        (norm(histograms(:,img) * norm(histograms(:,queryImg))));
    similarities = [similarities; sim img];
end

similarities = sortrows(similarities);
similarities = flipud(similarities);
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