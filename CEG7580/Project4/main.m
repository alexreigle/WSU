% Project 4
% CEG 7850 - Digital Image Processing
% Alex Reigle

function [] = main()
path = pwd;

% Problem 1: Two-Dimensional Fast Fourier Transform
% See [imageFFT] = fft2dFilter(image, filter)

% Problem 2: Fourier Spectrum and Average Value
% (a) Calculated Center Fourier Spectrum
    im4_40a_path = [pwd, filesep, 'Fig0440(a)(testpattern).tif'];
    im4_40a = imread(im4_40a_path);
    
    im4_40a_Spectra = fft2dFilter(cast(im4_40a, 'double'), size(im4_40a,1), size(im4_40a,2), 0, 0, 0, 0, "return spectrum");
    im4_40a_SpectraDB = 20*log10(sqrt(real(im4_40a_Spectra).^2 + imag(im4_40a_Spectra).^2));
    
% (b) Display the spectrum
    figure(2); hold on; title('Image 4.40a Fourier Spectrum');
    
    tempImage = ifftshift(im4_40a_SpectraDB);
    tempImage2 = (tempImage(1:size(im4_40a,1),1:size(im4_40a,2)));
    centeredImage4_40aSpectra = tempImage2;
    
    imshow(cast(abs(im4_40a_SpectraDB), 'uint8'));
    % imshow(cast(centeredImage4_40aSpectra, 'uint8'));
    
% (c) Compute the average value of the spectra from 2(a)
    avgIm4_40a = mean(mean(im4_40a_SpectraDB));
    disp(avgIm4_40a);
    
    answer = questdlg(['The average value of Image 4.40a is ', num2str(avgIm4_40a)], ...
	'Is this the correct answer?', ...
	'Correct!','Incorrect.','Incorrect.');
        % Handle response
        switch answer
            case 'Correct!'
                msgbox([answer ' Hooray! :)'])
            case 'Incorrect.'
                msgbox([answer ' Oh darn! :('])
        end
        
% Problem 3: Lowpass Filtering
% (a) Implement the Gaussian lowpass filter:
%     H(u,v) = exp( -D(u,v)^2/(2*Do^2) )       (eqn 4-116)

    % See [imageFFT] = fft2dFilter(image, filter = 'Gaussian')
    
% (b) Duplicate results from Figure 4.44 (a-f) using Image 4.40a
    % Radii values used: 10, 30, 60, 160, and 460
    radii = [10 30 60 160 460];
    
    [im4_44b] = fft2dFilter(im4_40a, size(im4_40a,1), size(im4_40a,2), 0, 0, radii(1), 0, "Gaussian LP");
    [im4_44c] = fft2dFilter(im4_40a, size(im4_40a,1), size(im4_40a,2), 0, 0, radii(2), 0, "Gaussian LP");
    [im4_44d] = fft2dFilter(im4_40a, size(im4_40a,1), size(im4_40a,2), 0, 0, radii(3), 0, "Gaussian LP");
    [im4_44e] = fft2dFilter(im4_40a, size(im4_40a,1), size(im4_40a,2), 0, 0, radii(4), 0, "Gaussian LP");
    [im4_44f] = fft2dFilter(im4_40a, size(im4_40a,1), size(im4_40a,2), 0, 0, radii(5), 0, "Gaussian LP");
    
    figure(3);
    subplot(2,3,1); imshow(cast(im4_40a, 'uint8')); title(['Do = 0 (Original Image)']);
    subplot(2,3,2); imshow(cast(im4_44b, 'uint8')); title(['Do = ', num2str(radii(1))]);
    subplot(2,3,3); imshow(cast(im4_44c, 'uint8')); title(['Do = ', num2str(radii(2))]);
    subplot(2,3,4); imshow(cast(im4_44d, 'uint8')); title(['Do = ', num2str(radii(3))]);
    subplot(2,3,5); imshow(cast(im4_44e, 'uint8')); title(['Do = ', num2str(radii(4))]);
    subplot(2,3,6); imshow(cast(im4_44f, 'uint8')); title(['Do = ', num2str(radii(5))]);
    
% Problem 4: Highpass Filtering
% (a) Implement the Gaussian highpass filer from Table 4.6
%           H(u,v) = 1 - e^(-1*D(u,v)/2*Do^2)       (Table 4.6(b))

    % See [imageFFT] = fft2dFilter(image, filter = 'Gaussian')
    
