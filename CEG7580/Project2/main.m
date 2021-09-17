% Project 2 Main Code
% CEG 7850 - Digital Image Processing
% Alex Reigle

function [] = main()
path = pwd;

%Problem 1: Intensity Transformation:

im3_8a_path = [pwd, filesep, 'Fig0308(a)(fractured_spine).tif'];
im3_9a_path = [pwd, filesep, 'Fig0309(a)aerialview-washedout.tif'];
    im3_9a = cast(imread(im3_9a_path), 'double');
    im3_8a = cast(imread(im3_8a_path), 'double');
originalImage3_8a = cast(imread(im3_8a_path), 'uint8');
originalImage3_9a = cast(imread(im3_9a_path), 'uint8');

% 1(a):  Use  (eq 3-4) s = c*log10( 1 + r ) to enhance Figure 3.8(a) and 3.9(a)
logEnhancedImage3_8a = cast(logTransform(im3_8a), 'uint8');
logEnhancedImage3_9a = cast(logTransform(im3_9a), 'uint8');

% 1(b):  Use (eq 3-5) s = c*r^(gamma) to enhance Figure 3.8(a) and 3.9(a)
powerEnhanceImage3_8a = cast(powerTransform(im3_8a), 'uint8');
powerEnhanceImage3_8a = cast(powerTransform(im3_9a), 'uint8');

% Proglem 2: Histogram Equalization

im3_16_1_path = [pwd, filesep, 'Fig0316(1)(Dark).tif'];
im3_16_2_path = [pwd, filesep, 'Fig0316(2)(WashedOut).tif'];
im3_16_3_path = [pwd, filesep, 'Fig0316(3)(Gray).tif'];
im3_16_4_path = [pwd, filesep, 'Fig0316(4)(HighContrast).tif'];

im3_16_1 = imread(im3_16_1_path);
im3_16_2 = imread(im3_16_2_path);
im3_16_3 = imread(im3_16_3_path);
im3_16_4 = imread(im3_16_4_path);

% 2(a): Recreate Figure 3.20 from text and comment on differences as well as
%       the significance of rgbplot() results

% Image pixel intensity distributions
[im3_16_1_counts, im3_16_1_binlocations] = imhist(im3_16_1);
[im3_16_2_counts, im3_16_2_binlocations] = imhist(im3_16_2);
[im3_16_3_counts, im3_16_3_binlocations] = imhist(im3_16_3);
[im3_16_4_counts, im3_16_4_binlocations] = imhist(im3_16_4);

% Image Histograms
im3_16_1_histeq = histeq(im3_16_1, gray(256));
im3_16_2_histeq = histeq(im3_16_2, gray(256));
im3_16_3_histeq = histeq(im3_16_3, gray(256));
im3_16_4_histeq = histeq(im3_16_4, gray(256));

im3_16_1_double = cast(im3_16_1,'double');
im3_16_2_double = cast(im3_16_2,'double');
im3_16_3_double = cast(im3_16_3,'double');
im3_16_4_double = cast(im3_16_4,'double');

% Equalized Images
im3_16_1_grayimeq = ind2gray(im3_16_1_double, im3_16_1_histeq);
im3_16_2_grayimeq = ind2gray(im3_16_2_double, im3_16_2_histeq);
im3_16_3_grayimeq = ind2gray(im3_16_3_double, im3_16_3_histeq);
im3_16_4_grayimeq = ind2gray(im3_16_4_double, im3_16_4_histeq);

figure(20); hold on;
subplot(4,5,1); imshow(im3_16_1);
subplot(4,5,3); bar(im3_16_1_binlocations, im3_16_1_counts);
subplot(4,5,2); imshow(im3_16_1, im3_16_1_histeq);
subplot(4,5,4); rgbplot(im3_16_1_histeq);
subplot(4,5,5);

subplot(4,5,5); imshow(im3_16_2);
subplot(4,5,7); bar(im3_16_2_binlocations, im3_16_2_counts);
subplot(4,5,6); imshow(im3_16_2, im3_16_2_histeq);
subplot(4,5,8); rgbplot(im3_16_2_histeq);

subplot(4,5,9); imshow(im3_16_3);
subplot(4,5,11); bar(im3_16_3_binlocations, im3_16_3_counts);
subplot(4,5,10); imshow(im3_16_3, im3_16_3_histeq);
subplot(4,5,12); rgbplot(im3_16_3_histeq);

subplot(4,5,13); imshow(im3_16_4);

subplot(4,5,15); bar(im3_16_4_binlocations, im3_16_4_counts);
subplot(4,5,14); imshow(im3_16_4, im3_16_4_histeq);
subplot(4,5,16); rgbplot(im3_16_4_histeq);

figure(21); hold on;
subplot(4,2,1); imshow(im3_16_1,im3_16_1_histeq);
subplot(4,2,2); imhist(im3_16_1_grayimeq, 256);

subplot(4,2,3); imshow(im3_16_2,im3_16_2_histeq);
subplot(4,2,4); imhist(im3_16_2_grayimeq, 256);

subplot(4,2,5); imshow(im3_16_3,im3_16_3_histeq);
subplot(4,2,6); imhist(im3_16_3_grayimeq, 256);

subplot(4,2,7); imshow(im3_16_4,im3_16_4_histeq);
subplot(4,2,8); imhist(im3_16_4_grayimeq, 256);

% Insert commentary on the differences

% 2(b):  Develop a MatLab function to perform local histogram equalization
%        of a 256 gray scale (intensity) image.
im_fig3_33a_path = [pwd, filesep, 'Fig0332(a)(embedded_square_noisy_512).tif'];
im_fig3_33a = imread(im_fig3_33a_path);

im_fig3_33a_equalized = localhisteq(im_fig3_33a, [3,3], 256);
end


function [enhancedImage] = logTransform(image)
enhancedImage = zeros(size(image,1),size(image,2));
c = 100;
    for i = 1:size(image, 1)
        for j = 1:size(image, 2)
            enhancedImage(i,j) = c.*log10( 1+image(i,j) );
        end
    end
end

function [enhancedImage] = powerTransform(image)
enhancedImage = zeros(size(image,1),size(image,2));
c= 20;
gamma = 0.67;
    for i = 1:size(image, 1)
        for j = 1:size(image, 2)
            enhancedImage(i,j) = c.*image(i,j).^(gamma);
        end
    end
end

function [equalizedImage] = localhisteq(image, mask_size, max_intensity)
    fun = @(block_struct) histeq(block_struct.data, max_intensity);
    equalizedImage = blockproc(image, [mask_size(1) mask_size(2)], fun);

end
