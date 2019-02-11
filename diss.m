load('twoFrameData.mat')

figure;
hold on;

min_ind = 100;
% displaySIFTPatches( positions2(min_ind, :), scales2(min_ind), orients2(min_ind), im2 );

patch = getPatchFromSIFTParameters(positions2(min_ind, :), ...
    scales2(min_ind), orients2(min_ind), rgb2gray(im2) );

imshow(patch);