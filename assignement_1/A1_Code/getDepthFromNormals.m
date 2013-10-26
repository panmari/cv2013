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
  for y=1:y_max
      for x=1:x_max
          if mask(x,y) == 0
              try 
                  if (mask(x+1,y) || mask(x, y+1) || mask(x-1, y) || mask(x, y-1))
                      j = [j, row_idx];
                      i = [i, indexInRow(x, y, x_max)];
                      s = [s, 1];
                      v = [v; 0];
                      row_idx = row_idx + 1;
                  end
              catch err
                  % don't care at boarder
              end
           else
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
           end
      end
  end

  A = sparse(j,i,s, max(j), x_max*y_max);
  xVec = A\v;
  depth = reshape(xVec, [x_max, y_max, 1]);
end

function index = indexInRow(x,y, max)
    index = max*(y - 1) + x;
end
