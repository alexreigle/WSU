
x = linspace(-1,1, 256);

cameraman = imread('cameraman.tif');
camSignal = im2sig(cameraman);
dct3 = dct(cast(camSignal, 'double'), 'Type',2);
cameraman_noisy = truncateSig(dct3);
cameraman_noisy = idct(cameraman_noisy);
f3 = sig2im(cameraman_noisy, size(cameraman,1), size(cameraman,2));

[rpm, f4] = lp_prm( sparse(cast(f3, 'double')) );

n = 2.5;
alpha = 1.5;

% Test Signal f1
f1 = linspace(-1,1,256);
for i = 1:length(f1)
    if (f1(i) <= 0)
        f1(i) = -1 - f1(i);
    else
        f1(i) = ( 1 - f1(i) )^5;
    end
end

d1 = dct(f1); 
d1( (0.5*length(d1)) : (end) ) = 0;
fG = idct(d1);
smoothBoi = supressGibbs(fG);
fuck = imgaussfilt(fG, 1.75);


g1 = gegenbauerCoef(f1, alpha, 1);
g2 = gegenbauerCoef(f1, alpha, 2);
g3 = gegenbauerCoef(f1, alpha, 3);
g4 = gegenbauerCoef(f1, alpha, 4);
g5 = gegenbauerCoef(f1, alpha, 5);

G = [g1; g2; g3; g4; g5];

gfuck = [];
ffuck = [];

for i = 1:length(g3)
    gfuck(i,:) = g3;
    ffuck(i,:) = f1;
end

[prm, iprm] = lp_prm(sparse(gfuck), sparse(ffuck));

w1 = dct(g1);
w2 = dct(g2);
w3 = dct(g3);
w4 = dct(g4);
w5 = dct(g5);

W = [ w1; w2; w3; w4; w5];

f0 = W.*idct(G);

Wi = pinv(W);

g = Wi.*(f0)';

% Case 1: Multiplied w/out trunc.
case1 = g1.*f1;
dct_c1 = dct(case1);
idct_c1 = idct(dct_c1);
test_case1 = idct_c1./g1;

% Case 2: Multiplied After trunc.
f2 = f1; 
case2 = f2;
dct_c2 = dct(case2); 
dct_c2( (0.5*length(dct_c2)) : (end) ) = 0;
dct_g2 = dct_c2 + dct(g1);
idct_c2 = idct(dct_c2);
test_case2 = idct_c2 - dct(g1);

% Case 4: Add g1*DCT(f1) after trunc.
a = linspace(0,256, 256);
p = polyfit(a, idct_c2, 10);
f = polyval(p,a);

Itest3 = idct(test3);

t3_1 = Itest3;

function [prm,iprm] = lp_prm(A,E)
    if ~issparse(A), error('A must be sparse'); end

    n = size(A,1);

    if nargin==1, E = []; end
    if length(E)>=1
      if ~issparse(E), error('E must be sparse'); end
    else
      E = sparse(n,n);
    end

    prm = symrcm(spones(A)+spones(E));  

    iprm = zeros(size(prm)); 

    for i = 1:n 
      iprm(prm(i)) = i; 
    end 
end


function [gegCoef] = gegenbauerCoef(signal, alpha, n)    
    gegCoef = ones(1, length(signal));
    if( n == 1 )
        gegCoef = 2*alpha.*signal;
    elseif ( n >= 2 )
        for t = 1:length(signal)
            gegCoef(t) = (  ( 2*t - 2 + 2*alpha) *  signal(t) * gegenbauerCoef(signal(t), alpha, n-1)      ...
                           +(-1*t + 2 - 2*alpha) *              gegenbauerCoef(signal(t), alpha, n-2))/t ; 
        end
    end
end

function [s1] = solveGegCoef(signalIn, alpha, n, first, second)
  s1 = ones(1,length(signalIn));
  if( n ==0 )
      s1 = s1*first;
  elseif( n == 1)
      s1 = s1*second;
  elseif ( n >= 2 )
      for t = 3:length(signalIn)
          sig_dot_dot = solveGegCoef(signalIn(t-2),alpha,n-2, first, second);
          sig_dot     = solveGegCoef(signalIn(t-1),alpha,n-1, first, second);
          
          s1(t) = (  ( t*signalIn(t) + (  t - 2 + 2*alpha)*sig_dot_dot )    ...
                   / (                 (2*t - 2 + 2*alpha)*sig_dot     )  );
      end
  end
end


function [s] = supressGibbs(signal)
  
    s = imgaussfilt(signal, 1.5);

end


function [signal, m, n] = im2sig(image)
    m = size(image,1);
    n = size(image,2);
    signal = reshape(image, [1 m*n]);
end

function [sigOut] = truncateSig(sigIn)
    len = length(sigIn);
    sigIn((0.5*len):len) = 0;
    sigOut = sigIn;
end

function [image] = sig2im(signal, m, n)
    image = cast(reshape(signal, [m n]), 'uint8');
end
