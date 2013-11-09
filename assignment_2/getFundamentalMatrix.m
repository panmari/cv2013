function [ fundamental ] = getFundamentalMatrix(img_left, img_right )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    %% let user specify corresponding points
    f = figure('name', 'Specify easy to localize points on the left image');
    f, imshow(img_left);
    f2 = figure('name', 'Right image');
    f2, imshow(img_right);
    [x_l, y_l] = getpts(f);
    hold on
    plot(x_l, y_l, 'or');
    set(f, 'name', 'Done!');
    
    set(f2, 'name', 'Specify corresponding points to left image');
    [x_r, y_r] = getpts(f2);
    close(f)
    close(f2)
    % make them homogeneous, resulting in 3xN vectors
    left = [x_l y_l ones(length(x_l), 1)]';
    right = [x_r y_r ones(length(x_r), 1)]';
    % normalize 
    norm_mat_l = getNormMat(left);
    norm_mat_r = getNormMat(right);
    normed_left = norm_mat_l*left;
    normed_right = norm_mat_r*right;
    % make matrix that is equivalent to linear system of 8p slide
    %% estimate fundamental matrix using points specified
    eightPointMat = [repmat(normed_right(1,:)', 1,3) .* normed_left',...
    repmat(normed_right(2,:)', 1,3) .*normed_left',...
    normed_left(1:3,:)'];
    [U, S, V] = svd(eightPointMat);
    fundamental_normed = reshape(V(:, end),3,3)';
    % ensure rank 2 by taking svd and discarding smallest eigenvalue/vector
    [u_fund,s_fund,v_fund] = svd(fundamental_normed);
    fundamental_normed_ranked = u_fund*diag([s_fund(1,1) s_fund(2,2) 0])*v_fund';
    fundamental = norm_mat_r' * fundamental_normed_ranked * norm_mat_l;
    disp(fundamental);
end

