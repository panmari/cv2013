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
  % initial constraint, Z(x_0, y_0) = 0
  i = [];
  j = [];
  s = [];
  row_idx = 1;
  for x=1:x_max
      for y=1:y_max
          if mask(x,y) == 1
              % constrain tangent x direction
              j = [j,row_idx, row_idx];
              i = [i, indexInRow(x + 1, y, y_max), indexInRow(x, y, y_max)];
              s = [s, n(x,y,3), - n(x,y,3)];
              row_idx = row_idx + 1;
              
              % constrain tangent y direction              
              j = [j,row_idx, row_idx];
              i = [i, indexInRow(x, y + 1, y_max), indexInRow(x, y, y_max)];
              s = [s, n(x,y,3), - n(x,y,3)];
              row_idx = row_idx + 1;
              
              v = [v; -n(x,y,1); -n(x,y,2)];
          else
              row_idx = row_idx + 2; % skip two rows
              v = [v; 0; 0]; % no constraints here
          end
      end
  end
  A = sparse(j,i,s, 2*x_max*y_max, x_max*y_max);
  x = A\v;
  depth = reshape(x, x_max, y_max, 1);
end

function index = indexInRow(x,y, y_max)
    index = x*(y_max -1) + 1 + y;
end
