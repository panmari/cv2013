%% Compute fundamental matrix of cow image
% just some points copied from Matched point set.rtf
fid = fopen('Matched Points/matches', 'r');
fscanf(fid, '%d  %d  %d  %d', [4, inf]);
%TODO: only use a selection of matches
right = matched(:, 1:2);
left = matched(:, 3:4);
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
 % ground truth of E
 gt_E = [0.92848  -0.12930   0.34815;
   0.00000   0.93744   0.34815;
  -0.37139  -0.32325   0.87039 ];
gt_E =  [0 -5 2;
                5 0 -2;
                -2 2 0] * gt_E;
               
%% Estimate R, T via SVD
[U, D, V] = svd(E);
W = [0 -1 0;
      1 0 0 ;
      0 0 1 ; ];
trans = V*W*D*V';
rot = U*inv(W)*V';
alt_trans = V * [ 0 1 0; -1 0 0; 0 0 0] * V';
t = [alt_trans(6), alt_trans(7), alt_trans(2)];
 
%% reconstruct 3D points
z = zeros(1, length(left));
for i=1:length(left)
     z(i) = dot((rot(2,:) - right(i,2)*rot(3,:)),t)/...
         dot((rot(2,:) - right(i,2)*rot(3,:)),[left(i,:),1]);
end
left_xyz = [left'; z];
%% show reconstructed point cloud
plot3(left_xyz(1,:), left_xyz(2,:), left_xyz(3,:))
 
 