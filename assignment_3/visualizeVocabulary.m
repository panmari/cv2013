%% Initialize workspace and vl
run('vlfeat-0.9.17/toolbox/vl_setup')
%% Clustering with k clusters for showing bags
run('bagOfWords');
%% show words
for i=randsample(1:k, 2)
    idxs = find(assignments == i);
    figure('name', sprintf('Examples for word number %d', i));
    subplotpos = 1;
    for j=idxs
        % find image belonging to idx j
        img_idx = img_idxs(j);
        d = getPatchFromSIFTParameters(all_positions(:,j), all_scales(:,j), ...
            all_orients(:,j), imgs(:,:,img_idx));
        if subplotpos <= 25
            subplot(5,5,subplotpos);
            imshow(d, [0 255]);
            % for showing normalized images
            % imshow(d, [min(min(d)) max(max(d))]); 
        end
        subplotpos = subplotpos + 1;
    end
end
