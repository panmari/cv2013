%% Setup vlfeat
run('vlfeat-0.9.17/toolbox/vl_setup')

%% do sth like
framesdir = 'images/';
siftdir = 'sift/';
fnames = dir([siftdir '/*.mat']);
name = fnames(1).name;
