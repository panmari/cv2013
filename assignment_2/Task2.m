%% Compute fundamental matrix of cow image
% just some points copied from Matched point set.rtf
fid = fopen('Matched Points/matches', 'r');
matched = fscanf(fid, '%d  %d  %d  %d', [4, inf]);
fclose(fid);

% only use a selection of matches
percentage = 10; % percentage of points used can be specified here
RandStream.setGlobalStream(RandStream('mcg16807','Seed',0)); % fix randomness
selection = rand(length(matched),1) <= percentage/100;
sprintf('Using %d samples', sum(selection))
right = matched(1:2, selection)';
left = matched(3:4, selection)';

F = getFundamentalMatrix(right, left);
sprintf('Fundamental Matrix with rank %d:', rank(F))
disp(F);
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
 gt_rot = [0.92848  -0.12930   0.34815;
   0.00000   0.93744   0.34815;
  -0.37139  -0.32325   0.87039 ];
gt_trans =     [0 -5 2;
               5  0 -2;
               -2 2 0];
gt_E = gt_rot * gt_trans; % wikipedia definition
%gt_E = gt_trans * gt_rot; % slides definition
%% GROUND TRUTH, ALL THE THINGS! todo: fix my essential matrix
Rl = [ 1.00000   0.00000   0.00000
   0.00000   0.92848   0.37139
   0.00000  -0.37139   0.92848 ];
Tl = [ 0 -5 2
       5 0 0
      -2 0 0 ];
gt_E = Rl * Tl;
%E = gt_E;
%% Estimate R, T via SVD (works when using gt)
[U, D, V] = svd(E);
W = [0 -1 0;
      1 0 0 ;
      0 0 1 ; ];
trans = V*W*D*V';
rot = U*inv(W)*V';
alt_trans = V * [ 0 1 0; -1 0 0; 0 0 0] * V';
t = [trans(6), trans(7), trans(2)];
%% reconstruct 3D points
z = zeros(1, length(left));
for i=1:length(left)
     z(i) = dot((rot(1,:) - right(i,1)*rot(3,:)),t)/...
         dot((rot(1,:) - right(i,1)*rot(3,:)),[left(i,:),1]);
end
left_xyz = [left'; z];
%% show reconstructed point cloud
scatter3(left_xyz(1,:).*left_xyz(3,:), left_xyz(2,:).*left_xyz(3,:), left_xyz(3,:), '.')
 
 