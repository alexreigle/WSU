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

figure(1); hold on; title('Original Image 3.8a');
imshow(originalImage3_8a);

figure(2); hold on; title('Original Image 3.9a');
imshow(originalImage3_9a);

% 1(a):  Use  (eq 3-4) s = c*log10( 1 + r ) to enhance Figure 3.8(a) and 3.9(a)
c = [1, 10, 50, 75, 100, 150];

logEnhancedImage3_8a_c1   = cast(logTransform(im3_8a, c(1)), 'uint8');
logEnhancedImage3_9a_c1   = cast(logTransform(im3_9a, c(1)), 'uint8');

logEnhancedImage3_8a_cqrt = cast(logTransform(im3_8a, c(2)), 'uint8');
logEnhancedImage3_9a_cqrt = cast(logTransform(im3_9a, c(2)), 'uint8');

logEnhancedImage3_8a_c10  = cast(logTransform(im3_8a, c(3)), 'uint8');
logEnhancedImage3_9a_c10  = cast(logTransform(im3_9a, c(3)), 'uint8');

logEnhancedImage3_8a_c50 = cast(logTransform(im3_8a, c(4)), 'uint8');
logEnhancedImage3_9a_c50 = cast(logTransform(im3_9a, c(4)), 'uint8'); 

logEnhancedImage3_8a_c100 = cast(logTransform(im3_8a, c(5)), 'uint8'); % Best of this type (pretty good)
logEnhancedImage3_9a_c100 = cast(logTransform(im3_9a, c(5)), 'uint8'); % Best of this type (very bad)

logEnhancedImage3_8a_c150 = cast(logTransform(im3_8a, c(6)), 'uint8');
logEnhancedImage3_9a_c150 = cast(logTransform(im3_9a, c(6)), 'uint8');

% Problem 1(a) Results:
figure(110); hold on; 
subplot(2,3,1); imshow(logEnhancedImage3_8a_c1);
subplot(2,3,2); imshow(logEnhancedImage3_8a_cqrt); title('Problem 1(a): Logarithmic Transform of Image 3.8a');
subplot(2,3,3); imshow(logEnhancedImage3_8a_c10);
subplot(2,3,4); imshow(logEnhancedImage3_8a_c50);
subplot(2,3,5); imshow(logEnhancedImage3_8a_c100);
subplot(2,3,6); imshow(logEnhancedImage3_8a_c150);

figure(111); hold on; 
subplot(2,3,1); imshow(logEnhancedImage3_9a_c1);
subplot(2,3,2); imshow(logEnhancedImage3_9a_cqrt); title('Problem 1(a): Logarithmic Transform of Image 3.9a');
subplot(2,3,3); imshow(logEnhancedImage3_9a_c10);
subplot(2,3,4); imshow(logEnhancedImage3_9a_c50);
subplot(2,3,5); imshow(logEnhancedImage3_9a_c100);
subplot(2,3,6); imshow(logEnhancedImage3_9a_c150);


% 1(b):  Use (eq 3-5) s = c*r^(gamma) to enhance Figure 3.8(a) and 3.9(a)

% Here, I assume c will vary with gamma to allow for propper intensity
% levels. However since gamma is the focus of the experiementation, I will
% only include reasonable pairs of values of C and gamma - abreviating the
% experimentation processes conducted.

c     = [0.05, 0.50, 1.0, 5.00, 10.0, 20.0, 0.05, 0.50, 1.00, 5.0, 10.0, 20.0];
gamma = [1.50, 1.25, 1.0, 0.75, 0.25, 0.67, 0.67, 0.25, 0.75, 1.0, 1.25, 1.50];

powerEnhanceImage3_8a_1 = cast(powerTransform(im3_8a, c(1), gamma(1)), 'uint8');
powerEnhanceImage3_9a_1 = cast(powerTransform(im3_9a, c(1), gamma(1)), 'uint8'); % Best of this type (Pretty good)

powerEnhanceImage3_8a_2 = cast(powerTransform(im3_8a, c(2), gamma(2)), 'uint8');
powerEnhanceImage3_9a_2 = cast(powerTransform(im3_9a, c(2), gamma(2)), 'uint8');

