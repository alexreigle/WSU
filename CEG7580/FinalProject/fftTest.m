mandi = imread('mandi.tif');
mandi_Spectra = fft2dFilter(cast(mandi, 'double'), size(mandi,1), size(mandi,2), 0, 0, 0, 0, "return spectrum");

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
        imageFFT = 20*log10(sqrt(real(imageB).^2 + imag(imageB).^2));
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
