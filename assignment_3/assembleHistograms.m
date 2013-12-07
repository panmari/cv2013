function histograms = assembleHistograms(assignments, centers, img_idxs, nrImages)
for img=1:nrImages
    img_assignments = assignments(img_idxs == img);
    histograms(:,img) = histc(img_assignments, 1:length(centers));
end