powerEnhanceImage3_8a_3 = cast(powerTransform(im3_8a, c(3), gamma(3)), 'uint8');
powerEnhanceImage3_9a_3 = cast(powerTransform(im3_9a, c(3), gamma(3)), 'uint8');

powerEnhanceImage3_8a_4 = cast(powerTransform(im3_8a, c(4), gamma(4)), 'uint8'); % Best of this type (Pretty good)
powerEnhanceImage3_9a_4 = cast(powerTransform(im3_9a, c(4), gamma(4)), 'uint8');

powerEnhanceImage3_8a_5 = cast(powerTransform(im3_8a, c(5), gamma(5)), 'uint8');
powerEnhanceImage3_9a_5 = cast(powerTransform(im3_9a, c(5), gamma(5)), 'uint8');

powerEnhanceImage3_8a_6 = cast(powerTransform(im3_8a, c(6), gamma(6)), 'uint8');
powerEnhanceImage3_9a_6 = cast(powerTransform(im3_9a, c(6), gamma(6)), 'uint8');

powerEnhanceImage3_8a_7 = cast(powerTransform(im3_8a, c(7), gamma(7)), 'uint8');
powerEnhanceImage3_9a_7 = cast(powerTransform(im3_9a, c(7), gamma(7)), 'uint8');

powerEnhanceImage3_8a_8 = cast(powerTransform(im3_8a, c(8), gamma(8)), 'uint8');
powerEnhanceImage3_9a_8 = cast(powerTransform(im3_9a, c(8), gamma(8)), 'uint8');

powerEnhanceImage3_8a_9 = cast(powerTransform(im3_8a, c(9), gamma(9)), 'uint8');
powerEnhanceImage3_9a_9 = cast(powerTransform(im3_9a, c(9), gamma(9)), 'uint8');

powerEnhanceImage3_8a_10 = cast(powerTransform(im3_8a, c(10), gamma(10)), 'uint8');
powerEnhanceImage3_9a_10 = cast(powerTransform(im3_9a, c(10), gamma(10)), 'uint8');

powerEnhanceImage3_8a_11 = cast(powerTransform(im3_8a, c(11), gamma(11)), 'uint8');
powerEnhanceImage3_9a_11 = cast(powerTransform(im3_9a, c(11), gamma(11)), 'uint8');

powerEnhanceImage3_8a_12 = cast(powerTransform(im3_8a, c(12), gamma(12)), 'uint8');
powerEnhanceImage3_9a_12 = cast(powerTransform(im3_9a, c(12), gamma(12)), 'uint8');

% Problem 1(b) Results:
figure(121); hold on;
subplot(4,3,1); imshow(powerEnhanceImage3_8a_1);
subplot(4,3,2); imshow(powerEnhanceImage3_8a_2); title('Problem 1(b): Power-Law Transform of Image 3.8a');
subplot(4,3,3); imshow(powerEnhanceImage3_8a_3);
subplot(4,3,4); imshow(powerEnhanceImage3_8a_4);
subplot(4,3,5); imshow(powerEnhanceImage3_8a_5);
subplot(4,3,6); imshow(powerEnhanceImage3_8a_6);
subplot(4,3,7); imshow(powerEnhanceImage3_8a_7);
subplot(4,3,8); imshow(powerEnhanceImage3_8a_8);
subplot(4,3,9); imshow(powerEnhanceImage3_8a_9);
subplot(4,3,10); imshow(powerEnhanceImage3_8a_10);
subplot(4,3,11); imshow(powerEnhanceImage3_8a_11);
subplot(4,3,12); imshow(powerEnhanceImage3_8a_12);
figure(121); 

