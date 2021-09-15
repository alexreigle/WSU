function listOfDistances = EuclidianDistances(refPoint, allPoints)
% allPoints is a Nx2 vector containing row; column of all relavant points
% refPoint is a 1x2 vector containing the row; column of a reference point

listOfDistances = [];

for i = 1:size(allPoints,1)
    d = sqrt( abs(refPoint(1,1)-allPoints(i,1))^2 + abs(refPoint(1,2)-allPoints(i,2))^2 );
    listOfDistances(i,1) = d;
    listOfDistances(i,2) = allPoints(i,1);
    listOfDistances(i,3) = allPoints(i,2);
end

end