function success = Project1_problem2_PixelReplication(image, shrinkFactor)

success = -1;

origRows = size(image, 1);
origCols = size(image, 2);

rowReplicatedImage = [];
row_offset = 1;
for rowIdx = 1:origRows*shrinkFactor
    rowReplicatedImage(rowIdx, :) = image(row_offset, :);
    
    if( rowIdx~=1 && mod(rowIdx, shrinkFactor)==0 )
       row_offset = row_offset+1; 
    end
end
    
colReplicatedImage = [];
col_offset = 1
for colIdx = 1:origCols*shrinkFactor
    colReplicatedImage(:, colIdx) = rowReplicatedImage(:, col_offset);
    
    if( colIdx~=1 && mod(colIdx, shrinkFactor)==0 )
        col_offset = col_offset+1;
    end
end

success = cast(colReplicatedImage, 'uint8');

end