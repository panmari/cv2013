% This file dumps the sift descriptors of every image of the 
% folder /images into a matlab workspace with the same name in the 
% folder /sift
% Run this before trying any other scripts

%% Setup vlfeat
run('vlfeat-0.9.17/toolbox/vl_setup')

%% do sth like
framesdir = 'images/';
siftdir = 'sift/';


% Get a list of all the .mat files in that directory.
% There is one .mat file per image.
fnames = dir([framesdir '/*.png']);

fprintf('reading %d total files...\n', length(fnames));
for i=1:length(fnames)
    name = fnames(i).name;
    fprintf('Processing %s\n', name);
    imname = [framesdir, name];
    orig_I = imread(imname);
    I = single(rgb2gray(orig_I));
    [f,d] = vl_sift(I, 'NormThresh', 10);
    descriptors = d;
    positions = f(1:2,:);
    scales = f(3,:);
    orients = f(4,:);
    numfeats = length(d);
    save([siftdir, name(1:(end-3)), 'mat'], 'imname', 'descriptors', 'positions', 'scales', 'orients','numfeats');
end

%% some debug information
image(orig_I) ;
perm = randperm(size(f,2)) ;
sel = perm(1:50) ;
h1 = vl_plotframe(f(:,sel)) ;
h2 = vl_plotframe(f(:,sel)) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;

h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
set(h3,'color','g') ;