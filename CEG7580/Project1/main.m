% Project 1 Code
% CEG 7850 - Digital Image Processing
% Alex Reigle

path = pwd;
dripBottlePath = [path, filesep, 'drip-bottle-256.tif'];
dripBottle = imread(dripBottlePath);
figure(99); hold on; title('Original Problem 1 Image');
imshow(dripBottlePath);

% Project 1 problem 1a 
desiredNumberOfIntensityLevels = 2;
problem_1a_image = Project1_problem1_ReduceGreyScale(dripBottlePath, desiredNumberOfIntensityLevels);
figure(1);hold on; title('Problem 1a Image: Two Intensity Levels');
imshow(problem_1a_image);

% Project 1 problem 1b
% Fig. 2.24(a) shows the desired number of intensity levels == [256, 128, 64, 32]
clear desiredNumberOfIntensityLevels;
desiredNumberOfIntensityLevels = [256 128 64 32];
problem_1b_images = {};
problem_1b_images{1} = Project1_problem1_ReduceGreyScale(dripBottlePath, desiredNumberOfIntensityLevels(1));
problem_1b_images{2} = Project1_problem1_ReduceGreyScale(dripBottlePath, desiredNumberOfIntensityLevels(2));
problem_1b_images{3} = Project1_problem1_ReduceGreyScale(dripBottlePath, desiredNumberOfIntensityLevels(3));
problem_1b_images{4} = Project1_problem1_ReduceGreyScale(dripBottlePath, desiredNumberOfIntensityLevels(4));

figure(2); hold on;
title('Problem 1b Images: \n256(a), 128(b), 64(c), 32(d) Intensity Levels');
subplot(2,2,1);
imshow(problem_1b_images{1});
subplot(2,2,2);
imshow(problem_1b_images{2});
subplot(2,2,3); 
imshow(problem_1b_images{3});
subplot(2,2,4);
imshow(problem_1b_images{4});

P1p1_success = 1;


chronometerPath = [path, filesep, 'Chronometer.tif'];
figure(100); hold on;
title('Original Problem 2 Image');
imshow(chronometerPath);
shrinkFactor = 4;
chronometer = imread(chronometerPath);

% Project 1 problem 2a (Pixel Replication Method)
problem2a_image = imresize(chronometer, 1/shrinkFactor);

% Project 1 problem 2b (Pixel Replication Method)
problem2b_image = Project1_problem2_PixelReplication(problem2a_image, shrinkFactor);

figure(3); hold on;
title('Problem 2b: Pixel Replication Zooming');
imshow(problem2b_image);

P1p2_success = 1;
problem2c_startImage = imresize(problem2b_image, [size(problem2a_image,1) size(problem2a_image,2)]);

% Project 1 problem 2c - b (Bilinear Transformation)
problem2c_image = Project1_problem2c_BilinearInterpolation(problem2c_startImage, shrinkFactor);
figure(4); hold on;
title('Problem 2c: Bilinear Transformation Zooming');
imshow(problem2c_image);

p1p2c_success = 1;
