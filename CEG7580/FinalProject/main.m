% Final Project
% CEG 7850 - Digital Image Processing
% Alex Reigle

function [] = main()
%% Assumptions:
%   (1) Ns = N = 256 (This ensures that our function will mapp x -> y such 
%       that iterator, i, spans i = [0 N-1] for eqn. 3)
%   (2) Assume that the highest order of the signa will be varried between
%       mi = 1 and mi = 3 (providing the definition for the Gegenbauer
%       basis.
%   (3) N = k; Assume cardinality is the entire signal. This 
%       allows for assumption (1) and also reduces coputational complexity
%       by tying the two values together in a single for-loop (see eqn. 6)
%   (4) 

N = 256;    % N (big n) is the number of sub-intervals/elements in the signal
n = 2.5;      % n (little n) is the degree of the Gegenbauer polynomial which is
            %              used to reconstruct the 

% Ref: (mathworld.wolfram)
% lambda defines the demensionality of the problem 
% (2*lambda + 2) defines the number of demensions
% for 1D-space (2*lambda - 2) = 1; lambda = 1.5
% alpha = lambda - 1/5 = 1
alpha = 1.5;

x = linspace(-1,1, 256);
g = gegenbauerCoef(x, alpha, n);

% Test Signal f1
f1 = linspace(-1,1,N);
for i = 1:length(f1)
    if (f1(i) <= 0)
        f1(i) = -1 - f1(i);
    else
        f1(i) = ( 1 - f1(i) )^5;
    end
end

    % Original processing of Signal f1 (without Compression/Truncation)
    dct_f1 = dctCoef(f1);
    idct_f1 = idct(dct_f1);

    figure(1);
    subplot(1,3,1); plot(f1);       title('Orignal Signal F1');
    subplot(1,3,2); plot(dct_f1);   title('DCT of Orig. Sig. F1');
    subplot(1,3,3); plot(idct_f1);  title('IDCT Reconstruction of F1');
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% RECONSTRUCTION OF 1D SIGNALS USING IPRM %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%% RECONSTRUCTION OF F1 USING IPRM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [f1_out, encKey] = encodeSig(f1, alpha, n);
    f1_reconstruct = IPRM(f1_out, alpha, n, encKey);

    figure(11);
    subplot(1,3,1); plot(f1);               title('Original Signal');
    subplot(1,3,2); plot(f1_out);           title('Gegenbauer Compressed Signal');
    subplot(1,3,3); plot(f1_reconstruct);   title('Reconstructed Signal');

    % Original processing of Signal f1 (with Compression/Truncation)
    ft = (f1);
    dct_ft = truncateSig(dctCoef(ft));
    idct_ft = idct(dct_ft);

    figure(12);
    subplot(1,3,1); plot(ft);       title('Signal F1');
    subplot(1,3,2); plot(dct_ft);   title('DCT of Trunc. Sig. Ft');
    subplot(1,3,3); plot(idct_ft);  title('IDCT Reconstruction of Ft');

%% %%%%%%% Incorrect Usage because seeding f1 into the Gegenbauer Poly violates the linear combination condition %%%%%%%%%%%%
%     % Gegenbauer processing of Signal f1 (without Compression/Truncation)
%     gegWorking = gegenbauerCoef(f1, alpha, n);     % Works for alpha = 1.5; n1 = 2.01-2.99
%     dctGegWorking = dctCoef(gegWorking);
%     recreatedF1 = idct(dctGegWorking);
% 
%     figure(13);
%     subplot(1,3,1); plot(gegWorking);       title('Gegenbauer Polynomial of F1');
%     subplot(1,3,2); plot(dctGegWorking);    title('DCT of Gegenbauer Poly. (of F1)');
%     subplot(1,3,3); plot(recreatedF1);      title('Reconstrunction of F1 (w/ Gegenbauer Poly.)');
% 
%     % Gegenbauer processing of Signal f1 (with Compression/Truncation)
%     gegT = (gegenbauerCoef(ft, alpha, n));
%     dctGegT = truncateSig(dctCoef(gegT));
%     recreatedFt = idct(dctGegT);
% 
%     figure(14);
%     subplot(1,3,1); plot(gegT);         title('Gegenbauer Poly. of *Truncated Signal, Ft');
%     subplot(1,3,2); plot(dctGegT);      title('DCT of Gegenbauer Poly. (of Ft)');
%     subplot(1,3,3); plot(recreatedFt);  title('Reconstruction of Ft (w/ Gegenbauer Poly.)');

%% %%%%%%%%%%%% RECREATION OF FIGURE 2A AND 2B %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure(1001);
    subplot(1,2,1); plot(f1);           title('Figure 2a Recreation - Orignal Signal (f1)');    xlim([1 256]);
    subplot(1,2,2); plot(dctCoef(f1));  title('Figure 2b Recreation - DCT Coefficients of f1'); xlim([1 256]);

    rmsef1 = 0.*f1;
    for i = 1:length(f1)
        rmsef1(i) = rootMeanSquareError(f1(i), f1_reconstruct(i));
    end

    figure(1002);   plot(rmsef1);     title('Recreation of Figure 3a - RMSE of Reconstructed F1');


    % Introduce Artifacts
    f1_noisy = truncateSig(dctCoef(f1));
    figure(11); 
    subplot(1,2,1); plot(f1_noisy);       title('Compressed (Zeroed-Out) DCT of f1');
    subplot(1,2,2); plot(idct(f1_noisy)); title('Reconstruction of Compressed Signal f1');

    % Test Signal f2
    f2 = wnoise(3,nextpow2(N));
    dct2 = dctCoef(f2);

    % Introduce Artifacts
    f2_noisy = truncateSig(dct2); 
    
    figure(22); 
    subplot(1,2,1); plot(f2_noisy);         title('Compressed (Zeroed-Out) DCT of f2');
    subplot(1,2,2); plot(idct(f2_noisy));   title('Reconstruction of Compressed Signal f2');

%% %%%%%% RECONSTRUCTION OF F2 USING IPRM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [f2_out, encKey] = encodeSig(f2, alpha, n);
    f2_reconstruct = IPRM(f2_out, alpha, n, encKey);

    figure(20);
    subplot(1,3,1); plot(f2);               title('Original Signal');
    subplot(1,3,2); plot(f2_out);           title('Gegenbauer Compressed Signal');
    subplot(1,3,3); plot(f2_reconstruct);   title('Reconstructed Signal');

    figure(2001);
    subplot(1,2,1); plot(f2);   title('Figure 4a Recreation - Original Signal (f2)');   xlim([1 256]);
    subplot(1,2,2); plot(dct2); title('Figure 4b Recreation - DCT Coefifcients of f2'); xlim([1 256]);

    rmsef2 = 0.*f2;
    for i = 1:length(f2)
        rmsef2(i) = rootMeanSquareError(f2(i), f2_reconstruct(i));
    end

    figure(2002); plot(rmsef2); title('Recreation of Figure 5a - RMSE of Reconstructed F2');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% RECONSTRUCTION OF IMAGES USING IPRM %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Processing on Cameraman Image
    cameraman = imread('cameraman.tif');
    [camSignal, Cm, Cn] = im2sig(cameraman);
    dct3 = dctCoef(camSignal);
    cameraman_noisy = truncateSig(dct3);
    f3 = sig2im(cameraman_noisy, Cm, Cn);

    figure(3); hold on;
    subplot(2,2,1); imshow(cameraman);                          title('Original Image'); 
    subplot(2,2,2); imshow(f3);                                 title('Gegenbauer Compressed Image'); 
    subplot(2,2,3); plot(dct3);             xlim([1 Cm*Cn]);    title('DCT Transform of Original Image'); 
    subplot(2,2,4); plot(cameraman_noisy);  xlim([1 Cm*Cn]);    title('DCT Transform of Gegenbauer Compressed Signal)'); 

    [cam_out, encKey] = encodeSig(camSignal, alpha, n);
    cam_reconstruct = IPRM(cam_out, alpha, n, encKey);

    figure(30); hold on;
    subplot(2,3,1); plot(camSignal);                                        title('Original "Cameraman.tif" Signal');
    subplot(2,3,2); plot(cam_out);                                          title('Gegenbauer Compressed Signal');
    subplot(2,3,3); plot(cam_reconstruct);                                  title('Reconstructed Signal');
    subplot(2,3,4); imshow(cameraman);                                      title('Original Image');
    subplot(2,3,5); imshow(cast(sig2im(idct(cam_out),Cm,Cn), 'uint8'));     title('Compressed Noisy Image');
    subplot(2,3,6); imshow(cast(sig2im(cam_reconstruct,Cm,Cn), 'uint8'));   title('Reconstructed Image');
    
    % Add noise from transmition (After Compression)
    cam_out_noisy3  = addNoise(cam_out, 3);     cam_out_noisy3_reconstruct   = IPRM(cam_out_noisy3 , alpha, n, encKey);
    cam_out_noisy10 = addNoise(cam_out, 10);    cam_out_noisy10_reconstruct  = IPRM(cam_out_noisy10, alpha, n, encKey);
    cam_out_noisyn10 = addNoise(cam_out, -10);  cam_out_noisyn10_reconstruct = IPRM(cam_out_noisyn10, alpha, n, encKey);
    
    figure(31);
    subplot(2,3,1); imshow(cast(sig2im(idct(cam_out_noisy3 ),Cm,Cn), 'uint8'));         title('Compressed Image w/ 3dB SNR after Noise Injection');
    subplot(2,3,2); imshow(cast(sig2im(idct(cam_out_noisy10),Cm,Cn), 'uint8'));         title('Compressed Image w/ 10dB SNR after Noise Injection');
    subplot(2,3,3); imshow(cast(sig2im(idct(cam_out_noisyn10),Cm,Cn), 'uint8'));        title('Compressed Image w/ -10dB SNR after Noise Injection');
    subplot(2,3,4); imshow(cast(sig2im(cam_out_noisy3_reconstruct ,Cm,Cn), 'uint8'));   title('Reconstructed Image w/ 3dB SNR after Noise Injection');
    subplot(2,3,5); imshow(cast(sig2im(cam_out_noisy10_reconstruct,Cm,Cn), 'uint8'));   title('Reconstructed Image w/ 10dB SNR after Noise Injection');
    subplot(2,3,6); imshow(cast(sig2im(cam_out_noisyn10_reconstruct,Cm,Cn), 'uint8'));  title('Reconstructed Image w/ -10dB SNR after Noise Injection');

    rmseCam = 0.*camSignal;
    rmseCam_Noise = rmseCam;
    for i = 1:length(camSignal)
        rmseCam(i) = rootMeanSquareError(camSignal(i), cam_reconstruct(i));
        rmseCam_Noise(i) = rootMeanSquareError(cam_reconstruct(i), cam_out_noisyn10_reconstruct(i));
    end
    
    figure(32);
    subplot(1,2,1); plot(rmseCam);       title('RMSE of Cameraman Image Reconstructed');
    subplot(1,2,2); plot(rmseCam_Noise); title('RMSE of Cameraman Image Reconstructed in Noise');

        cam_Spectra = fourierSpectra(cameraman, size(cameraman,1), size(cameraman,2));

    figure(33); imshow(cast(cam_Spectra, 'uint8'));

    % Processing on Cell Image
    cell = imread('cell.tif');
    [cellSig, c2m, c2n] = im2sig(cell);
    dct4 = dctCoef(cellSig);
    cell_noisy = truncateSig(dct4);
    f4 = sig2im(cell_noisy, c2m, c2n);

    figure(4);
    subplot(2,2,1); imshow(cell);     title('Original Image'); 
    subplot(2,2,2); imshow(f4);       title('Gegenbauer Compressed Image'); 
    subplot(2,2,3); plot(dct4);       title('DCT Transform of Original Image'); 
    subplot(2,2,4); plot(cell_noisy); title('DCT Transform of Gegenbauer Compressed Signal)');

    [cell_out, encKey] = encodeSig(cellSig, alpha, n);
    cell_reconstruct = IPRM(cell_out, alpha, n, encKey);

    figure(40);
    subplot(2,3,1); plot(cellSig);                                              title('Original Signal');
    subplot(2,3,2); plot(cell_out);                                             title('Gegenbauer Compressed Signal');
    subplot(2,3,3); plot(cell_reconstruct);                                     title('Reconstructed Signal');
    subplot(2,3,4); imshow(cell);                                               title('Original "Cell.tif" Image');
    subplot(2,3,5); imshow(cast(sig2im(idct(cell_out),c2m,c2n), 'uint8'));      title('Compressed Noisy Image');
    subplot(2,3,6); imshow(cast(sig2im(cell_reconstruct,c2m,c2n), 'uint8'));    title('Reconstructed Image');

    % Add noise from transmition (After Compression)
    cell_out_noisy3  = addNoise(cell_out, 3);    cell_out_noisy3_reconstruct   = IPRM(cell_out_noisy3 , alpha, n, encKey);
    cell_out_noisy10 = addNoise(cell_out, 10);   cell_out_noisy10_reconstruct  = IPRM(cell_out_noisy10, alpha, n, encKey);
    cell_out_noisyn10 = addNoise(cell_out, -10); cell_out_noisyn10_reconstruct = IPRM(cell_out_noisyn10, alpha, n, encKey);
    
    figure(41);
    subplot(2,3,1); imshow(cast(sig2im(idct(cell_out_noisy3 ),c2m,c2n), 'uint8'));          title('Compressed Image w/ 3dB SNR after Noise Injection');
    subplot(2,3,2); imshow(cast(sig2im(idct(cell_out_noisy10),c2m,c2n), 'uint8'));          title('Compressed Image w/ 10dB SNR after Noise Injection');
    subplot(2,3,3); imshow(cast(sig2im(idct(cell_out_noisyn10),c2m,c2n), 'uint8'));         title('Compressed Image w/ -10dB SNR after Noise Injection');
    subplot(2,3,4); imshow(cast(sig2im(cell_out_noisy3_reconstruct ,c2m,c2n), 'uint8'));    title('Reconstructed Image w/ 3dB SNR after Noise Injection');
    subplot(2,3,5); imshow(cast(sig2im(cell_out_noisy10_reconstruct,c2m,c2n), 'uint8'));    title('Reconstructed Image w/ 10dB SNR after Noise Injection');
    subplot(2,3,6); imshow(cast(sig2im(cell_out_noisyn10_reconstruct,c2m,c2n), 'uint8'));   title('Reconstructed Image w/ -10dB SNR after Noise Injection');

    rmseCell = 0.*cellSig;
    rmseCell_Noise = rmseCell;
    for i = 1:length(cellSig)
        rmseCell(i) = rootMeanSquareError(cellSig(i), cell_reconstruct(i));
        rmseCell_Noise(i) = rootMeanSquareError(cell_reconstruct(i), cell_out_noisyn10_reconstruct(i));
    end
    
    figure(42);
    subplot(1,2,1); plot(rmseCell);       title('RMSE of Cell Image Reconstructed');
    subplot(1,2,2); plot(rmseCell_Noise); title('RMSE of Cell Image Reconstructed in Noise');

% Processing on Mandi Image
    mandi = imread('mandi.tif');
    [mandiSig, Mm, Mn] = im2sig(mandi);
    dct5 = dctCoef(mandiSig);
    mandi_noisy = truncateSig(dct5);
    f5 = sig2im(mandi_noisy, Mm, Mn);

    figure(5);
    subplot(2,2,1); imshow(mandi);          title('Original Image'); 
    subplot(2,2,2); imshow(f5);             title('Gegenbauer Compressed Image'); 
    subplot(2,2,3); plot(dct5);             title('DCT Transform of Original Image'); 
    subplot(2,2,4); plot(mandi_noisy);      title('DCT Transform of Gegenbauer Compressed Signal)');

    [mandi_out, encKey] = encodeSig(mandiSig, alpha, n);
    mandi_reconstruct = IPRM(mandi_out, alpha, n, encKey);

    figure(50);
    subplot(2,3,1); plot(mandiSig);                                         title('Original Signal');
    subplot(2,3,2); plot(mandi_out);                                        title('Gegenbauer Compressed Signal');
    subplot(2,3,3); plot(mandi_reconstruct);                                title('Reconstructed Signal');
    subplot(2,3,4); imshow(mandi);                                          title('Original "Mandi.tif" Image');
    subplot(2,3,5); imshow(cast(sig2im(idct(mandi_out),Mm,Mn), 'uint8'));   title('Compressed Noisy Image');
    subplot(2,3,6); imshow(cast(sig2im(mandi_reconstruct,Mm,Mn), 'uint8')); title('Reconstructed Image');

    % Add noise from transmition (After Compression)
    mandi_out_noisy3  = addNoise(mandi_out, 3);    mandi_out_noisy3_reconstruct   = IPRM(mandi_out_noisy3 , alpha, n, encKey);
    mandi_out_noisy10 = addNoise(mandi_out, 10);   mandi_out_noisy10_reconstruct  = IPRM(mandi_out_noisy10, alpha, n, encKey);
    mandi_out_noisyn10 = addNoise(mandi_out, -10); mandi_out_noisyn10_reconstruct = IPRM(mandi_out_noisyn10, alpha, n, encKey);
    
    figure(51);
    subplot(2,3,1); imshow(cast(sig2im(idct(mandi_out_noisy3 ),Mm,Mn), 'uint8'));          title('Compressed Image w/ 3dB SNR after Noise Injection');
    subplot(2,3,2); imshow(cast(sig2im(idct(mandi_out_noisy10),Mm,Mn), 'uint8'));          title('Compressed Image w/ 10dB SNR after Noise Injection');
    subplot(2,3,3); imshow(cast(sig2im(idct(mandi_out_noisyn10),Mm,Mn), 'uint8'));         title('Compressed Image w/ -10dB SNR after Noise Injection');
    subplot(2,3,4); imshow(cast(sig2im(mandi_out_noisy3_reconstruct ,Mm,Mn), 'uint8'));    title('Reconstructed Image w/ 3dB SNR after Noise Injection');
    subplot(2,3,5); imshow(cast(sig2im(mandi_out_noisy10_reconstruct,Mm,Mn), 'uint8'));    title('Reconstructed Image w/ 10dB SNR after Noise Injection');
    subplot(2,3,6); imshow(cast(sig2im(mandi_out_noisyn10_reconstruct,Mm,Mn), 'uint8'));   title('Reconstructed Image w/ -10dB SNR after Noise Injection');


    rmseMandi = 0.*mandiSig;
    rmseMandi_Noise = rmseMandi;
    for i = 1:length(mandiSig)
        rmseMandi(i) = rootMeanSquareError(mandiSig(i), mandi_reconstruct(i));
        rmseMandi_Noise(i) = rootMeanSquareError(mandi_reconstruct(i), mandi_out_noisyn10_reconstruct(i));
    end
    
    figure(52);
    subplot(1,2,1); plot(rmseMandi);       title('RMSE of Mandi Image Reconstructed');
    subplot(1,2,2); plot(rmseMandi_Noise); title('RMSE of Mandi Image Reconstructed in Noise');

    mandi_Spectra = fourierSpectra(mandi, size(mandi,1), size(mandi,2));

    figure(53); imshow(cast(mandi_Spectra, 'uint8'));

% Processing on Moon Image
    moon = imread('moon.tif');
    [moonSig, M2m, M2n] = im2sig(moon);
    dct6 = dctCoef(moonSig);
    moon_noisy = truncateSig(dct6);
    f6 = sig2im(moon_noisy, M2m, M2n);

    figure(6);
    subplot(2,2,1); imshow(moon);           title('Original Image'); 
    subplot(2,2,2); imshow(f6);             title('Gegenbauer Compressed Image'); 
    subplot(2,2,3); plot(dct6);             title('DCT Transform of Original Image'); 
    subplot(2,2,4); plot(moon_noisy);       title('DCT Transform of Gegenbauer Compressed Signal)');

    [moon_out, encKey] = encodeSig(moonSig, alpha, n);
    moon_reconstruct = IPRM(moon_out, alpha, n, encKey);

    figure(60);
    subplot(2,3,1); plot(moonSig);                                           title('Original Signal');
    subplot(2,3,2); plot(moon_out);                                          title('Gegenbauer Compressed Signal');
    subplot(2,3,3); plot(moon_reconstruct);                                  title('Reconstructed Signal');
    subplot(2,3,4); imshow(moon);                                            title('Original "Moon.tif" Image');
    subplot(2,3,5); imshow(cast(sig2im(idct(moon_out),M2m,M2n), 'uint8'));   title('Compressed Noisy Image');
    subplot(2,3,6); imshow(cast(sig2im(moon_reconstruct,M2m,M2n), 'uint8')); title('Reconstructed Image');

    % Add noise from transmition (After Compression)
    moon_out_noisy3  = addNoise(moon_out, 3);    moon_out_noisy3_reconstruct   = IPRM(moon_out_noisy3 , alpha, n, encKey);
    moon_out_noisy10 = addNoise(moon_out, 10);   moon_out_noisy10_reconstruct  = IPRM(moon_out_noisy10, alpha, n, encKey);
    moon_out_noisyn10 = addNoise(moon_out, -10); moon_out_noisyn10_reconstruct = IPRM(moon_out_noisyn10, alpha, n, encKey);
    
    figure(61);
    subplot(2,3,1); imshow(cast(sig2im(idct(moon_out_noisy3 ),M2m,M2n), 'uint8'));          title('Compressed Image w/ 3dB SNR after Noise Injection');
    subplot(2,3,2); imshow(cast(sig2im(idct(moon_out_noisy10),M2m,M2n), 'uint8'));          title('Compressed Image w/ 10dB SNR after Noise Injection');
    subplot(2,3,3); imshow(cast(sig2im(idct(moon_out_noisyn10),M2m,M2n), 'uint8'));         title('Compressed Image w/ -10dB SNR after Noise Injection');
    subplot(2,3,4); imshow(cast(sig2im(moon_out_noisy3_reconstruct ,M2m,M2n), 'uint8'));    title('Reconstructed Image w/ 3dB SNR after Noise Injection');
    subplot(2,3,5); imshow(cast(sig2im(moon_out_noisy10_reconstruct,M2m,M2n), 'uint8'));    title('Reconstructed Image w/ 10dB SNR after Noise Injection');
    subplot(2,3,6); imshow(cast(sig2im(moon_out_noisyn10_reconstruct,M2m,M2n), 'uint8'));   title('Reconstructed Image w/ -10dB SNR after Noise Injection');

    rmseMoon = 0.*moonSig;
    rmseMoon_Noise = rmseMoon;
    for i = 1:length(moonSig)
        rmseMoon(i) = rootMeanSquareError(moonSig(i), moon_reconstruct(i));
        rmseMoon_Noise(i) = rootMeanSquareError(moon_reconstruct(i), moon_out_noisyn10_reconstruct(i));
    end
    
    figure(62);
    subplot(1,2,1); plot(rmseMoon);       title('RMSE of Moon Image Reconstructed');
    subplot(1,2,2); plot(rmseMoon_Noise); title('RMSE of Moon Image Reconstructed in Noise');

% Processing on Pout Image
    pout = imread('pout.tif');
    [poutSig, Pm, Pn] = im2sig(pout);
    dct7 = dctCoef(poutSig);
    pout_noisy = truncateSig(dct7);
    f7 = sig2im(pout_noisy, Pm, Pn);

    figure(7);
    subplot(2,2,1); imshow(pout);        title('Original Image'); 
    subplot(2,2,2); imshow(f7);          title('Gegenbauer Compressed Image'); 
    subplot(2,2,3); plot(dct7);          title('DCT Transform of Original Image'); 
    subplot(2,2,4); plot(pout_noisy);    title('DCT Transform of Gegenbauer Compressed Signal)');

    [pout_out, encKey] = encodeSig(poutSig, alpha, n);
    pout_reconstruct = IPRM(pout_out, alpha, n, encKey);

    figure(70);
    subplot(2,3,1); plot(poutSig);                                         title('Original Signal');
    subplot(2,3,2); plot(pout_out);                                        title('Gegenbauer Compressed Signal');
    subplot(2,3,3); plot(pout_reconstruct);                                title('Reconstructed Signal');
    subplot(2,3,4); imshow(pout);                                          title('Original "Pout.tif" Image');
    subplot(2,3,5); imshow(cast(sig2im(idct(pout_out),Pm,Pn), 'uint8'));   title('Compressed Noisy Image');
    subplot(2,3,6); imshow(cast(sig2im(pout_reconstruct,Pm,Pn), 'uint8')); title('Reconstructed Image');
    
    % Add noise from transmition (After Compression)
    pout_out_noisy3  = addNoise(pout_out, 3);    pout_out_noisy3_reconstruct   = IPRM(pout_out_noisy3 , alpha, n, encKey);
    pout_out_noisy10 = addNoise(pout_out, 10);   pout_out_noisy10_reconstruct  = IPRM(pout_out_noisy10, alpha, n, encKey);
    pout_out_noisyn10 = addNoise(pout_out, -10); pout_out_noisyn10_reconstruct = IPRM(pout_out_noisyn10, alpha, n, encKey);
    
    figure(71);
    subplot(2,3,1); imshow(cast(sig2im(idct(pout_out_noisy3 ),Pm,Pn), 'uint8'));          title('Compressed Image w/ 3dB SNR after Noise Injection');
    subplot(2,3,2); imshow(cast(sig2im(idct(pout_out_noisy10),Pm,Pn), 'uint8'));          title('Compressed Image w/ 10dB SNR after Noise Injection');
    subplot(2,3,3); imshow(cast(sig2im(idct(pout_out_noisyn10),Pm,Pn), 'uint8'));         title('Compressed Image w/ -10dB SNR after Noise Injection');
    subplot(2,3,4); imshow(cast(sig2im(pout_out_noisy3_reconstruct ,Pm,Pn), 'uint8'));    title('Reconstructed Image w/ 3dB SNR after Noise Injection');
    subplot(2,3,5); imshow(cast(sig2im(pout_out_noisy10_reconstruct,Pm,Pn), 'uint8'));    title('Reconstructed Image w/ 10dB SNR after Noise Injection');
    subplot(2,3,6); imshow(cast(sig2im(pout_out_noisyn10_reconstruct,Pm,Pn), 'uint8'));   title('Reconstructed Image w/ -10dB SNR after Noise Injection');

    rmsePout = 0.*poutSig;
    rmsePout_Noise = rmseMoon;
    for i = 1:length(poutSig)
        rmsePout(i) = rootMeanSquareError(poutSig(i), pout_reconstruct(i));
        rmsePout_Noise(i) = rootMeanSquareError(pout_reconstruct(i), pout_out_noisyn10_reconstruct(i));
    end
    
    figure(72);
    subplot(1,2,1); plot(rmsePout);       title('RMSE of Pout Image Reconstructed');
    subplot(1,2,2); plot(rmsePout_Noise); title('RMSE of Pout Image Reconstructed in Noise');
    
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

function [sigOut] = IPRM(sigIn, alpha, n, dS)
    x = linspace(-1,1, length(sigIn));
    g = gegenbauerCoef(x, alpha, n);
    
    sigSpatial = idct(sigIn) - g;
    sigOut = sigSpatial -dS;
end

function [sigOut, dS] = encodeSig(sigIn, alpha, n)
    x = linspace(-1,1, length(sigIn));
    g = gegenbauerCoef(x, alpha, n);
    
    sigFreq = dctCoef(sigIn);
    truncSig = truncateSig(sigFreq);
    matchFilterSig = idct(truncSig);
    
    sigOut = truncSig + dctCoef(g);
    dS = matchFilterSig - sigIn;
    
end

function [sigOut] = truncateSig(sigIn)
    len = length(sigIn);
    sigIn((0.5*len):len) = 0;
    sigOut = sigIn;
end

function [signal, m, n] = im2sig(image)
    m = size(image,1);
    n = size(image,2);
    signal = reshape(image, [1 m*n]);
    signal = cast(signal, 'double');
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

function [s1] = solveGegCoef(signalIn, alpha, n)
  s1 = zeros(1,length(signalIn));
  if( n == 1)
      s1 = signalIn/(2*alpha);
  elseif ( n >= 2 )
      for t = 3:length(signalIn)
          s1(t) = (  ( t*signalIn(t) + (  t - 2 + 2*alpha)*solveGegCoef(signalIn(t-2),alpha,n-2) )    ...
                   / (                 (2*t - 2 + 2*alpha)*solveGegCoef(signalIn(t-1),alpha,n-1) )  );
      end
  end
end

function [out] = addNoise(in, snr)
    out = awgn(in,snr);
end

function [imageFFT] = fourierSpectra(image, M, N)
    P = 2^nextpow2(M);
    Q = 2^nextpow2(N);
    
    if(P>Q)
        Q = P;
    elseif(Q>P)
        P = Q;
    end

    zeroPaddedImage = zeros(2*P,2*Q);
    imageFFT = 20*log10(sqrt(real(fft2(fftshift(image))).^2 + imag(fft2(fftshift(image))).^2));
end
    
