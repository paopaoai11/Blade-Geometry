%% Information
% File: BladeGeometry.m
% Author: Jered Dominguez-Trujillo
% Date: December 11, 2019
% Location: MIT Gas Turbine Laboratory

%% Function: Blade Geometry
function BladeGeometry(Data, Settings)    
    fprintf('Starting %s\n', Settings.Title);
    
    xUpperData = Data.xUpper;
    yUpperData = Data.yUpper;
    xLowerData = Data.xLower;
    yLowerData = Data.yLower;
    CP_UPPER = Data.cpUpper;
    CP_LOWER = Data.cpLower;
    
    NPOINTS = Settings.N;
    TITLE = Settings.Title;
    
    fig = figure(1);

    Upper = bezier_curv(CP_UPPER, NPOINTS);
    Lower = bezier_curv(CP_LOWER, NPOINTS);
    
    option = uicontrol('Parent', fig, 'Style', 'popupmenu', ...
    'String', {'Upper', 'Lower', 'Complete'}, ...
    'Position', [30 360 100 60], 'callback', ...
    {@option_callback, Settings});

    h = plot(CP_UPPER(:, 1), CP_UPPER(:, 2), 'ko', ...
         CP_LOWER(:, 1), CP_LOWER(:, 2), 'go', ...
         Upper(:, 1), Upper(:, 2), 'r-', ...
         Lower(:, 1), Lower(:, 2), 'r-', ...
         xUpperData, yUpperData, 'b--', ...
         xLowerData, yLowerData, 'b--', ...
         'hittest', 'on', 'buttondownfcn', ...
         {@clickmarker, Settings});
     
    title(TITLE, 'FontSize', 24);
    xlabel('$$\frac{x}{C_{ax}}$$', 'interpreter', 'latex');
    ylabel('$$\frac{H}{C_{ax}}$$', 'interpreter', 'latex');
    xlim([Settings.XLIM(1) Settings.XLIM(2)]); 
    ylim([Settings.YLIM(1) Settings.YLIM(2)]);
    legend([h(1), h(3), h(5)], 'Control Points', 'New Geometry', 'Original Geometry');
    set(h,{'LineWidth'},{2});
end