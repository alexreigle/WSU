% Project 3 Main Code
% CEG 7850 - Digital Image Processing
% Alex Reigle

function [] = main()
path = pwd;

% Problem 1
im3_49_path = [path, filesep, 'Fig0349(a)(ckt_board_saltpep_prob_pt05).tif'];
figure(1); hold on;
im3_49 = imread(im3_49_path);

    % Original Image
    subplot(1,3,1); imshow(im3_49);
    
    % Mean Processed Image
    im3_49_mean = meanTransform(im3_49);
    subplot(1,3,2); imshow(cast(im3_49_mean, 'uint8'));
    
    % Median Processed Image
    im3_49_median = medianTransform(im3_49);
    subplot(1,3,3); imshow(cast(im3_49_median, 'uint8'));


% Problem 2
im3_52_path = [path, filesep, 'Fig0352(a)(blurry_moon).tif'];
im3_52 = imread(im3_52_path);
figure(2); hold on;
subplot(2,2,1); imshow(im3_52);

im3_52 = cast(im3_52, 'double');

    % Laplcian and Gaussian (Eqtn 3.45) filters
    % Reference: Slide 146 --> Corresponds to Fig. 3.46 on pg. 146 in
    % textbook. The referenced equation is as follows:
    %           G(x,y) = Ke^(-1*(x^2+y^2)/(2*sigma^2))                (3-45)
    % This is approximated to the 3x3 mask found in figure 3.35
    im3_52_lap = laplacianTransform(im3_52);
    subplot(2,2,2); imshow(cast(im3_52_lap, 'uint8'));
    im3_52_gsn = gaussianTransform(im3_52);         % K = 1
    subplot(2,2,3); imshow(cast(im3_52_gsn, 'uint8'));
    im3_52_sharpened = im3_52_gsn - im3_52_lap;
    subplot(2,2,4); imshow(cast(im3_52_sharpened, 'uint8'));

% Problem 3
    figure(3); hold on;
    subplot(1,3,1); imshow(cast(im3_52, 'uint8'));
    % a) Blurry Image
        im3_52_gsn = gaussianTransform(im3_52);
        subplot(1,3,2); imshow(cast(im3_52_gsn, 'uint8'));
        
    % b) High Boost Image
        unsharpMask = im3_52 - im3_52_gsn;
        output_image = highBoostGaussianTransform(unsharpMask, 4, 1);
        sharpenedImage = im3_52 + output_image;
        subplot(1,3,3); imshow(cast(sharpenedImage, 'uint8'));

% Problem 4:
im3_63a_path = [path, filesep, 'Fig0363(a)(skeleton_orig).tif'];
figure(4); hold on;
    % a) Original Image
        im3_63a = imread(im3_63a_path);
        subplot(2,4,1); imshow(im3_63a);
        imageA = cast(im3_63a, 'double');

    % b) Apply Laplacian
        lapMask = laplacianTransform(imageA);
        imageB = mat2gray(lapMask);
        subplot(2,4,2); imshow(imageB);

    % c) Sharpen by differentiating original and Laplacian
        imageC = (imageA + lapMask);
        subplot(2,4,3); imshow(cast(imageC, 'uint8'));

    % d) Apply Sobel Gradient
        imageD = sobelTransform(imageA);
        subplot(2,4,4); imshow(cast(imageD, 'uint8'));

    % e) Smooth with 5x5 mean filter
        imageE = smoothTransform(imageD);
        subplot(2,4,5); imshow(cast(imageE, 'uint8'));

    % f) Multiply image from (c) with image from (e)
        imageF = imageC.*imageE;
        imageF = scalePixelValues(imageF, max(max(imageA)));
        subplot(2,4,6); imshow(cast(imageF, 'uint8'));

    % g) Take sum of images (a) and (f) to sharpen image
        imageG = imageA + imageF;
        subplot(2,4,7); imshow(cast(imageG, 'uint8'));

    % h) Apply Power-Law transform to image (g) to aquire final image
        imageH = powerTransform(imageG);
        subplot(2,4,8); imshow(cast(imageH, 'uint8'));

end

function avgImage = meanTransform(image)

fun = @(block_mat) mean(block_mat, 'all');
avgImage = nlfilter(image, [3 3], fun);

end

function medImage = medianTransform(image)

fun = @(block_mat) median(block_mat, 'all');
medImage = nlfilter(image, [3 3], fun);

end

function gsnImage = gaussianTransform(image)
stdIm = std(image, 1, 'all');
k = 1;
gKernel = (1/4.8976).*[ 0.3679 , 0.6065 , 0.3679 ;
                        0.6065 , 1.0000 , 0.6065 ;
                        0.3679 , 0.6065 , 0.3679 ];
                    
fun = @(block_mat) sum(sum(stdIm.*k.*gKernel.*block_mat));
gsnImage = nlfilter(image, [3 3], fun);

gsnImage = scalePixelValues(gsnImage, max(max(image)));                    
end

function output_image = highBoostGaussianTransform(image, k, sigma)
gaus = k.*[ -2/(2*sigma.^2) , -1/(2*sigma.^2) , -2/(2*sigma.^2) ;
            -1/(2*sigma.^2) ,       0         , -1/(2*sigma.^2) ;
            -2/(2*sigma.^2) , -1/(2*sigma.^2) , -2/(2*sigma.^2) ];
norm = sum(sum(gaus));
mask = gaus./norm;

fun = @(block_mat) sum(sum(mask.*block_mat));
output_image = nlfilter(image, [3, 3], fun);

output_image = scalePixelValues(output_image, max(max(image)));
intermediateImage = image + output_image;

output_image = scalePixelValues(intermediateImage, 255);
end

function lapImage = laplacianTransform(image)
laplaceFilter = [ -1,-1,-1 ; 
                  -1, 8,-1 ; 
                  -1,-1,-1 ];
c = -1;

fun = @(block_mat) sum(sum(c.*laplaceFilter.*block_mat));
lapImage = nlfilter(image, [3 3], fun);

maxVal = max(max(image));

lapImage = scalePixelValues(lapImage, maxVal);
end

function sobImage = sobelTransform(image)
 vertKernel = [ -1, -2, -1 ;
                 0,  0,  0 ;
                 1,  2,  1 ];

 horzKernel = [ -1,  0,  1 ;
                -2,  0,  2 ;
                -1,  0,  1 ];
            
fun = @(block_mat) abs(sum(sum(vertKernel.*block_mat))) + abs(sum(sum(horzKernel.*block_mat)));
sobImage = nlfilter(image, [3 3], fun);

end

function smoothImage = smoothTransform(image)

fun = @(block_mat) sum(sum(0.04*ones(5,5).*block_mat));
smoothImage = nlfilter(image, [5 5], fun);

end

function [enhancedImage] = powerTransform(image)
c = 25;
gamma = 0.4;
enhancedImage = zeros(size(image,1),size(image,2));
    for i = 1:size(image, 1)
        for j = 1:size(image, 2)
            enhancedImage(i,j) = c.*image(i,j).^(gamma);
        end
    end
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