% (b) Duplicate results from Figure 4.53 (a-f)
    r = [60 160];
    [im4_53a] = fft2dFilter(im4_40a, size(im4_40a,1), size(im4_40a,2), 0, 0, r(1), 2, "Ideal HP");
    [im4_53b] = fft2dFilter(im4_40a, size(im4_40a,1), size(im4_40a,2), 0, 0, r(1), 2, "Gaussian HP");
    [im4_53c] = fft2dFilter(im4_40a, size(im4_40a,1), size(im4_40a,2), 0, 0, r(1), 2, "Butterworth HP");
    [im4_53d] = fft2dFilter(im4_40a, size(im4_40a,1), size(im4_40a,2), 0, 0, r(2), 2, "Ideal HP");
    [im4_53e] = fft2dFilter(im4_40a, size(im4_40a,1), size(im4_40a,2), 0, 0, r(2), 2, "Gaussian HP");
    [im4_53f] = fft2dFilter(im4_40a, size(im4_40a,1), size(im4_40a,2), 0, 0, r(2), 2, "Butterworth HP");

    figure(4);
    subplot(2,3,1); imshow(cast(im4_53a, 'uint8')); title(['Do = 60 (IHPF)']);
    subplot(2,3,2); imshow(cast(im4_53b, 'uint8')); title(['Do = 60, n =2 (GHPF)']);
    subplot(2,3,3); imshow(cast(im4_53c, 'uint8')); title(['Do = 60 (BHPF)']);
    subplot(2,3,4); imshow(cast(im4_53d, 'uint8')); title(['Do = 160 (IHPF)']);
    subplot(2,3,5); imshow(cast(im4_53e, 'uint8')); title(['Do = 160, n =2 (GHPF)']);
    subplot(2,3,6); imshow(cast(im4_53f, 'uint8')); title(['Do = 160 (BHPF)']);
    
% Problem 5: Highpass Filter Combined with Thresholding
% (a)Using Image 4.55(a), duplicate the results of Fig 4.55
    im4_55a_path = [path, filesep, 'Fig0455(a)(thumb_print).tif'];
    im4_55a = imread(im4_55a_path);
    im4_55a = cast(im4_55a, 'double');
    
    % The text describes use of Do = 50 and Nb = 4
    [im4_55b] = fft2dFilter(im4_55a, size(im4_55a,1), size(im4_55a,2), 0, 0, 50, 4, "Butterworth HP");
    
    % Binary Thresholding (employed in text)
    im4_55c = binaryThreshold(im4_55b);
    im4_55c = scalePixelValues(im4_55c, (max(max(im4_55a))-min(min(im4_55a))));
    
    figure(5);
    subplot(1,3,1); imshow(cast(im4_55a, 'uint8')); title('Original Image');
    subplot(1,3,2); imshow(cast(im4_55b, 'uint8')); title('Highpass Image');
    subplot(1,3,3); imshow(cast(im4_55c, 'uint8')); title('Thresholded Image');
    
end


function [imageFFT] = fft2dFilter(image, M, N, m, n, Do, Nb, filter)
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
    Duv = sqrt( (u-(P+m)).^2 + (v-(Q+n)).^2 );
    if(~isempty(regexp(filter, 'return spectrum')))%filter == "return spectrum")
        imageFFT = imageB;
        return;
    elseif(~isempty(regexp(filter, 'Ideal')))
        H = zeros(size(Duv,1),size(Duv,2));
        for u = 1:size(Duv,1)
            for v = 1:size(Duv,2)
                if Duv(u,v) <= Do
                    H(u,v) = 1;
                else
                    H(u,v) = 0;
                end
            end
        end
        % H = (D(:,:) <= Do) : (@() 1) : (@() 0);
    elseif(~isempty(regexp(filter, 'Gaussian')))
        H = exp(-1.*(Duv.^2)/(2*Do.^2));
    elseif(~isempty(regexp(filter, 'Butterworth')))
        H = 1 ./ (1 + (Duv/Do).^(2*Nb) );
    end
    if( ~isempty(regexp(filter, 'HP')) || ~isempty(regexp(filter, 'High Pass')))
        H = 1-H;
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
    
function [scaledImage] = scalePixelValues(imageProccessed, imageOrigRange)
scaledImage = zeros(size(imageProccessed,1), size(imageProccessed,2));
imageProcRange = max(max(imageProccessed)) - min(min(imageProccessed));

    for i = 1:size(imageProccessed,1)
        for j = 1:size(imageProccessed,2)
            scaledImage(i,j) = imageOrigRange*imageProccessed(i,j)/imageProcRange;
        end
    end
end    
    
function [biImage] = binaryThreshold(image)
 threshold = 0;
    for i = 1:size(image,1)
        for j = 1:size(image,2)
            if image(i,j)>= threshold
                biImage(i,j) = 1;
            else
                biImage(i,j) = 0;
            end
        end
    end
biImage = cast(biImage, 'uint8');
end
    