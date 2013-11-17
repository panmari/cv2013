
scene = 'tsukuba'; % either tsukuba or rock;
img_left = imread(['Stereo Pairs/' scene '-l.tiff']);
img_right = imread(['Stereo Pairs/' scene '-r.tiff']);
 %% let user specify corresponding points   
[left, right] = cpselect(img_left, img_right, 'Wait', true);

%% Left is base image
F = getFundamentalMatrix(left, right);
% Verify F, should be zero (or close to)
s = 0;
for i=(1:8)
    s = s + [left(i,:), 1]*F*[right(i,:),1]';
end
disp (s/8)
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
% F = K' E inv(K)
% K taken from file, K of inital view is assumed to be id
K =  [  -83.33333     0.00000   250.00000;
     0.00000   -83.33333   250.00000;
     0.00000     0.00000     1.00000];
 E = inv(K')*F;
 sprintf('Essential Matrix:')
 disp(E)
 %% Estimate R, T via SVD
 [U, D, V] = svd(E);
 W = [0 -1 0;
     1 0 0 ;
     0 0 1; ];
 trans = V*W*D*V';
 rot = U*inv(W)*V';
 %% TODO: reconstrucht 3D points
 
 %% TODO: show reconstructed point cloud
 