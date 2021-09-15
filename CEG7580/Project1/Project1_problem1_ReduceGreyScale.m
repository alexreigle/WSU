% Project 1 - Problem 1 Code
function [success] = Project1_problem1_ReduceGreyScale(imagePath, desiredIntensityLevels)

success = -1;
imageInfo = imfinfo(imagePath);

originalMaxSampleValue = imageInfo.MaxSampleValue + 1; % Plus 1 accounts for intensity = 0
newMaxSampleValue = desiredIntensityLevels;
intensityIncrement = (originalMaxSampleValue/newMaxSampleValue) ;

originalImage = imread(imagePath);
newImage = zeros(size(originalImage,1),size(originalImage,2));

for d1 = 1:size(originalImage,1)
    for d2 = 1:size(originalImage,2)
        for i = 1:(desiredIntensityLevels-1)
            if ( i == 1 && originalImage(d1,d2) <= (i)*intensityIncrement )
                 newImage(d1,d2) = 0;                
            elseif ( originalImage(d1,d2) > (i-1)*intensityIncrement ...
                    && originalImage(d1,d2) <= (i)*intensityIncrement)
                newImage(d1,d2) = (i-1)*intensityIncrement;
            elseif ( originalImage(d1,d2) > (i)*intensityIncrement )
                newImage(d1,d2) = (i+1)*intensityIncrement;
            end
        end
    end
end

success = cast(newImage, 'uint8');

end