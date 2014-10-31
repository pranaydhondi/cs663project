im=imread('parrot.png');
delta = 0.1;
K=100;
figure(1);
imshow(im)
im1 = mean_shift_im(im,delta);
figure(2);
% imshow(uint8(im1));
im2 = uint8(im1);