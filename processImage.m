function [pixelMatrix] = processImage(pathToImage)

    arguments (Input)
        pathToImage string
    end
    
    % arguments (Output)
    % 
    % end

    % Convert to matrix of pixel values
    pixelMatrix = imread(pathToImage);

    % Extract first(hardcoded) channel
    pixelMatrix = pixelMatrix(:,:,1);

    % cast matrix as double
    pixelMatrix = double(pixelMatrix);

    % Order pixel values according to a zigzag algorithm
    pixelMatrix = zigzagOrdering(pixelMatrix);
end