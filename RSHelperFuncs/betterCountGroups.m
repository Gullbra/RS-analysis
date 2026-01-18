
function [rGroup, sGroup, uGroup] = betterCountGroups(...
    originalPixels, ...
    flippedPixels, ...
    maskLength ...
)

    arguments (Input)
        originalPixels double
        flippedPixels double
        maskLength int8
    end

    arguments (Output)
        rGroup 
        sGroup 
        uGroup 
    end

    dValuesOriginal = discriminationFunction(originalPixels, maskLength);
    dValuesFlipped = discriminationFunction(flippedPixels, maskLength);

    rGroup = 0;
    sGroup = 0;
    uGroup = 0;

    [~ , dValuesLength] = size(dValuesOriginal);

    for index = 1:dValuesLength
        if dValuesFlipped(index) > dValuesOriginal(index)
            rGroup = rGroup+1;
        else
            if dValuesFlipped(index) < dValuesOriginal(index)
                sGroup = sGroup+1;
            else
                uGroup = uGroup+1;
            end
        end
    end    
end
