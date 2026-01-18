%RS analysis
%author:Gaoshen
%E-mail:matthewgao@gmail.com
%date:2012.3.9
%Modern Information Technology Lab
%East China University of Science and Technology 


function [ ...
    p, ...
    r_pM, ...
    s_pM, ...
    r_nM, ...
    s_nM, ...
    r_inv_pM, ...
    s_inv_pM, ...
    r_inv_nM, ...
    s_inv_nM ...
] = RS(pathToImage)
    % Converted to function in order to expose the results to python
    %
    % Remember to convert the path to str on the python side

    arguments
        pathToImage string
    end

    addpath('./RSHelperFuncs');
    addpath('./ImageProcessing')

    mask=[1 0 1 0 1];
    [~, maskLength] = size(mask);

    pixelMatrixOriginal = processImage(pathToImage);
    pixelMatrixInverted = flippMatrix_p(pixelMatrixOriginal, ones(1, maskLength));

    % original img
    [r,s,u] = betterCountGroups(...
        pixelMatrixOriginal, ...
        flippMatrix_p(pixelMatrixOriginal, mask), ...
        maskLength);
    r_pM = r/(r+s+u);
    s_pM = s/(r+s+u);

    [r,s,u] = betterCountGroups(...
        pixelMatrixOriginal, ...
        flippMatrix_n(pixelMatrixOriginal, mask), ...
        maskLength);
    r_nM = r/(r+s+u);
    s_nM = s/(r+s+u);

    % inverted img
    [r,s,u] = betterCountGroups(...
        pixelMatrixInverted, ...
        flippMatrix_p(pixelMatrixInverted, mask), ...
        maskLength);
    r_inv_pM = r/(r+s+u);
    s_inv_pM = s/(r+s+u);

    [r,s,u] = betterCountGroups(...
        pixelMatrixInverted, ...
        flippMatrix_n(pixelMatrixInverted, mask), ...
        maskLength);
    r_inv_nM = r/(r+s+u);
    s_inv_nM = s/(r+s+u);

    % Result calculation
    d0=r_pM-s_pM;
    d1=r_inv_pM-s_inv_pM;
    dn0=r_nM-s_nM;
    dn1=r_inv_nM-s_inv_nM;

    rootans = roots([ 2*(d0+d1) dn0-dn1-d1-d0*3 d0-dn0 ]);

    if length(rootans) >= 2
        if abs(rootans(1,1))>abs(rootans(2,1))
            finalans=rootans(2,1);
        else
            finalans=rootans(1,1);
        end
        p = finalans/(finalans-0.5);
    elseif isscalar(rootans)
        % Linear case: only one root
        finalans = rootans(1,1);
        p = finalans/(finalans-0.5);
    else
        % No roots (shouldn't happen, but safe fallback)
        p = NaN;
    end
end
