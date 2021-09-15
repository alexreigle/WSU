function success = Project1_problem2c_BilinearInterpolation(image, scaleFactor)

success = -1;

origRows = size(image, 1);
origCols = size(image, 2);

desiredRows = origRows*scaleFactor;
desiredCols = origCols*scaleFactor;

newImage = imresize(image, [desiredRows desiredCols]);

newImage = interp2( cast(newImage, 'double') );
newerImage = imresize(newImage, [desiredRows desiredCols]);

success = cast(newerImage, 'uint8');