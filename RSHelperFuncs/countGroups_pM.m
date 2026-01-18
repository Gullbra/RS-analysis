%function [r,s,u]=compare(input,mask)
%function ---calculate R S U group using F1 function
%input ---input file
%mask ---mask
%Author:Gaoshen
%E-mail:matthewgao@gmail.com
%Date:2012.3.9
%Modern Information Technology Lab
%East China University of Science and Technology 

function [rGroup, sGroup, uGroup] = countGroups_pM(pixelMatrix, mask)


    % Create flipped pixels according to mask
    flippedMatrix = flippMatrix_p(pixelMatrix, mask);

    % Calculate discrimination values for the groups (intervals of length of the mask)
    [~ , mask_col_length] = size(mask);
    dValuesOriginal = discriminationFunction(flippedMatrix, mask_col_length);
    dValuesFlipped = discriminationFunction(pixelMatrix, mask_col_length);

    % Count groups
    rGroup=0;
    sGroup=0;
    uGroup=0;

    [~ , dValuesLength]=size(dValuesOriginal);
    for index = 1:dValuesLength
        if dValuesOriginal(index) > dValuesFlipped(index)
            rGroup = rGroup+1;
        else
            if dValuesOriginal(index) < dValuesFlipped(index)
                sGroup = sGroup+1;
            else
                uGroup = uGroup+1;
            end
        end
    end

        