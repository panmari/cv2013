function [ output_args ] = epipolarLineEstimate(img_left, img_right )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    f = figure('name', 'Specify easy to localize points on the left image');
    hold on
    imshow(img_left);
    [x_l,y_l] = getpts(f);
    hold on
    plot(x_l, y_l, 'or');
    set(f, 'name', 'Done!');
    f2 = figure('name', 'Specify corresponding points on the right image');
    imshow(img_right);
    
    [x_r,y_r] = getpts(f2);
    close(f)
    close(f2)

end


function yi = getLuminanceImg(Im)
  yi=Im(:,:,1)*0.299+Im(:,:,2)*0.587+Im(:,:,3)*0.114;
end