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
      
  % We know im(x) = albedo(x)(normal(x)*L), for every pixel x
  [x_max, y_max, ndir] = size(im);
  im1D = reshape(im, [], ndir);

  n_tilde1D = L'\im1D';
  albedo1D = sqrt(sum(n_tilde1D.^2,1)); 
  n1D = bsxfun(@rdivide, n_tilde1D, albedo1D);
  albedo = reshape(albedo1D, [x_max, y_max, 1]);
  n = reshape(n1D', [x_max, y_max, 3]);
end

