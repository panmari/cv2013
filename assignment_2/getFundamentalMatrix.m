function [ fundamental ] = getFundamentalMatrix(left, right)
% Returns the fundamental matrix corresponding to the given corresponding
% points.
%   left, right are N > 8 corresponding points (Nx2 vectors)
    %% make coordinates homogeneous, resulting in 3xN vectors
    left_hom = [left, ones(length(left), 1)]';
    right_hom = [right, ones(length(right), 1)]';
    %% normalize 
    norm_mat_l = getNormMat(left_hom);
    norm_mat_r = getNormMat(right_hom);
    normed_left = norm_mat_l*left_hom;
    normed_right = norm_mat_r*right_hom;
    %% estimate fundamental matrix using points specified
    % using svd to easily restrict matrix to given constraints
    % |F| = 1 and x'Fx = 0.
    eightPointMat = [repmat(normed_right(1,:)', 1,3) .* normed_left',...
    repmat(normed_right(2,:)', 1,3) .*normed_left',...
    normed_left(1:3,:)'];
    [U, S, V] = svd(eightPointMat);
    fundamental_normed = reshape(V(:, end),3,3)';
    %% ensure rank 2 by taking svd and discarding smallest eigenvalue/vector
    [u_fund,s_fund,v_fund] = svd(fundamental_normed);
    fundamental_normed_ranked = u_fund*diag([s_fund(1,1) s_fund(2,2) 0])*v_fund';
    fundamental = norm_mat_r' * fundamental_normed_ranked * norm_mat_l;
end

