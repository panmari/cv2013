
scene = 'corridor'; % either tsukuba or rock;
img_left = imread(['Stereo Pairs/' scene '-l.tiff']);
img_right = imread(['Stereo Pairs/' scene '-r.tiff']);
 %% let user specify corresponding points   
[left, right] = cpselect(img_left, img_right, 'Wait', true);

%% Left is base image
F = getFundamentalMatrix(left, right);
% Verify F, should be zero (or close to)
s = [];
for i=(1:8)
    s = [s, [right(i,:), 1]*F*[left(i,:),1]'];
end
sprintf('Mean: %f, var: %f', mean(s), var(s))
%% compute epipolar lines for right
hold off
[width, height] = size(img_right);
imshow(img_left);
point = ginput(1); %[108, 150]; %on left img (base)
hold on
plot(point(1), point(2), 'or')
l = F*[point ,1]'; 
xlims = [-l(3)/l(1), 0, (-l(3)-height*l(2))/l(1), width];
ylims = [0, -l(3)/l(2), height, (-l(3)-width*l(1))/l(2)];
figure, imshow(img_right)
hold on
plot(xlims, ylims, 'r')

%% compute epipole right
% as intersection between two epipolar lines
epipole_r = null(F);
epipole_r = epipole_r/epipole_r(3);
plot(epipole_r(1), epipole_r(2), 'om');
sprintf('Epipole on right image:')
disp(epipole_r);

%% compute epipolar lines for left
hold off
[width, height] = size(img_left);
imshow(img_right);
point = ginput(1); %[108, 150]; %on left img (base)
hold on
plot(point(1), point(2), 'or')
l = F'*[point ,1]'; 
xlims = [-l(3)/l(1), 0, (-l(3)-height*l(2))/l(1), width];
ylims = [0, -l(3)/l(2), height, (-l(3)-width*l(1))/l(2)];
figure, imshow(img_left)
hold on
plot(xlims, ylims, 'r')
%% compute epipole right
% as intersection between two epipolar lines
epipole_l = null(F');
epipole_l = epipole_l/epipole_l(3);
plot(epipole_l(1), epipole_l(2), 'om');
sprintf('Epipole on left image:')
disp(epipole_l);

%% Compute fundamental matrix of cow image
% just some points copied from Matched point set.rtf
matchedPoints =  [263 180	274	180; 
    262	194	272	194;
    265	195	275	195;
    174	201	166	182;
    177	203	170	185;
    171	208	161	189;
    262	211	273	211;
    175	213	166	196;
    201	215	183	203;
    171	217	160	199;
    191	220	171	207];
left = matchedPoints(:, 1:2);
right = matchedPoints(:, 3:4);
F = getFundamentalMatrix(left, right);
sprintf('Rank: %d', rank(F))
%% Compute essential matrix of cow using intrinsic parameters
% F = inv(K') E inv(K)
% K taken from file
K =  [  -83.33333     0.00000   250.00000;
     0.00000   -83.33333   250.00000;
     0.00000     0.00000     1.00000];
 E = K'*F*K;
 sprintf('Essential Matrix:')
 disp(E)
 %% Estimate R, T via SVD
 [U, D, V] = svd(E);
 W = [0 -1 0;
      1 0 0 ;
      0 0 1 ; ];
 trans = V*W*D*V';
 rot = U*inv(W)*V';
 alt_trans = V * [ 0 1 0; -1 0 0; 0 0 0] * V';
 %% TODO: reconstrucht 3D points
 
 %% TODO: show reconstructed point cloud
 