figure(122); hold on;
subplot(4,3,1); imshow(powerEnhanceImage3_9a_1); 
subplot(4,3,2); imshow(powerEnhanceImage3_9a_2); title('Problem 1(b): Power-Law Transform of Image 3.9a');
subplot(4,3,3); imshow(powerEnhanceImage3_9a_3);
subplot(4,3,4); imshow(powerEnhanceImage3_9a_4);
subplot(4,3,5); imshow(powerEnhanceImage3_9a_5);
subplot(4,3,6); imshow(powerEnhanceImage3_9a_6);
subplot(4,3,7); imshow(powerEnhanceImage3_9a_7);
subplot(4,3,8); imshow(powerEnhanceImage3_9a_8);
subplot(4,3,9); imshow(powerEnhanceImage3_9a_9);
subplot(4,3,10); imshow(powerEnhanceImage3_9a_10);
subplot(4,3,11); imshow(powerEnhanceImage3_9a_11);
subplot(4,3,12); imshow(powerEnhanceImage3_9a_12);
figure(122); 

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

% Problem 2(a) Results: Replicate Figure 3.20 from text
figure(320); hold on;
subplot(4,3,1); imshow(im3_16_1);
subplot(4,3,2); imshow(im3_16_1, im3_16_1_histeq); title('Replication of Figure 3.20');
subplot(4,3,3); bar(im3_16_1_binlocations, im3_16_1_counts);

subplot(4,3,4); imshow(im3_16_2);
subplot(4,3,5); imshow(im3_16_2, im3_16_2_histeq);
subplot(4,3,6); bar(im3_16_2_binlocations, im3_16_2_counts);

subplot(4,3,7); imshow(im3_16_3);
subplot(4,3,8); imshow(im3_16_3, im3_16_3_histeq);
subplot(4,3,9); bar(im3_16_3_binlocations, im3_16_3_counts);

subplot(4,3,10); imshow(im3_16_4);
subplot(4,3,11); imshow(im3_16_4, im3_16_4_histeq);
subplot(4,3,12); bar(im3_16_4_binlocations, im3_16_4_counts);
    
                        
figure(211); hold on; % Figure 3.20 with additional rbg plot for further insight
subplot(4,4,1); imshow(im3_16_1);
subplot(4,4,2); imshow(im3_16_1, im3_16_1_histeq); title('                 Image Before and After Histogram Equalization');
subplot(4,4,3); bar(im3_16_1_binlocations, im3_16_1_counts);
    subplot(4,4,4); rgbplot(im3_16_1_histeq);

subplot(4,4,5); imshow(im3_16_2);
subplot(4,4,6); imshow(im3_16_2, im3_16_2_histeq);
subplot(4,4,7); bar(im3_16_2_binlocations, im3_16_2_counts);
    subplot(4,4,8); rgbplot(im3_16_2_histeq);

subplot(4,4,9); imshow(im3_16_3);
subplot(4,4,10); imshow(im3_16_3, im3_16_3_histeq);
subplot(4,4,11); bar(im3_16_3_binlocations, im3_16_3_counts);
    subplot(4,4,12); rgbplot(im3_16_3_histeq);

subplot(4,4,13); imshow(im3_16_4);
subplot(4,4,14); imshow(im3_16_4, im3_16_4_histeq);
subplot(4,4,15); bar(im3_16_4_binlocations, im3_16_4_counts);
    subplot(4,4,16); rgbplot(im3_16_4_histeq);

 % Image and histogram of post-processed data
figure(212); hold on; 
subplot(4,2,1); imshow(im3_16_1,im3_16_1_histeq); title('Image and Histogram results after Histogram Equalization');
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

figure(31); hold on; title('Original Embedded Square Image'); imshow(im_fig3_33a);

im_fig3_33a_equalized = localhisteq(im_fig3_33a, [3,3], 256);

% 2(b) Results:

figure(32); hold on; title('Local Histogram Proccessing Results of Embedded Square Image');
imshow(im_fig3_33a_equalized);

end


function [enhancedImage] = logTransform(image, c)
enhancedImage = zeros(size(image,1),size(image,2));
    for i = 1:size(image, 1)
        for j = 1:size(image, 2)
            enhancedImage(i,j) = c.*log10( 1+image(i,j) );
        end
    end
end

function [enhancedImage] = powerTransform(image, c, gamma)
enhancedImage = zeros(size(image,1),size(image,2));
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
