% Project 3 Main Code
% CEG 7850 - Digital Image Processing
% Alex Reigle

function [] = main()
path = pwd;

% Problem 1

% Problem 2

% Problem 3

% Problem 4:
im3_63a_path = [path, filesep, 'Fig0363(a)(skeleton_orig).tif'];
figure(1); hold on;
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
        imageH = logTransform(imageG);
        subplot(2,4,8); imshow(cast(imageH, 'uint8'));

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

function [enhancedImage] = logTransform(image)
c = 75;
enhancedImage = zeros(size(image,1),size(image,2));
    for i = 1:size(image, 1)
        for j = 1:size(image, 2)
            enhancedImage(i,j) = c.*log10( 1+image(i,j) );
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
