%% Make bag of words
run('bagOfWords')
%% Do histograms
nrImages = 19;
queryImg = 1;

for img=1:nrImages
    img_assignments = assignments(find(img_idxs == img));
    histograms(:,img) = histc(img_assignments, 1:length(centers));
end
%% find closest match
error = 1000000000;

for img=1:nrImages
    error = sum(histograms(:,img).*histograms(:,queryImg))/...
        (norm(histograms(:,img) * norm(histograms(:,queryImg))))
    
end

