pepper = double(imread('peppers.png'))/255;
N=200;
%% create gaussian noised images
for i=1:N
    p(:,:,:,i) = pepper + normrnd(0, 0.01, size(pepper));
end

%% do stuff
tic
length = sum(size(p_avg));
parfor i = 1:N
    p_avg = mean(p(:,:,:,1:i), 4);
    p_med = median(p(:,:,:,1:i), 4);
    mean_square_error(i) = norm(reshape(p_avg - pepper, 1, []))/length;
    mean_square_error_med(i) = norm(reshape(p_med - pepper, 1, []))/length;
end
toc
%% plot stuff
plot(mean_square_error)
hold on
plot(mean_square_error_med, 'color', 'red')