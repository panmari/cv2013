function [L] = fitChromeSphere(chromeDir, nDir, chatty)
  % [L] = fitChromeSphere(chromeDir, nDir, chatty)
  % Input:
  %  chromeDir (string) -- directory containing chrome images.
  %  nDir -- number of different light source images.
  %  chatty -- true to show results images. 
  % Return:
  %  L is a 3 x nDir image of light source directions.

  % Since we are looking down the z-axis, the direction
  % of the light source from the surface should have
  % a negative z-component, i.e., the light sources
  % are behind the camera.
    
  if ~exist('chatty', 'var')
    chatty = false;
  end
    
  mask = imread([chromeDir, 'chrome.mask.png']);
  mask = mask(:,:,1) / 255.0;

  for n=1:nDir
    fname = [chromeDir,'chrome.',num2str(n-1),'.png'];
    im = imread(fname, 'png');
    imData(:,:,n) = im(:,:,1);           % red channel
  end
  [xmax, ymax, nr_images] = size(imData);
  
  %% computes centroid of bright spot
  for img_nr=1:nr_images
    bright_spots(:, :, img_nr) = getCentroid(imData(:,:,img_nr), mask); % fix inversion on y axis
  end
  %% compute center and radius of sphere
  sphere_center = getCentroid(mask, ones(xmax, ymax), 0);
  sphere_min = [10000, 10000];
  sphere_max = [0, 0];
  for x=1:xmax
    for y=1:ymax
        if mask(x,y) == 1
            if  x < sphere_min(1)
                sphere_min(1) = x;
            end
            if  y < sphere_min(2)
                sphere_min(2) = y;
            end
            if  x > sphere_max(1)
                sphere_min(1) = x;
            end
            if  y > sphere_max(2)
                sphere_min(2) = y;
            end
        end
    end
  end
  diameter_xy = sphere_min - sphere_max;
  radius_xy = diameter_xy/2;
  
  % YOU NEED TO COMPLETE THIS FUNCTION
  L = bright_spots; 
end

%% Returns the centroid of the bright blob inside the image
function centroid = getCentroid(img, mask, threshold)
  if nargin < 3
    threshold = 240;  
  end
  [xmax, ymax] = size(img);
  weights_sum = 0;
  bright_spot = [0.0, 0.0];
  for x=1:xmax
      for y=1:ymax
          weight = double(img(x,y));
          % ignore blue highlight
          if weight < threshold || mask(x,y) == 0
              weight = 0;
          end
         bright_spot = bright_spot + [x,y]*weight;
         weights_sum = weights_sum + weight;
      end
  end
  centroid = bright_spot/weights_sum;
end

