% Project 6
% CEG 7850 - Digital Image Processing
% Alex Reigle

function [] = main()
path = pwd;

% Problem 1: Image Entropy
% Estimate the entropies of the images from Fig. 8.1(a-c) from the text
% using eqn. (8-7) as follows:
%               H_not = -1*sum(pr(rk(0:L-1))*log2(pr(rk(0:L-1))))
im801a_path = [path, filesep, 'Fig0801(a).tif'];
im801b_path = [path, filesep, 'Fig0801(b).tif'];
im801c_path = [path, filesep, 'Fig0801(c).tif'];

im801a = imread(im801a_path);
im801b = imread(im801b_path);
im801c = imread(im801c_path);

im801aEntropy = computeEntropy(im801a);
im801bEntropy = computeEntropy(im801b);
im801cEntropy = computeEntropy(im801c);

% Problem 2: Huffman Coding
% Solve problems 8.9(a-f) and 8.10

im8bit = [  21  21  21  95  169 243 243 243 ;   ...
            21  21  21  95  169 243 243 243 ;   ...
            21  21  21  95  169 243 243 243 ;   ...
            21  21  21  95  169 243 243 243 ]   ;
    % 8.9(a) Compute Entropy of im8bit
    im8bitEntropy = computeEntropy(cast(im8bit, 'uint8'));
    
    % 8.9(b) Compress image using Huffman Coding
    im8bitHuffEncoded = huffmanCompress(im8bit);
end


function[entropyEst] = computeEntropy(image)
    [imCounts, imBins] = imhist(image);

    totalCounts = sum(imCounts(:));
    pk = 0.*length(imBins);
    for i = 1:length(imBins)
        pk(i) = imCounts(i)/totalCounts;
    end

    H_vect = 0*pk;

    for i = 1:length(pk)
        if (pk(i) ~= 0)
            H_vect(i) = -1*pk(i)*log2(pk(i));    
        else
            H_vect(i) = 0;
        end
    end

    entropyEst = sum(H_vect(:));

end

function [huffmanEncoded] = huffmanCompress(image)
    [imCounts imBins] = imhist(cast(image, 'uint8'));
    
    %Step 1: Order Probabilities and symbols
    pk = zeros(length(imBins),2);
    totalCounts = sum(imCounts(:));
    for i = 1:length(imBins)
        pk(i, 1) = imCounts(i)/totalCounts;
        pk(i,2) = i;
    end
    
    OrigSource = sortrows(pk, 1, 'descend');
    
    %Step 2: Encode Source Reduction
    huffMan = OrigSource(:,1)';
    
    while (length(huffMan) > 2)
        tempSource = huffMan;
        newEnd = tempSource(end) + tempSource(end-1);
        intSource = [];
        for i =1:length(tempSource)-2
            intSource(i) = tempSource(i);
        end
        huffMan = [intSource, newEnd];
    end
    
    huffmanEncoded = huffMan;
end

function [L,numBits] = computeVariableLength(image)
    m = size(image,1)*size(image,2);
    
    for i = 1:size(image,1)
        for ii = 1:size(image,2)
            image(i,ii) = dec2bin(image(i,ii));
        end
    end

    L_temp = sum(sum(image(:,:)))/m;
    p = nextpow2(L_temp);
    L = 2^p;
    numBits = p;
end

function [rmse] = rootMeanSquareError(image, imageCompressed)
    temp = 0.*image;
    
    for i = size(image,1)
        for ii = size(image,2)
            temp(i,ii) = (imageCompressed(i,ii) - image(i,ii)).^2;
        end
    end
    
    rmse = sqrt(sum(sum(temp(:,:)))/(size(image,1)*size(image,2)));
end