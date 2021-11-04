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
    
    %SEE THE HAND SOLVED PROBLEM AND DISCUSSION IN REPORT FOR THE FOLLOWING
    % 8.9(b) Compress image using Huffman Coding
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
L = [8, 7, 6, 5, 4, 3, 2, 1];
    %(a)Compute the information lost on Fourier and Cosine transforms
        fun1 = @(block_struct) fourier8LargeTransform(block_struct.data, L(1));
        temp = cast(im8_9a, 'double');
        im8_9a_fourier_8 = blockproc(temp, [8 8], fun1);
        
            im8_9a_fourier_RMS_8 = rootMeanSquareError(  cast(im8_9a, 'double'),      im8_9a_fourier_8);
            im8_9a_fourier_SNR_8 = snrmsError(           cast(im8_9a, 'double'),      im8_9a_fourier_8);

        fun11 = @(block_struct) cosine8LargeTransform(block_struct.data, L(1));
        im8_9a_cosine_8 = blockproc(im8_9a, [8 8], fun11);
            im8_9a_cosine_RMS_8 = rootMeanSquareError(  cast(im8_9a, 'double'),      im8_9a_cosine_8);
            im8_9a_cosine_SNR_8 = snrmsError(           cast(im8_9a, 'double'),      im8_9a_cosine_8);
            
    %(b) Reduce the value of the L-largest coding from 8
        fun2 = @(block_struct) fourier8LargeTransform(block_struct.data, L(2));
        temp = cast(im8_9a, 'double');
        im8_9a_fourier_7 = blockproc(temp, [8 8], fun2);
        
            im8_9a_fourier_RMS_7 = rootMeanSquareError(  cast(im8_9a, 'double'),      im8_9a_fourier_7);
            im8_9a_fourier_SNR_7 = snrmsError(           cast(im8_9a, 'double'),      im8_9a_fourier_7);

        fun22 = @(block_struct) cosine8LargeTransform(block_struct.data, L(2));
        im8_9a_cosine_7 = blockproc(im8_9a, [8 8], fun22);
            im8_9a_cosine_RMS_7 = rootMeanSquareError(  cast(im8_9a, 'double'),      im8_9a_cosine_7);
            im8_9a_cosine_SNR_7 = snrmsError(           cast(im8_9a, 'double'),      im8_9a_cosine_7);
            
        fun3 = @(block_struct) fourier8LargeTransform(block_struct.data, L(3));
        temp = cast(im8_9a, 'double');
        im8_9a_fourier_6 = blockproc(temp, [8 8], fun3);
        
            im8_9a_fourier_RMS_6 = rootMeanSquareError(  cast(im8_9a, 'double'),      im8_9a_fourier_6);
            im8_9a_fourier_SNR_6 = snrmsError(           cast(im8_9a, 'double'),      im8_9a_fourier_6);

        fun33 = @(block_struct) cosine8LargeTransform(block_struct.data, L(3));
        im8_9a_cosine_6 = blockproc(im8_9a, [8 8], fun33);
            im8_9a_cosine_RMS_6 = rootMeanSquareError(  cast(im8_9a, 'double'),      im8_9a_cosine_6);
            im8_9a_cosine_SNR_6 = snrmsError(           cast(im8_9a, 'double'),      im8_9a_cosine_6);
            
        fun4 = @(block_struct) fourier8LargeTransform(block_struct.data, L(4));
        temp = cast(im8_9a, 'double');
        im8_9a_fourier_5 = blockproc(temp, [8 8], fun4);
        
            im8_9a_fourier_RMS_5 = rootMeanSquareError(  cast(im8_9a, 'double'),      im8_9a_fourier_5);
            im8_9a_fourier_SNR_5 = snrmsError(           cast(im8_9a, 'double'),      im8_9a_fourier_5);

        fun44 = @(block_struct) cosine8LargeTransform(block_struct.data, L(4));
        im8_9a_cosine_5 = blockproc(im8_9a, [8 8], fun44);
            im8_9a_cosine_RMS_5 = rootMeanSquareError(  cast(im8_9a, 'double'),      im8_9a_cosine_5);
            im8_9a_cosine_SNR_5 = snrmsError(           cast(im8_9a, 'double'),      im8_9a_cosine_5);
            
        fun5 = @(block_struct) fourier8LargeTransform(block_struct.data, L(5));
        temp = cast(im8_9a, 'double');
        im8_9a_fourier_4 = blockproc(temp, [8 8], fun5);
        
            im8_9a_fourier_RMS_4 = rootMeanSquareError(  cast(im8_9a, 'double'),      im8_9a_fourier_4);
            im8_9a_fourier_SNR_4 = snrmsError(           cast(im8_9a, 'double'),      im8_9a_fourier_4);

        fun55 = @(block_struct) cosine8LargeTransform(block_struct.data, L(5));
        im8_9a_cosine_4 = blockproc(im8_9a, [8 8], fun55);
            im8_9a_cosine_RMS_4 = rootMeanSquareError(  cast(im8_9a, 'double'),      im8_9a_cosine_4);
            im8_9a_cosine_SNR_4 = snrmsError(           cast(im8_9a, 'double'),      im8_9a_cosine_4);
            
        fun6 = @(block_struct) fourier8LargeTransform(block_struct.data, L(6));
        temp = cast(im8_9a, 'double');
        im8_9a_fourier_3 = blockproc(temp, [8 8], fun6);
        
            im8_9a_fourier_RMS_3 = rootMeanSquareError(  cast(im8_9a, 'double'),      im8_9a_fourier_3);
            im8_9a_fourier_SNR_3 = snrmsError(           cast(im8_9a, 'double'),      im8_9a_fourier_3);

        fun66 = @(block_struct) cosine8LargeTransform(block_struct.data, L(6));
        im8_9a_cosine_3 = blockproc(im8_9a, [8 8], fun66);
            im8_9a_cosine_RMS_3 = rootMeanSquareError(  cast(im8_9a, 'double'),      im8_9a_cosine_3);
            im8_9a_cosine_SNR_3 = snrmsError(           cast(im8_9a, 'double'),      im8_9a_cosine_3);
            
        fun7 = @(block_struct) fourier8LargeTransform(block_struct.data, L(7));
        temp = cast(im8_9a, 'double');
        im8_9a_fourier_2 = blockproc(temp, [8 8], fun7);
        
            im8_9a_fourier_RMS_2 = rootMeanSquareError(  cast(im8_9a, 'double'),      im8_9a_fourier_2);
            im8_9a_fourier_SNR_2 = snrmsError(           cast(im8_9a, 'double'),      im8_9a_fourier_2);

        fun77 = @(block_struct) cosine8LargeTransform(block_struct.data, L(7));
        im8_9a_cosine_2 = blockproc(im8_9a, [8 8], fun77);
            im8_9a_cosine_RMS_2 = rootMeanSquareError(  cast(im8_9a, 'double'),      im8_9a_cosine_2);
            im8_9a_cosine_SNR_2 = snrmsError(           cast(im8_9a, 'double'),      im8_9a_cosine_2);
            
        fun8 = @(block_struct) fourier8LargeTransform(block_struct.data, L(8));
        temp = cast(im8_9a, 'double');
        im8_9a_fourier_1 = blockproc(temp, [8 8], fun8);
        
            im8_9a_fourier_RMS_1 = rootMeanSquareError(  cast(im8_9a, 'double'),      im8_9a_fourier_1);
            im8_9a_fourier_SNR_1 = snrmsError(           cast(im8_9a, 'double'),      im8_9a_fourier_1);

        fun88 = @(block_struct) cosine8LargeTransform(block_struct.data, L(8));
        im8_9a_cosine_1 = blockproc(im8_9a, [8 8], fun88);
            im8_9a_cosine_RMS_1 = rootMeanSquareError(  cast(im8_9a, 'double'),      im8_9a_cosine_1);
            im8_9a_cosine_SNR_1 = snrmsError(           cast(im8_9a, 'double'),      im8_9a_cosine_1);
    
