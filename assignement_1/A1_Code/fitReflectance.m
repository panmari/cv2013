function [n, albedo] = fitReflectance(im, L)
  % [n, albedo] = fitReflectance(im, L)
  % 
  % Input:
  %   im - nPix x nDirChrome array of brightnesses,
  %   L  - 3 x nDirChrome array of light source directions.
  % Output:
  %   n - nPix x 3 array of surface normals, with n(k,1:3) = (nx, ny, nz)
  %       at the k-th pixel.
  %   albedo - nPix x 1 array of estimated albdedos
    

  % YOU NEED TO COMPLETE THIS
  
  % We know im(x) = albedo(x)(normal(x)*L), for every pixel x
  [x_max, y_max, ndir] = size(im);
  albedo = zeros([x_max,y_max, 1]);
  n = zeros([x_max,y_max, 3]);
  %im1D = reshape(im, [], ndir);
  inv_lights = pinv(L)';
  parfor x=1:x_max
      for y=1:y_max
          n_tilde = inv_lights*reshape(im(x,y,:), [], 1);
          albedo(x,y,:) = norm(n_tilde, 2);
          n(x,y,:) = n_tilde/albedo(x,y,:);
      end
  end
end

