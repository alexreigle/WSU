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

c1 = gegenbauerCoef(f1);
dct1 = dctCoef(f1);

figure(1); 
subplot(1,3,1); plot(f1);
subplot(1,3,2); plot(c1);
subplot(1,3,3); plot(dct1);

% Test Signal f2
f2 = wnoise(3,nextpow2(N));

c2 = gegenbauerCoef(f2);
dct2 = dctCoef(f2);

figure(2); 
subplot(1,3,1); plot(f2);
subplot(1,3,2); plot(c2);
subplot(1,3,3); plot(dct2);



end


function [dctCoef] = dctCoef(signal)
% According to eqn 6 from the cited article, the DCT function used shall be
% as follows: y = dct(x, 'Type', 2) 

dctCoef = dct(signal, 'Type', 2);

end

function [gegCoef] = gegenbauerCoef(signal)
% Weighting function = (1 - x^2)^(lambda-1/2)
% alpha = lambda = 0;
    alpha = 10;
    gegCoef = zeros(1,length(signal));
    gegCoef(1) = 1;
    gegCoef(2) = 2*alpha*signal(2);
    for i = 3:length(signal)
        n = i-1;
        gegCoef(i) = ( 2*(n+alpha)*signal(i)*gegCoef(i-1)   ...
                        - (n + 2*alpha - 1)*gegCoef(i-2) )  ...
                     /                                      ...
                     (n+1);
    end
end