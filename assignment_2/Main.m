
scene = 'corridor'; % either tsukuba or rock;
img_left = imread(['Stereo Pairs/' scene '-l.tiff']);
img_right = imread(['Stereo Pairs/' scene '-r.tiff']);
 %% let user specify corresponding points   
[left, right] = cpselect(img_left, img_right, 'Wait', true);

%% Left is base image
F = getFundamentalMatrix(left, right);
%% compute epipolar lines
point = [108, 150]; %on left img (base)
imshow(img_left)
hold on
plot(point(1), point(2), 'or')
l = F*[point ,1]'; 
x1 = -l(3)/l(1);
y2 = -l(3)/l(2);
figure, imshow(img_right)
hold on
[width, height] = size(img_right);
plot([x1, 0], [0, y2], 'r')
%% compute epipoles
epipole_l = null(F); 
epipole_r = null(F'); 