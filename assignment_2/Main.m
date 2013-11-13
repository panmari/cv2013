
scene = 'tsukuba'; % either tsukuba or rock;
img_left = imread(['Stereo Pairs/' scene '-l.tiff']);
img_right = imread(['Stereo Pairs/' scene '-r.tiff']);
 %% let user specify corresponding points   
[left, right] = cpselect(img_left, img_right, 'Wait', true);

%% Left is base image
F = getFundamentalMatrix(left, right);
%% compute epipolar lines
point = [308, 40];
imshow(img_left)
hold on
plot(point(1), point(2), 'or')
l = F*[point ,1]';
x1 = -l(3)/l(1);
x2 = (-288*l(2) - l(3))/l(1);
figure, imshow(img_right)
hold on
plot([x1,x2], [0,288], 'r')
%% compute epipoles
epipoles = null(F); 