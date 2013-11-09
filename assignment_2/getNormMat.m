function m = getNormMat(x)
% Takes a vector with homogeneous coordinates (3xN) and normalizes it
% Normalization is done by subtracting centroid and reducing the 
% mean distance to some threshold (see avg_dist below)
    center = mean(x, 2);
    distances = sum((x - repmat(center,1,length(x))).^2, 1);
    mean_distance = mean(distances);
    avg_dist = 2; % desired average distance, 2 pixel in our case
    m = [avg_dist/mean_distance 0 -avg_dist/mean_distance*center(1);...
        0 avg_dist/mean_distance -avg_dist/mean_distance*center(2);...
        0 0 1];
end
