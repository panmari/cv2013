clear all;
close all;

%Using Matlab

A=rand(100); 
load mandrill;
A=imresize(X,[100,100]);

%(a)

B=sort(A(:),'descend');
plot(B);
%(b)

hist(A(:),20);

%(c)

RGB_M=rand(100,100,3);
size(RGB_M)
threshold=150;
RGB_M=reshape(RGB_M,100*100,3); % resized into a single list
size(RGB_M)
RGB_M(A>=threshold,1)=255;
RGB_M(A<threshold,1)=0;

RGB_M=reshape(RGB_M,100,100,3);
imagesc(RGB_M(:,:,1));
%RGB_M(:,:,1)=RGB_M(:,:,1)./max(max(RGB_M(:,:,1)));
image(RGB_M)
% dafuq, why is this a smiley?

%(d)

subplot(121);
imagesc(A);
subplot(122);
imagesc(A(end-40:end,1:40));

%(e)

A_new=A-mean(A(:));
imagesc(A_new);

%(f)

roll=ceil(rand(1)*6)

%(g)

y=[1 2 3 4 5 6]'
z=reshape(y,2,3)

%(h)

x=max(A(:));
[r c]=find(A==x);

%(i)

v=[1 8 8 2 1 3 9 8];
x=sum(v==1)



% Short programming assignment


% 1 -      map a grayscale image to its ?negative image?, in which the lightest values
%          appear dark and vice versa

 load mandrill;
 A=imresize(X,[100,100]);
 
 A=A./(max(A(:))-min(A(:)));
 A=A-min(A(:));
 A_negative=1-A;
 
 
 % 2-  map the image to its ?mirror image?, i.e., flipping it left to right
  
 A_mirror=fliplr(A);
 
 
 % 3 - swap the red and green color channels of the input color image
 
 A=rand(100,100,3);  % you can instead load an image of your choice using: 'imread' function

 A_swap=zeros(size(A));
 
 A_swap(:,:,1)=A(:,:,2);
 A_swap(:,:,2)=A(:,:,1);
 A_swap(:,:,3)=A(:,:,3);
 
 
 % 4 - average the input image with its mirror image (use typecasting!)

 average=(rgb2gray(A)+A_mirror)/2;

 % 5 - add a random value between ..

 load mandrill;
 A=imresize(X,[100,100]);

 A=A+rand(size(A))*255;
 A=A-min(A(:));
 A=255*A/max(A(:));
 

