%RS analysis Plot
%author:Gaoshen
%E-mail:matthewgao@gmail.com
%date:2012.3.9
%Modern Information Technology Lab
%East China University of Science and Technology

function computeAndPlot(pathToImage)

    arguments
        pathToImage string
    end

    addpath('./LSBEmbedd')
    addpath('./ImageProcessing')

    tempStego = "./images/tempStego.png";

    [width, height] = size(imread(pathToImage));
    pixelAmount = width * height;
    numIterations = height + 1;
    
    % Preallocate result arrays
    pValues = zeros(1, numIterations);
    
    r_pM = zeros(1, numIterations);
    s_pM = zeros(1, numIterations);

    r_nM = zeros(1, numIterations);
    s_nM = zeros(1, numIterations);

    r_inv_pM = zeros(1, numIterations);
    s_inv_pM = zeros(1, numIterations);

    r_inv_nM = zeros(1, numIterations);
    s_inv_nM = zeros(1, numIterations);

    % Embed data and compute RS values
    fprintf('Embedding and analysing...\n');
    imageIndex=1;
    for pixelIndex=0:width:pixelAmount

        if mod(imageIndex, 50) == 0  % Print every 10 iterations
            fprintf('  Progress: %d/%d (%.1f%%)\n', imageIndex, numIterations, ...
                    100*imageIndex/numIterations);
        end

        bitlsbhide(pathToImage, pixelIndex, tempStego);
        [ ...
            pValues(1,imageIndex), ...
            r_pM(1,imageIndex), ...
            s_pM(1,imageIndex), ...
            r_nM(1,imageIndex), ...
            s_nM(1,imageIndex), ...
            r_inv_pM(1,imageIndex), ...
            s_inv_pM(1,imageIndex), ...
            r_inv_nM(1,imageIndex), ...
            s_inv_nM(1,imageIndex) ...
        ] = RS(tempStego);

        imageIndex=imageIndex+1;
    end
    delete(tempStego);
    fprintf('Analysis complete!\n');
    
    a=[r_nM, fliplr(r_inv_nM)];
    b=[r_pM, fliplr(r_inv_pM)];
    c=[s_pM, fliplr(s_inv_pM)];
    d=[s_nM, fliplr(s_inv_nM)];
    
    fprintf('Generating plots...\n');
    
    fig = figure('Visible', 'off');
    subplot(121);
    
    titleString1 = 'RS Analysis Plot';
    xLabelString1 = 'Embedding Rate';
    yLabelString1 = 'Proportion of Total Groups';
    
    titleString2 = 'Estimation Accuracy';
    xLabelString2 = 'Embedding Rate';
    yLabelString2 = 'Estimated Embedding Rate';
    
    x_axis1 = linspace(0, 1, length(a));
    x_axis2 = linspace(0, 1, length(pValues));
    plot(x_axis1, a); hold on; grid on;
    plot(x_axis1, b);
    plot(x_axis1, c);
    plot(x_axis1, d); hold off;
    
    axis([0 1 0 1]);
    title(titleString1);
    xlabel(xLabelString1);
    ylabel(yLabelString1);
    legend('R_{-M}', 'R_M', 'S_M', 'S_{-M}', 'Location', 'best');
    
    subplot(122);
    plot(x_axis2, pValues);
    axis([0 1 0 1]);
    grid on;
    title(titleString2);
    xlabel(xLabelString2);
    ylabel(yLabelString2);

    savefig(fig, './images/RS_analysis_results.fig');
    exportgraphics(fig, './images/RS_analysis_results.jpg', 'Resolution', 1024);
    close(fig);
end
