function [depth] = getDepthFromNormals(n, mask)
  % [depth] = getDepthFromNormals(n, mask)
  %
  % Input:
  %    n is an [N, M, 3] matrix of surface normals (or zeros
  %      for no available normal).
  %    mask logical [N,M] matrix which is true for pixels
  %      at which the object is present.
  % Output
  %    depth an [N,M] matrix providing depths which are
  %          orthogonal to the normals n (in the least
  %          squares sense).
  %
  [x_max, y_max, ~] = size(mask);
  v = [];
  i = [];
  j = [];
  s = [];
  row_idx = 1;
  %zx = convmtx2([-1 1], x_max, y_max)*n;
  %zy = convmtx2([1; -1], x_max, y_max)*n;
  for x=1:x_max
      for y=1:y_max
          if mask(x,y) == 1
              % constrain tangent x direction
              j = [j,row_idx, row_idx];
              i = [i, indexInRow(x + 1, y, x_max), indexInRow(x, y, x_max)];
              s = [s, n(x,y,3), - n(x,y,3)];
              row_idx = row_idx + 1;
              
              % constrain tangent y direction              
              j = [j,row_idx, row_idx];
              i = [i, indexInRow(x, y + 1, x_max), indexInRow(x, y, x_max)];
              s = [s, n(x,y,3), - n(x,y,3)];
              row_idx = row_idx + 1;
              
              v = [v; -n(x,y,1); -n(x,y,2)];
%           else
%               row_idx = row_idx + 2; % skip two rows
%               v = [v; 0; 0]; % no constraints here
          end
      end
  end
  % random extra constrain  Z(x_0, y_0) = 0
  %j = [j, row_idx];
  %i = [i, indexInRow(x_max/2, y_max/2, y_max)];
  %s = [s, 1];
  %v = [v; 0];
  A = sparse(j,i,s, max(j), x_max*y_max);
  x = A\v;
  depth = reshape(x, x_max, y_max, 1);
end

function index = indexInRow(x,y, max)
    index = x*(max -1) + 1 + y;
end
