% Project 6
% CEG 7850 - Digital Image Processing
% Alex Reigle

function [] = main()
path = pwd;

% Problem 1: Salt & Pepper Noise Generation/Median Filter based Noise Reduction
% (a) Add salt-pepper noise to Fig. 5.7(a) from text with Pa=Pb= 0.2
%     eqn. (5-16) p(z) = { Pa       ;  for z = 2^(k)-1
%                        { Pb       ;  for z = 0
%                        { 1-(Pa+Pb);  for z = V
im5_7a_path = [path, filesep, 'Fig0507(a).tif'];
im5_7a = imread(im5_7a_path);

im5_7a_SaltPepper = addSaltPepper(im5_7a, 0.2, 0.2);

figure(11);imshow(cast(im5_7a_SaltPepper, 'uint8'));  title('Salt and Pepper Noise (Pa=Pb=0.2)');


% (b) Apply median filtering block (3x3) to new image.
im5_7a_MedianNoise1 = median3x3Filter(im5_7a_SaltPepper);

figure(12);imshow(cast(im5_7a_MedianNoise1, 'uint8'));title('Median Filter (1 pass)');

% (c) Apply two more passes of median filtering and display results
im5_7a_MedianNoise2 = median3x3Filter(im5_7a_MedianNoise1);
im5_7a_MedianNoise3 = median3x3Filter(im5_7a_MedianNoise2);

figure(13);imshow(cast(im5_7a_MedianNoise2, 'uint8'));title('Median Filter (2 pass)');
figure(14);imshow(cast(im5_7a_MedianNoise3, 'uint8')); title('Median Filter (3 pass)');

% (d) Explain any major differences

%Median filter using row/column duplication for the first and last
%row/column - reducing edge effects.
im5_7a_ALT_MedianNoise1 = ALTmedian3x3Filter(im5_7a_SaltPepper);
im5_7a_ALT_MedianNoise2 = ALTmedian3x3Filter(im5_7a_ALT_MedianNoise1);
im5_7a_ALT_MedianNoise3 = ALTmedian3x3Filter(im5_7a_ALT_MedianNoise2);

figure(15);imshow(cast(im5_7a_ALT_MedianNoise3, 'uint8'));title('Median Filter with Border Row/Col Duplication (3 pass)');

% Problem 2: Periodic Noise Reduction Using a Notch Filter
% (a) Remove sinusoidal interference in frequency domain from astronaut
astronautNoise_path = [path, filesep, 'astronaut-interference.tif'];
astronautNoise = cast(imread(astronautNoise_path), 'double');

figure(2);imshow(cast(astronautNoise, 'uint8'));title('Original Noisy Astronaut Image');

astronautSpectra = fft2(astronautNoise);
astronautSpectra = fftshift(astronautSpectra);
astronautSpectra_dB = 20*log10(sqrt(real(astronautSpectra).^2 + imag(astronautSpectra).^2));

figure(21);imshow(cast(astronautSpectra_dB, 'uint8'));title('Frequency Domain of Noisy Astronaut Image');

% Through inspecting figure(21), we see frequency noise centered at the
% points [974 963] and [1076 1087] (image center at [1025 1025]
M = size(astronautSpectra_dB,1);
N = size(astronautSpectra_dB,2);
m1 = 974; m2 = 1076;
n1 = 963; n2 = 1087;
astronautFilteredSpectra_dB = fft2dFilter(astronautNoise, ...
                                          M, N, n1-1025+1, m1-1025+1, 40);
                                   
% (b) Display and compare to original image
        % Note the glow around sharp edges and the brightness
figure(22);imshow(cast(astronautFilteredSpectra_dB, 'uint8'));title('Astronaut Image with Period Noise Removed (Gaussian Notch)');

origAstronaut = imread([path, filesep, 'astronaut.tif']);
figure(23);imshow(origAstronaut);title('NASA Noise-free Astronaut Image');

% Problem 3: Pseudo-Color
% (a) Reduce Fig 1.10(4) to two intensity levels yellow and unchanged
im1_10_path = [path, filesep, 'Fig0110(4)(WashingtonDC Band4).TIF'];
im1_10 = imread(im1_10_path);

[m, n]=size(im1_10);

rgbImage1_10 = zeros(m,n,3);

for i = 1:size(im1_10,1)
    for ii = 1:size(im1_10,2)
        if(im1_10(i,ii) <= 20)
            rgbImage1_10(i,ii,1)  = 255;
            rgbImage1_10(i,ii,2)  = 255;
            rgbImage1_10(i,ii,3) = 0;
        else
            rgbImage1_10(i,ii,1)  = im1_10(i,ii);
            rgbImage1_10(i,ii,2)  = im1_10(i,ii);
            rgbImage1_10(i,ii,3) = im1_10(i,ii);
        end
    end
end

yellowRiverImage=rgbImage1_10/255;

figure(31);imshow(yellowRiverImage); title('Yellow River City Image');

% (b) Reproduce eight color intensity from Figure 6.18(b) from 6.18(a)
im6_18a_path = [path, filesep, 'Fig0718(a)(picker_phantom).tif'];
im6_18a = imread(im6_18a_path);

[m, n]=size(im6_18a);
rgbImage6_18a = zeros(m,n,3);

for i = 1:size(im6_18a,1)
    for ii = 1:size(im6_18a,2)
        if(im6_18a(i,ii) >= 125)
            %White
            rgbImage6_18a(i,ii,1) = 1;
            rgbImage6_18a(i,ii,2) = 1;
            rgbImage6_18a(i,ii,3) = 1;
        elseif(im6_18a(i,ii) >= 110)
            %Red
            rgbImage6_18a(i,ii,1) = 1;
            rgbImage6_18a(i,ii,2) = 0;
            rgbImage6_18a(i,ii,3) = 0;
        elseif(im6_18a(i,ii) >= 80)
            %Yellow
            rgbImage6_18a(i,ii,1) = 1;
            rgbImage6_18a(i,ii,2) = 1;
            rgbImage6_18a(i,ii,3) = 0;
        elseif(im6_18a(i,ii) >= 52)
            %Green
            rgbImage6_18a(i,ii,1) = 0;
            rgbImage6_18a(i,ii,2) = 1;
            rgbImage6_18a(i,ii,3) = 0;
        
        elseif(im6_18a(i,ii) >= 40)
            %Orange
            rgbImage6_18a(i,ii,1) = 0.929;
            rgbImage6_18a(i,ii,2) = 0.6940;
            rgbImage6_18a(i,ii,3) = 0.1250;
        elseif(im6_18a(i,ii) >= 21)
            %Pink
            rgbImage6_18a(i,ii,1) = 0;
            rgbImage6_18a(i,ii,2) = 1;
            rgbImage6_18a(i,ii,3) = 1;
        elseif(im6_18a(i,ii) >= 20)
            %Light Blue
            rgbImage6_18a(i,ii,1) = 0.301;
            rgbImage6_18a(i,ii,2) = 0.745;
            rgbImage6_18a(i,ii,3) = 0.933;
        elseif(im6_18a(i,ii) >= 0.005)
            %Dark Blue
            rgbImage6_18a(i,ii,1) = 0;
            rgbImage6_18a(i,ii,2) = 0;
            rgbImage6_18a(i,ii,3) = 1;
        else
            %Black
            rgbImage6_18a(i,ii,1) = 0;
            rgbImage6_18a(i,ii,2) = 0;
            rgbImage6_18a(i,ii,3) = 0;
        end
    end
end

figure(32);imshow(rgbImage6_18a); title('Greyscale Psuedo Coloring');

% Problem 4: Color Image Enhancement
% Histogram Equalize the RGB of Figure 6.33
im7_33_path = [path, filesep, 'Fig0733(bottom_left_stream).tif'];
im7_33 = imread(im7_33_path);

rgbImage7_33 = im7_33;

R = rgbImage7_33(:,:,1);
G = rgbImage7_33(:,:,2);
B = rgbImage7_33(:,:,3);

rHist = histeq(R, gray(256));
gHist = histeq(G, gray(256));
bHist = histeq(B, gray(256));

% Applied Circular Transform to match textbook image (R=1, o(x,y) = [1,0])
circ = linspace(0, 2*pi, 256*4);
y = 1*sin(circ(257:512)-1)+1; y = flip(y);

R1 = R; G1 = G; B1 = B;
for i = 1:size(rHist,1)
   R1(R==i-1) = R(R==i-1)*rHist(i,1)*y(i);    r1_hist(i) = rHist(i,1)*y(i);
   G1(G==i-1) = G(G==i-1)*gHist(i,1)*y(i);    g1_hist(i) = gHist(i,1)*y(i);
   B1(B==i-1) = B(B==i-1)*bHist(i,1)*y(i);    b1_hist(i) = bHist(i,1)*y(i);
end

bestIm = zeros(size(im7_33,1),size(im7_33,2));
bestIm(:,:,1) = R1;
bestIm(:,:,2) = G1;
bestIm(:,:,3) = B1;

% RGB HistEQ Transform
R2 = R; G2 = G; B2 = B;
for i = 1:size(rHist,1)
   R2(R==i-1) = R(R==i-1)*rHist(i,1);
   G2(G==i-1) = G(G==i-1)*gHist(i,1);
   B2(B==i-1) = B(B==i-1)*bHist(i,1);
end

rgbHistIm = zeros(size(im7_33,1),size(im7_33,2));
rgbHistIm(:,:,1) = R2;
rgbHistIm(:,:,2) = G2;
rgbHistIm(:,:,3) = B2;

figure(423); rgbplot(bHist);

% %Overall Mean HistEQ Transform
meanHist = (rHist + gHist + bHist)/ 3;
R3 = R; G3 = G; B3 = B;
for i = 1:size(meanHist,1)
   R3(R==i-1) = R(R==i-1)*meanHist(i,1);
   G3(G==i-1) = G(G==i-1)*meanHist(i,2);
   B3(B==i-1) = B(B==i-1)*meanHist(i,3);
end

meanHistIm = zeros(size(im7_33,1),size(im7_33,2));
meanHistIm(:,:,1) = R3;
meanHistIm(:,:,2) = G3;
meanHistIm(:,:,3) = B3;

figure(400); 
subplot(2,3,1); rgbplot(rHist); xlim([0 256]);                        title('Original Image Red Histogram');          
subplot(2,3,2); rgbplot(gHist); xlim([0 256]);                        title('Original Image Green Histogram');        
subplot(2,3,3); rgbplot(bHist); xlim([0 256]);                        title('Original Image Blue Histogram');         
subplot(2,3,4); rgbplot(meanHist); xlim([0 256]);                     title('HistEQ Mean Image Histogram');           
subplot(2,3,5); rgbplot([r1_hist; r1_hist; r1_hist]'); xlim([0 256]); title('Circular HistEQ Mean Image Histogram');  
subplot(2,3,6); plot(y); xlim([0 256]);                               title('Circular HistEQ Circular Function');     

figure(410); 
subplot(2,2,1);  imshow(cast(im7_33, 'uint8'));         title('Original Image');             
subplot(2,2,2); imshow(cast(meanHistIm, 'uint8'));      title('HistEQ Mean Image');           
subplot(2,2,3); imshow(cast(rgbHistIm, 'uint8'));       title('RGB HistEQ Image');            
subplot(2,2,4); imshow(cast(bestIm, 'uint8'));          title('Circular HistEQ Mean Image'); 


% Problem 5: Color Image Segmentation
% Recreate results of Example 6.15 for dark regions using Fig. 6.26(b)
im6_26_path = [pwd, filesep, 'Fig0726(b)(jupiter-Io-closeup).tif'];
im6_26 = imread(im6_26_path);

im6_26 = cast(im6_26, 'double');

obs1 = reshape(im6_26(25:416, 5:150, :), [3, 392*146]);
obs2 = reshape(im6_26(1:200, 250:450, :), [3, 200*201]);
obs3 = reshape(im6_26(270:416, 325:550, :), [3, 147*226]);
obs4 = reshape(im6_26(100:300, 100:350, :), [3, 201*251]);

R = [obs1(1,:), obs2(1,:), obs3(1,:), obs4(1,:)];
G = [obs1(2,:), obs2(2,:), obs3(2,:), obs4(2,:)];
B = [obs1(3,:), obs2(3,:), obs3(3,:), obs4(3,:)];

stdR = std(R);  stdG = std(G);  stdB = std(B);
avgR = mean(R); avgG = mean(G); avgB = mean(B);

N = 1.1; % number of standard deviations

lowerR = avgR - N*stdR;     upperR = avgR + N*stdR;
lowerG = avgG - N*stdG;     upperG = avgG + N*stdG;
lowerB = avgB - N*stdB;     upperB = avgB + N*stdB;

% Redefine RGB for easier reshaping later. This also allows the
% segmentation to be applied directly to image - forgoing the need for a
% mask.
R = reshape(im6_26(:,:,1), [1 size(im6_26,1)*size(im6_26,2)]);
G = reshape(im6_26(:,:,1), [1 size(im6_26,1)*size(im6_26,2)]);
B = reshape(im6_26(:,:,1), [1 size(im6_26,1)*size(im6_26,2)]);

for i = 1:size(R,2)
    if( R(i) <= lowerR )
        R(i) = 1;
    elseif( R(i) > lowerR )
        R(i) = 0;
    end
    
    if( G(i) <= lowerG )
        G(i) = 1;
    elseif( G(i) > lowerG )
        G(i) = 0;
    end
    
    if( B(i) <= lowerB )
        B(i) = 1;
    elseif( B(i) > lowerB )
        B(i) = 0;
    end
end

segIm(:,:,1) = reshape(R, [size(im6_26,1), size(im6_26,2)]);
segIm(:,:,2) = reshape(G, [size(im6_26,1), size(im6_26,2)]);
segIm(:,:,3) = reshape(B, [size(im6_26,1), size(im6_26,2)]);

figure(5);imagesc(segIm);title('Segmented Dark Region Color Image (N=1.1)');

end

function [saltPepperImage] = addSaltPepper(image, Pa, Pb)
% Here I assume that the image is unit8 (256 bits). However, a trivial check
% of type could automate this process.

P_else = 1 - Pa - Pb;
N = zeros(size(image,1),size(image,2));
iii = 1;

for i = 1:size(image, 1)
    for ii = 1:size(image, 2)
        draw = rand;
        if(draw(iii) > P_else)
            if(draw <= P_else+Pa)
               N(i,ii) = 255; 
            else
               N(i,ii) = 0;
            end
        else
            N(i,ii) = image(i,ii);
        end
    end
end

%Per the odd definition in the text which separates N from f (new image)
for i = 1:size(image, 1)
    for ii = 1:size(image, 2)
        if(N(i,ii) == 255)
            image(i,ii) = 255;
        elseif(N(i,ii) == 0)
            image(i,ii) = 0;
        end
    end
end
saltPepperImage = image;
%saltPepperImage = cast(N,'uint8');
end

function [medImage] = median3x3Filter(image)
zeroPaddedImage = zeros(size(image,1)+2,size(image,2)+2);
zeroPaddedImage(2:end-1, 2:end-1) = image;

tempImage = zeros(size(zeroPaddedImage,1),size(zeroPaddedImage,2));

for i = 2:size(zeroPaddedImage,1)-1
    for ii = 2:size(zeroPaddedImage,2)-1
        med = median(median(zeroPaddedImage([i-1:i+1],[ii-1:ii+1])));
        tempImage(i,ii) = med;
    end
end
medImage = tempImage(2:end-1,2:end-1);
end

function [medImage] = ALTmedian3x3Filter(image)
duplicatedRCImage = zeros(size(image,1)+2,size(image,2)+2);
duplicatedRCImage(2:end-1, 2:end-1) = image;
duplicatedRCImage(1,:)   = [image(1,1),   image(1,:),   image(1,end)];
duplicatedRCImage(end,:) = [image(end,1), image(end,:), image(end,end)];
duplicatedRCImage(:,1)   = [image(1,1);   image(:,1);   image(end,1)];
duplicatedRCImage(:,end) = [image(end,1); image(:,end); image(end,end)];

tempImage = zeros(size(duplicatedRCImage,1),size(duplicatedRCImage,2));

for i = 2:size(duplicatedRCImage,1)-1
    for ii = 2:size(duplicatedRCImage,2)-1
        med = median(median(duplicatedRCImage([i-1:i+1],[ii-1:ii+1])));
        tempImage(i,ii) = med;
    end
end
medImage = tempImage(2:end-1,2:end-1);
end

function [imageFFT] = fft2dFilter(image, M, N, m, n, Do)
% Function fft2dFilter
    %     image  = input image
    %     M      = row size of output image 
    %     N      = column size of output image
    %     m      = filter center row shift      (m = 0 reprents a centered filter) Note: m <= M
    %     n      = filter center column shift   (n = 0 reprents a centered filter) Note: n <= N
    %     Do     = Cutoff Frequency
    %     Nb     = Butterworth Order
    %     filter = filter type
    
    P = 2^nextpow2(M);
    Q = 2^nextpow2(N);
    
    % Ensure that that user-defined dimensions are square
    if(P>Q)
        Q = P;
    elseif(Q>P)
        P = Q;
    end
    
    zeroPaddedImage = zeros(2*P,2*Q);
    
    [y, x] = meshgrid(1:2*P, 1:2*Q);
    
    zeroPaddedImage(1:M,1:N) = zeroPaddedImage(1:M, 1:N) + cast(image, 'double');

% a) Multiply the input image by (-1)^(x+y)
    % imageA = fftshift(zeroPaddedImage);
    imageA = ((-1).^(x+y)).*zeroPaddedImage;

% b) Compute the 2-D Fourier transform
    imageB = fft2(imageA);

% c) Multiply the resulting (complex) array by a real filter function.
    % Check if Centered Spectrum is Desired (i.e. Problem 2a check)
    [v, u] = meshgrid(1:2*P, 1:2*Q);
    
    Duv1 = 1 - exp(-1*(sqrt( (v-(P-n+2)).^2 + (u-(Q-m+3)).^2 )).^2./(2*Do^2));
    Duv2 = 1 - exp(-1*(sqrt( (v-(P+n)).^2 + (u-(Q+m)).^2 )).^2./(2*Do^2));
    H = zeros(size(Duv1,1),size(Duv1,2));
    
    for i = 1:size(Duv1, 1)
        for ii = 1:size(Duv1, 2)
            H(i,ii) = Duv1(i,ii)*Duv2(i,ii);
        end
    end
    
    filteredImage = imageB.*H;
    imageC = (filteredImage);

% d) Compute the inverse 2-D Fourier transform
    imageD = ifft2(imageC);

% e) Multiply the input image by (-1)^(x+y)
    imageE = ((-1).^(x+y)).*real(imageD);
    
% Finally, pull out the image of original MxN size
    imageFFT =   imageE(1:M,1:N);
    
end