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
    
    % 8.9(c)Compute the compression achieved and the effectiveness
    %       of the Huffman coding
    
    % 8.9(d)Consider the 2nd extension of the zero-memory, what
    %       is the entropy of the image as pairs of pixels?
    
    % 8.9(e)Consider the differences between adjacent pixels, what
    %       is the entropy of the new dif. image? (What's this mean?)
    
    % 8.9(f)Explain the entropy differences in a, d, and e
    
    
    % 8.10 Using the Huffman in Fig. 8.8 decode 0101000001010111110100
    
% Problem 3: Transform Coding
im8_9a_path = [pwd, filesep, 'Fig0809(a).tif'];
im8_9a = imread(im8_9a_path);

    %(a)Compute the information lost on Fourier and Cosine transforms
        L = 20;
        fun1 = @(block_struct) fourier8LargeTransform(block_struct.data, L);
        temp = cast(im8_9a, 'double');
        im8_9a_fourier = blockproc(temp, [8 8], fun1);
        
            im8_9a_fourier_RMS = rootMeanSquareError(  cast(im8_9a, 'double'),      im8_9a_fourier);
            im8_9a_fourier_SNR = snrmsError(           cast(im8_9a, 'double'),      im8_9a_fourier);

        fun2 = @(block_struct) cosine8LargeTransform(block_struct.data, L);
        im8_9a_cosine = blockproc(im8_9a, [8 8], fun2);
            im8_9a_cosine_RMS = rootMeanSquareError(  cast(im8_9a, 'double'),      im8_9a_cosine);
            im8_9a_cosine_SNR = snrmsError(           cast(im8_9a, 'double'),      im8_9a_cosine);
    %(b)
    
% Problem 4: Wavelet Coding
% Compress image Fig. 8.9(a) using Harr DWT for different scales white
% **truncating the detail coefficients** to achieve compression. Computer
% RMS error and SNRms error and compression performance

%Truncation: I assume that the wording means to zero out the diagonal,
%vertical, and horizontal coeficient matrices.
[iDWT1_1, iDWT2_1] = haarWavelet2D(im8_9a, 1);
[iDWT1_2, iDWT2_2] = haarWavelet2D(im8_9a, 2);
[iDWT1_3, iDWT2_3] = haarWavelet2D(im8_9a, 3);

figure(411); imshow(cast(iDWT1_1, 'uint8')); title('Truncated Reconstruction 1.1 (Efficient)');
figure(412); imshow(cast(iDWT1_2, 'uint8')); title('Truncated Reconstruction 1.2 (Efficient)');
figure(413); imshow(cast(iDWT1_3, 'uint8')); title('Truncated Reconstruction 1.3 (Efficient)');
figure(421); imshow(cast(iDWT2_1, 'uint8')); title('Truncated Reconstruction 2.1 (Simple)');
figure(422); imshow(cast(iDWT2_2, 'uint8')); title('Truncated Reconstruction 2.2 (Simple)');
figure(423); imshow(cast(iDWT2_3, 'uint8')); title('Truncated Reconstruction 2.3 (Simple)');

end

function [imOut] = fourier8LargeTransform(image,L)
    A = fft2(image);    
    B = sort(A);
    C = B(1:L);
    Aprime = 0.*A;
    
    for a = 1:size(A,1)
        for b = 1:size(A,2)
            for c = 1:length(C)
                if (A(a,b) == C(c))
                    Aprime(a,b) = C(c);
                end
            end
        end
    end

    imOut = ifft2(Aprime);
end

function [imOut] = cosine8LargeTransform(image,L)
    A = dct2(image);    
    B = sort(A);
    C = B(1:L);
    Aprime = 0.*A;
    
    for a = 1:size(A,1)
        for b = 1:size(A,2)
            for c = 1:length(C)
                if (A(a,b) == C(c))
                    Aprime(a,b) = C(c);
                end
            end
        end
    end

    imOut = idct2(Aprime);
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

    Huffman = struct();
    Huffman.s1 = { [0.375, 0.375, 0.125, 0.125];
                    [21,   243,   95,    169];
                    ['P1', 'P2',  'P3',  'P4'];
                    ['0',  '00',  '010', '011'];
                  };
    Huffman.s2 = { [0.375, 0.375, 0.25];
                    [21,   243,   (95+169)/2];
                    ['P1', 'P2',  'P3 P4'];
                    ['0',  '00',  '01'];
                  };
    Huffman.s3 = { [0.375, 0.625];
                    [21,   (243+95+169)/2];
                    ['P1', 'P2 P3 P4'];
                    ['0',  '1'];
                  };


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
    
    rmse = real( sqrt(sum(sum(temp(:,:))).^2/(size(image,1)*size(image,2))) );
end

function [snr] = snrmsError(image, imageCompressed)
    rmse = rootMeanSquareError(image, imageCompressed);
    
    denom = size(image,1)*size(image,2)*(rmse).^2;
    num = sum(sum(imageCompressed(:,:))).^2;
    
    snr = real( num/denom );
end

function [iDWT, iDWT1] = haarWavelet2D(image, J)
%Computationally efficient method
[DWT, S] = wavedec2(image, J, 'haar');
    n = S(1,1)*S(1,2);
    DWT(n+1:end) = 0;
[iDWT]   = waverec2(DWT, S, 'haar');

%Intuitively efficient method
a = appcoef2(DWT,S,'haar');
temp = a;
for i = 1:J
   temp = idwt2(temp, 0.*temp, 0.*temp, 0.*temp, 'haar');
end
iDWT1 = temp;
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

function [imageOut] = quantize(image)
    imageOut = 0.*image;
    for i = 1:size(image,1)
        for ii = 1:size(image,2)
            if (image(i,ii) <= -68)
                imageOut(i,ii) = 0;
            elseif(image(i,ii) <= -8)
                imageOut(i,ii) = 112;
            elseif (image(i,ii) <= 32)
                imageOut(i,ii) = 128;
            elseif (image(i,ii) <= 64)
                imageOut(i,ii) = 160;
            else
                imageOut(i,ii) = 256;
            end
        end
    end
end
