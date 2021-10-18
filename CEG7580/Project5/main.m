% Project 5
% CEG 7850 - Digital Image Processing
% Alex Reigle

function [] = main()
path = pwd;

% Problem 2: One-Dimensional Discrete Wavelet Transforms
% Using the function f(x) = {1, 4, -3, 0} from example 7.19 (pg. 512)
% Write a program to compute a j-scale DWT and IDWT using Haar wavelets
f = [1, 4, -3 0];

% [j1_DWT_1D, j1_iDWT_1D] = haarWavelet1D(f,1);
% [j2_DWT_1D, j2_iDWT_1D] = haarWavelet1D(f,2);
% [j3_DWT_1D, j3_iDWT_1D] = haarWavelet1D(f,3);
% [j4_DWT_1D, j4_iDWT_1D] = haarWavelet1D(f,4);
% 
% msgbox({'Scale:';['J=1','  DWT: ', num2str(j1_DWT_1D)]; ...
%                  ['J=2','  DWT: ', num2str(j2_DWT_1D)]; ...
%                  ['J=3','  DWT: ', num2str(j3_DWT_1D)]; ...
%                  ['J=4','  DWT: ', num2str(j4_DWT_1D)]; '';...
%         'All iDWT are equal.'; ['iDWT: ', num2str(j1_iDWT_1D)]}, 'Problem 1 Solution');

% Problem 3: Two-Dimensional Wavelet Transforms
% Preform a 2D j-scale (j = 1,2,3) DWT and iDWT on the image from Figure
% 7.30a  to recreate fig. 7.30(a-d) (pg. 523) from the text book.

im6_30aVase_path = [path, filesep, 'F6_30(a)(Vase).tif'];
im6_30aVase = imread(im6_30aVase_path);

im6_30aVase = cast(im6_30aVase, 'double');

[j1_DWT_2D, j1_vDWT, j1_hDWT, j1_dDWT, j1_iDWT_2D] = haarWavelet2D(im6_30aVase,1);
[j2_DWT_2D, j2_vDWT, j2_hDWT, j2_dDWT, j2_iDWT_2D] = haarWavelet2D(im6_30aVase,2);
[j3_DWT_2D, j3_vDWT, j3_hDWT, j3_dDWT, j3_iDWT_2D] = haarWavelet2D(im6_30aVase,3);

% This figure will show the reconstructed 2D-DWT approximatation (i.e. only
% the parts of Fig. 7.30 that look like the real image)
figure(3);
subplot(2,2,1);     imshow(cast(im6_30aVase, 'uint8'));   title('Original Image');
subplot(2,2,2);     imshow(cast(j1_DWT_2D, 'uint8'));     title('One-Scale Haar 2D-DWT');
subplot(2,2,3);     imshow(cast(j2_DWT_2D, 'uint8'));     title('Two-Scale Haar 2D-DWT');
subplot(2,2,4);     imshow(cast(j3_DWT_2D, 'uint8'));     title('Three-Scale Haar 2D-DWT');

% This is a direct recreatation of Fig. 7.30 from the text.
im7_30a = im6_30aVase;

im7_30b = im7_30a;
im7_30b(257:end,1:256)   = j1_vDWT;
im7_30b(1:256,257:end)   = j1_hDWT;
im7_30b(257:end,257:end) = j1_dDWT;
im7_30b(1:256,1:256)     = j1_DWT_2D;

im7_30c = im7_30b;
im7_30c(129:256,1:128)   = j2_vDWT;
im7_30c(1:128,129:256)   = j2_hDWT;
im7_30c(129:256,129:256) = j2_dDWT;
im7_30c(1:128,1:128)     = j2_DWT_2D;

im7_30d = im7_30c;
im7_30d(65:128,1:64)     = j3_vDWT;
im7_30d(1:64,65:128)     = j3_hDWT;
im7_30d(65:128,65:128)   = j3_dDWT;
im7_30d(1:64,1:64)       = j3_DWT_2D;

im7_30b = powerTransform(im7_30b, 85, 0.15);
im7_30c = powerTransform(im7_30c, 85, 0.15);
im7_30d = powerTransform(im7_30d, 85, 0.15);
im7_30b(1:256,1:256)     = j1_DWT_2D;
im7_30c(1:128,1:128)     = j2_DWT_2D;
im7_30d(1:64,1:64)       = j3_DWT_2D;

figure(31);
subplot(2,2,1);     imshow(cast(im7_30a, 'uint8'));   title('Original Image');
subplot(2,2,2);     imshow(cast(im7_30b, 'uint8'));   title('One-Scale Haar 2D-DWT');
subplot(2,2,3);     imshow(cast(im7_30c, 'uint8'));   title('Two-Scale Haar 2D-DWT');
subplot(2,2,4);     imshow(cast(im7_30d, 'uint8'));   title('Three-Scale Haar 2D-DWT');
end


function [DWT, iDWT] = haarWavelet1D(f,J)
    [DWT,l] = wavedec(f, J, 'haar');
    [iDWT]  = waverec(DWT, l, 'haar');
end

function [sApprDWT, sVertDWT, sHorzDWT, sDiagDWT, iDWT] = haarWavelet2D(image, J)
[DWT, S] = wavedec2(image, J, 'haar');
[iDWT]   = waverec2(DWT, S, 'haar');

[horzDWT, vertDWT, diagDWT] = detcoef2('all', DWT, S, J); 
apprDWT = appcoef2(DWT, S, 'haar', J);
% DWT = reshape(DWT, size(image,1), size(image,2));

imageRange = max(max(image))-min(min(image));
% scaledDWT = scalePixelValues(DWT, imageRange);
sVertDWT = scalePixelValues(256.*vertDWT, imageRange);
sHorzDWT = scalePixelValues(256.*horzDWT, imageRange);
sDiagDWT = scalePixelValues(256.*diagDWT, imageRange);
sApprDWT = scalePixelValues(apprDWT, imageRange);

end

function [scaledImage] = scalePixelValues(imageProccessed, imageOrigRange)
scaledImage = zeros(size(imageProccessed,1), size(imageProccessed,2));
imageProcRange = max(max(imageProccessed)) - min(min(imageProccessed));

    for i = 1:size(imageProccessed,1)
        for j = 1:size(imageProccessed,2)
            scaledImage(i,j) = imageOrigRange*imageProccessed(i,j)/imageProcRange;
        end
    end
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
