%RS analysis
%author:Gaoshen
%E-mail:matthewgao@gmail.com
%date:2012.3.9
%Modern Information Technology Lab
%East China University of Science and Technology 

% clc
% clear


function result = RS(pathToImage)
    % Converted to function to expose results with "MATLAB Engine API for Python"
    %
    % Remember to convert the path to str on the python side

    arguments
        pathToImage string
    end

    % if ~isstring(pathToImage)
    %     % When MATLAB trows an error, the python side receives an
    %     % MatlabExecutionError error
    %     error('pathToImage must be a string');
    % end

    mask=[1 0 1 0 1];
    pixelMatrix = processImage(pathToImage);

    % original img
    [r,s,u] = countGroups_pM(pixelMatrix, mask);
    r_pM = r/(r+s+u);
    s_pM = s/(r+s+u);

    [r,s,u] = countGroups_nM(pixelMatrix, mask);
    r_nM = r/(r+s+u);
    s_nM = s/(r+s+u);

    % inverted img
    [r,s,u] = countGroups_inv_pM(pixelMatrix, mask);
    r_inv_pM = r/(r+s+u);
    s_inv_pM = s/(r+s+u);

    [r,s,u] = countGroups_inv_nM(pixelMatrix, mask);
    r_inv_nM = r/(r+s+u);
    s_inv_nM = s/(r+s+u);

    % Result calculation
    d0=r_pM-s_pM;
    d1=r_inv_pM-s_inv_pM;
    dn0=r_nM-s_nM;
    dn1=r_inv_nM-s_inv_nM;
    
    a=2*(d0+d1);
    b=(dn0-dn1-d1-d0*3);
    c=d0-dn0;

    z=[-1:0.01:2];
    p=[a b c];

    rootans=roots(p);
    if abs(rootans(1,1))>abs(rootans(2,1))
        finalans=rootans(2,1);
    else
        finalans=rootans(1,1);
    end
    p=finalans/(finalans-0.5);

    result = p;
end
