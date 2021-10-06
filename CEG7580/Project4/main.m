% Project 4
% CEG 7850 - Digital Image Processing
% Alex Reigle

function [] = main()
path = pwd;
% 
% % Problem 1: Two-Dimensional Fast Fourier Transform
% % See [imageFFT] = fft2dFilter(image, filter)
% 
% % Problem 2: Fourier Spectrum and Average Value
% % (a) Calculated Center Fourier Spectrum
    im4_40a_path = [pwd, filesep, 'Fig0440(a)(testpattern).tif'];
    im4_40a = imread(im4_40a_path);
    
%     im4_40a_Spectra = fft2dFilter(cast(im4_40a, 'double'), size(im4_40a,1), size(im4_40a,2), 0, 0, 0, "return spectrum");
%     im4_40a_SpectraDB = 20*log10(sqrt(real(im4_40a_Spectra).^2 + imag(im4_40a_Spectra).^2));
%     
% % (b) Display the spectrum
%     figure(2); hold on; title('Image 4.40a Fourier Spectrum');
%     
%     tempImage = ifftshift(im4_40a_SpectraDB);
%     tempImage2 = (tempImage(1:size(im4_40a,1),1:size(im4_40a,2)));
%     centeredImage4_40aSpectra = tempImage2;
%     
%     imshow(cast(abs(im4_40a_SpectraDB), 'uint8'));
%     % imshow(cast(centeredImage4_40aSpectra, 'uint8'));
%     
% % (c) Compute the average value of the spectra from 2(a)
%     avgIm4_40a = mean(mean(im4_40a_SpectraDB));
%     disp(avgIm4_40a);
%     
%     answer = questdlg(['The average value of Image 4.40a is ', num2str(avgIm4_40a)], ...
% 	'Is this the correct answer?', ...
% 	'Correct!','Incorrect.','Incorrect.');
%         % Handle response
%         switch answer
%             case 'Correct!'
%                 msgbox([answer ' Hooray! :)'])
%             case 'Incorrect.'
%                 msgbox([answer ' Oh darn! :('])
%         end
        
% Problem 3: Lowpass Filtering
% (a) Implement the Gaussian lowpass filter:
%     H(u,v) = exp( -D(u,v)^2/(2*Do^2) )       (eqn 4-116)

    % See [imageFFT] = fft2dFilter(image, filter = 'Gaussian')
    
% (b) Duplicate results from Figure 4.41 (a-f) using Image 4.40a
    % Radii values used: 10, 30, 60, 160, and 460
    radii = [10 30 60 160 460];
    
    [im4_41b] = fft2dFilter(im4_40a, size(im4_40a,1), size(im4_40a,2), 0, 0, radii(1), "Gaussian");
    [im4_41c] = fft2dFilter(im4_40a, size(im4_40a,1), size(im4_40a,2), 0, 0, radii(2), "Gaussian");
    [im4_41d] = fft2dFilter(im4_40a, size(im4_40a,1), size(im4_40a,2), 0, 0, radii(3), "Gaussian");
    [im4_41e] = fft2dFilter(im4_40a, size(im4_40a,1), size(im4_40a,2), 0, 0, radii(4), "Gaussian");
    [im4_41f] = fft2dFilter(im4_40a, size(im4_40a,1), size(im4_40a,2), 0, 0, radii(5), "Gaussian");
    
    figure(3); hold on;
    subplot(2,3,1); imshow(cast(im4_40a, 'uint8'));
    subplot(2,3,2); imshow(cast(im4_41b, 'uint8'));
    subplot(2,3,3); imshow(cast(im4_41c, 'uint8'));
    subplot(2,3,4); imshow(cast(im4_41d, 'uint8'));
    subplot(2,3,5); imshow(cast(im4_41e, 'uint8'));
    subplot(2,3,6); imshow(cast(im4_41f, 'uint8'));
end


function [imageFFT] = fft2dFilter(image, M, N, m, n, Do, filter)
% Function fft2dFilter
    %     image  = input image
    %     M      = row size of output image 
    %     N      = column size of output image
    %     m      = filter center row shift      (m = 0 reprents a centered filter) Note: m <= M
    %     n      = filter center column shift   (n = 0 reprents a centered filter) Note: n <= N
    %     filter = filter type
    
    zeroPaddedImage = zeros(2*M,2*N);
    
    [x, y] = meshgrid(1:2*M, 1:2*N);
    
    zeroPaddedImage(1:M,1:N) = zeroPaddedImage(1:M, 1:N) + cast(image, 'double');

% a) Multiply the input image by (-1)^(x+y)
    % imageA = fftshift(zeroPaddedImage);
    imageA = ((-1).^(x+y)).*zeroPaddedImage;

% b) Compute the 2-D Fourier transform
    imageB = fft2(imageA);

% c) Multiply the resulting (complex) array by a real filter function.
    % Check if Centered Spectrum is Desired (i.e. Problem 2a check)
    if(filter == "return spectrum")
        imageFFT = imageB;
        return;
    elseif(filter == "Gaussian")
        [u, v] = meshgrid(1:2*M, 1:2*N);
        Duv = sqrt( (u-m).^2 + (v-n).^2 );
        H = exp(-1.*Duv/(2*Do.^2));
    end
    filteredImage = imageB.*H;
    imageC = (filteredImage);

% d) Compute the inverse 2-D Fourier transform
    imageD = ifft2(imageC);

% e) Multiply the input image by (-1)^(x+y)
    imageE = ((-1).^(x+y)).*imageD;
    
% Finally, pull out the image of original MxN size
    imageFFT =   real(imageE(1:M,1:N));
    
end

function [imageOut] = imShowPrep(imageIn, range)
    tempImage = scalePixelValues(imageIn, range);
    imageOut = cast(20*log10(real(tempImage).^2 + imag(tempImage).^2), 'uint8');
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
    
    
    
    
    
    
    