%function [transImage]=nftrans(orgImage,mask)
%function ---F-1 function
%orgImage ---input original image matrix
%mask ---mask
%Author:Gaoshen
%E-mail:matthewgao@gmail.com
%Date:2012.3.9
%Modern Information Technology Lab
%East China University of Science and Technology 


function [flippedPixels] = flippMatrix_n(orgImage,mask)

    [~, noPixels] = size(orgImage);
    [~, maskLength] = size(mask);

    flippedPixels = zeros(1, noPixels);

    positionInGroup = 0;
    for p=1:noPixels
        if positionInGroup == maskLength
            positionInGroup = 0;
        end
        
        if mask(positionInGroup+1) == 1
            if mod(orgImage(1,p),2) == 0
                flippedPixels(1,p) = orgImage(1,p) - mask(positionInGroup+1);
            else
                flippedPixels(1,p) = orgImage(1,p) + mask(positionInGroup+1);
            end
        else
             flippedPixels(1,p) = orgImage(1,p);
        end

        positionInGroup = positionInGroup+1;
    end
end
