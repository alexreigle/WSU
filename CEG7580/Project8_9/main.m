% Project 8 & 9
% CEG 7850 - Digital Image Processing
% Alex Reigle

function [] = main()
path = pwd;

% Problem 1: Edge Detection and Thresholding
% (a) Compute Sobel grating  using filters from eqn. (10-26) and return a
%     binary  image. (Threshold value is an input)

% see below: [sobelIm] = sobelGrating(image, threshold)

% (b) Use 3x3 smoothing and filtering function from (a) on Figure 2.39(c)
%     to produce a binary image segenting blood vessels. Use histogram to
%     select threshold.

im2_39c_path = [path, filesep, 'Fig0239(c)(kidney_original).tif'];
im2_39c = imread(im2_39c_path);

[im2_39_counts, im2_39_bins] = imhist(im2_39c);

% figure(10); bar(im2_39_bins, im2_39_counts);
% figure(1); imshow(im2_39c);

%Perform Smoothing
smoothIm2_39c = imgaussfilt(im2_39c,3);

% figure(11); imshow(smoothIm2_39c);
% [sobelIm] = sobelGrating(smoothIm2_39c, 85, 1);
% figure(12); imshow(cast(sobelIm, 'uint8'));

% Problem 2: Basic Global Thresholding
% (a) Write function to automatically select threshold and return a binary
%     segemented image.

% (b) Using Fig. 10.35(a) and the function from (a), reproduce example
%     10.13 in the text.
im10_35a_path = [path, filesep, 'Fig1035(a)(noisy_fingerprint).tif'];
im10_35a = imread(im10_35a_path);

[im10_35a_counts, ~] =imhist(im10_35a);

% Using MatLab Built-In Functions
% im10_35a_threshold = otsuthresh(im10_35a_counts);
% im10_35a_globalThresh = imbinarize(im10_35a, im10_35a_threshold);

% Using Functions I've written
% [im10_35a_autoThresh] = autoThreshold(im10_35a);
% im10_35a_autoBinIm = binaryThreshold(im10_35a, im10_35a_autoThresh);
% figure(22); imshow(cast(im10_35a_autoBinIm, 'uint8'));

% Problem 3: Optimum Thresholding
% (a) Implement Otsu's algorithm

% (b) Using Fig. 10.36(b) and Otsu's algorithm, reproduce 10.36(c-d)
% im10_36b_path = [path, filesep, 'Fig1036(a)(polymersomes).tif'];
% im10_36b = imread(im10_36b_path);
% im10_36b_otsu = imbinarize(im10_36b, 'global');
% figure(3); imshow(im10_36b_otsu);

% % Using an alternative method to acheive same apparent outcome
% [im10_36b_counts, ~] = imhist(im10_36b);
% im10_36b_thresh = otsuthresh(im10_36b_counts);
% im10_36b_otsu2 = imbinarize(im10_36b, im10_36b_thresh);
% figure(31); imshow(im10_36b_otsu2);

% Problem 4: Boundary Extraction
% (a) Create a dialation and erosion function with a 3x3 filter of 
%     arbitrary structure element

% (b) Write a function to perform set intersection, differencing and
%     complementation.

% (c) Using (a) and (b) write a function to perform morphological boundary
%     extraction.

% (d) Extract the boundary of Figure 9.16(a) using above methods.


% Probelm 5: Connected Components
% (a) Usings the results (extracted boundary) from Prbolem 4(d) extract and
%     count the number of components

% (b) Using Fig. 9.20(a), approximate the results of example 9.7

end

function [binIm] = binaryThreshold(image, threshold)
    binIm = zeros(size(image,1),size(image,2));
    for i = 1:size(image,1)
        for ii = 1:size(image,2)
            if(image(i,ii) <= threshold)
                binIm(i,ii) = 0;
            else
                binIm(i,ii) = 255;
            end
        end
    end
end

function [threshold] = autoThreshold(image)
    T = [ 0.5*max(max(image)), 0, 100];
    
    G1 = [];
    G2 = [];
    
    deltaT = 5;
    breaker = 0;
    
    while( T(3) > deltaT)
        for i = 1:size(image,1)
            for ii = 1:size(image,2)
                if(image(i,ii) <= T(1))
                    G1 = [G1, image(i,ii)];
                else
                    G2 = [G2, image(i,ii)];
                end
            end
        end
        
        mG1 = mean(mean(G1));
        mG2 = mean(mean(G2));
        
        T(3) = T(1)-T(2);
        T(2) = T(1);
        T(1) = 0.5*(mG1+mG2);
        
        breaker = breaker+1;
        if(breaker > 1000000)
            break
            disp('Ya fucked up');
        end
    end
    
    threshold = T(1);
end

function [sobelIm] = sobelGrating(image, threshold, binFlag)
    image = cast(image, 'double');
    sobelX = [-1, -2, -1; 0, 0, 0; 1, 1, 2];
    sobelY = [-1, 0, 1; -2, 0, 2; -1, 0, 1];
    
    fun = @(block_struct) abs(sum(sum(sobelX.*block_struct)) + sum(sum(sobelY.*block_struct)));
    sobelIm = nlfilter(image, [3 3], fun);
    
    if(binFlag)
        for i = 1:size(image,1)
            for ii = 1:size(image,2)
                if (sobelIm(i,ii) <= threshold)
                    sobelIm(i,ii) = 0;
                else
                    sobelIm(i,ii) = max(max(image));
                end
            end
        end
    end
    sobelIm = cast(sobelIm, 'uint8');
end