% Problem 4: Wavelet Coding
% Compress image Fig. 8.9(a) using Harr DWT for different scales white
% **truncating the detail coefficients** to achieve compression. Computer
% RMS error and SNRms error and compression performance

%Truncation: I assume that the wording means to zero out the diagonal,
%vertical, and horizontal coeficient matrices.
[iDWT1_1, iDWT2_1] = haarWavelet2D(im8_9a, 1);
[iDWT1_2, iDWT2_2] = haarWavelet2D(im8_9a, 2);
[iDWT1_3, iDWT2_3] = haarWavelet2D(im8_9a, 3);

% figure(411); imshow(cast(iDWT1_1, 'uint8')); title('Truncated Reconstruction 1.1 (Efficient)');
% figure(412); imshow(cast(iDWT1_2, 'uint8')); title('Truncated Reconstruction 1.2 (Efficient)');
% figure(413); imshow(cast(iDWT1_3, 'uint8')); title('Truncated Reconstruction 1.3 (Efficient)');
% figure(421); imshow(cast(iDWT2_1, 'uint8')); title('Truncated Reconstruction 2.1 (Simple)');
% figure(422); imshow(cast(iDWT2_2, 'uint8')); title('Truncated Reconstruction 2.2 (Simple)');
% figure(423); imshow(cast(iDWT2_3, 'uint8')); title('Truncated Reconstruction 2.3 (Simple)');

im8_9a_iDWT1_RMS = rootMeanSquareError(  cast(im8_9a, 'double'),      iDWT1_1);
im8_9a_iDWT1_SNR = snrmsError(           cast(im8_9a, 'double'),      iDWT1_1);
im8_9a_iDWT2_RMS = rootMeanSquareError(  cast(im8_9a, 'double'),      iDWT1_2);
im8_9a_iDWT2_SNR = snrmsError(           cast(im8_9a, 'double'),      iDWT1_2);
im8_9a_iDWT3_RMS = rootMeanSquareError(  cast(im8_9a, 'double'),      iDWT1_3);
im8_9a_iDWT3_SNR = snrmsError(           cast(im8_9a, 'double'),      iDWT1_3);

figure(4);
subplot(1,3,1); imshow(cast(iDWT1_1, 'uint8')); title('Truncated Reconstruction J=1');
subplot(1,3,2); imshow(cast(iDWT1_2, 'uint8')); title('Truncated Reconstruction J=2');
subplot(1,3,3); imshow(cast(iDWT1_3, 'uint8')); title('Truncated Reconstruction J=3');
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

function [Huffman] = huffmanCompress()

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
