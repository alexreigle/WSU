% Final Project
% CEG 7850 - Digital Image Processing
% Alex Reigle

function [] = main()
% Assumptions:
%   (1) Ns = N = 256 (This ensures that our function will mapp x -> y such 
%       that n = 0 & ni = N-1 for eqn. 3)
%   (2) Assume that the highest order of the signa will be varried between
%       mi = 1 and mi = 3 (providing the definition for the Gegenbauer
%       basis.
%   (3) N = n and k = n; Assume cardinality is the entire signal. This 
%       allows for assumption (1) and also reduces coputational complexity
%       by tying the two values together in a single for-loop (see eqn. 6)
%   (4) 

N = 256;    % N (big n) is the number of sub-intervals/elements in the signal
n = N;      % n (little n) is the cardinality (number of elements/subsets) in the grouping

% Test Signal f1
f1 = linspace(-1,1,N);
for i = 1:length(f1)
    if (f1(i) <= 0)
        f1(i) = -1 - f1(i);
    else
        f1(i) = ( 1 - f1(i) )^5;
    end
end

dct1 = dctCoef(f1);
c1 = gegenbauerCoef(dct1);

% Introduce Artifacts
f1_noisy = dct1; 
f1_noisy(end-128:end) = 0;
figure(11); 
subplot(1,2,1); plot(f1_noisy); title('Compressed (Zeroed-Out) DCT of f1');
subplot(1,2,2); plot(idct(f1_noisy)); title('Reconstruction of Compressed Signal f1');

figure(1);
subplot(1,2,1); plot(f1); title('Orignal Signal (f1)');
subplot(1,2,2); plot(dct1); title('DCT Coefficients of f1');
figure(10); plot(c1); title('Gegenbauer Coefficients of f1');

% Test Signal f2
f2 = wnoise(3,nextpow2(N));
dct2 = dctCoef(f2);
c2 = gegenbauerCoef(dct2);

% Introduce Artifacts
f2_noisy = dct2; 
f2_noisy(end-128:end) = 0;
figure(21); 
subplot(1,2,1); plot(f2_noisy); title('Compressed (Zeroed-Out) DCT of f2');
subplot(1,2,2); plot(idct(f2_noisy)); title('Reconstruction of Compressed Signal f2');

figure(2);
subplot(1,2,1); plot(f2); title('Original Signal (f2)');
subplot(1,2,2); plot(dct2); title('DCT Coefifcients of f2');

figure(20); plot(c2); title('Gegenbauer Coefficients of f2');

cameraman = imread('cameraman.tif');

camSignal = im2sig(cameraman);
figure(31);

dct3 = dctCoef(camSignal);
figure(32); plot(dct3);

cameraman_noisy = truncateSig(dct3);

figure(33); 
f3 = sig2im(cameraman_noisy);
figure(34); 

figure(3);
subplot(2,2,1); imshow(cameraman);
subplot(2,2,2); imshow(f3);
subplot(2,2,3); plot(dct3);
subplot(2,2,4); plot(cameraman_noisy);

end

function [sigOut] = truncateSig(sigIn)
    len = length(sigIn);
    sigIn(end-len:end) = 0;
    sigOut = sigIn;
end

function [signal, m, n] = im2sig(image)
    m = size(image,1);
    n = size(image,2);
    signal = reshape(image, [1 m*n]);
end

function [image] = sig2im(signal, m, n)
    image = cast(reshape(signal, [m n]), 'uint8');
end

function [dctCoef] = dctCoef(signal)
% According to eqn 6 from the cited article, the DCT function used shall be
% as follows: y = dct(x, 'Type', 2) 
signal = cast(signal, 'double');
dctCoef = dct(signal, 'Type', 2);

end

function [gegCoef] = gegenbauerCoef(signal)
% Weighting function = (1 - x^2)^(lambda-1/2)
% alpha = lambda = 0;
    alpha = 0;
    gegCoef = zeros(1,length(signal));
    gegCoef(1) = 1;
    gegCoef(2) = 2*alpha*signal(2);
    for i = 3:length(signal)
        n = i-1;
        gegCoef(i) = ( 2*(n+alpha)*signal(i)*gegCoef(i-1)   ...
                        - (n + 2*alpha - 1)*gegCoef(i-2) )  ...
                     /                                      ...
                     (n+1);
         %gegCoef(i) = gegCoef(i)*gamma(n+2*alpha)/(factorial(n)*gamma(2*alpha));
    end
end