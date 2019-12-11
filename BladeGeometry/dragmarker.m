%% Information
% File: dragmarker.m
% Author: Jered Dominguez-Trujillo
% Date: December 11, 2019
% Location: MIT Gas Turbine Laboratory

%% Function dragmarker
function dragmarker(fig, ~, ~, Settings)

    NPOINTS = Settings.N;
    TITLE = Settings.Title;
    
    %get current axes and coords
    h1 = gca;
    coords = get(h1, 'currentpoint');

    option = fig.Children(1).Value;
    
    %get all x and y data 
    x = {h1.Children.XData};
    y = {h1.Children.YData};
    
    x_LowerData = x{1}; y_LowerData = y{1};
    x_UpperData = x{2}; y_UpperData = y{2};
    
    x_CPLOWER = x{5}; y_CPLOWER = y{5};
    x_CPUPPER = x{6}; y_CPUPPER = y{6};
    
    if option ~= 3

        if option == 1
            CPX = x_CPUPPER;
            CPY = y_CPUPPER;
        else
            CPX = x_CPLOWER;
            CPY = y_CPLOWER;
        end
        
        x_diff = abs(CPX - coords(1, 1, 1));
        y_diff = abs(CPY - coords(1, 2, 1));

        [~, index] = min(x_diff + y_diff);

        if index ~= 1 && index ~= length(x_CPUPPER)
            CPX(index) = coords(1, 1, 1);
            CPY(index) = coords(1, 2, 1);
        else
            %CPX(index) = coords(1, 1, 1);
            CPY(index) = coords(1, 2, 1);
            %x_CPUPPER(index) = coords(1, 1, 1);
            %x_CPLOWER(index) = coords(1, 1, 1);
            y_CPUPPER(index) = coords(1, 2, 1);
            y_CPLOWER(index) = coords(1, 2, 1);
        end

        if option == 1
            x_CPUPPER = CPX;
            y_CPUPPER = CPY;
        else
            x_CPLOWER = CPX;
            y_CPLOWER = CPY;
        end
        
        Upper = bezier_curv([x_CPUPPER; y_CPUPPER].', NPOINTS);
        Lower = bezier_curv([x_CPLOWER; y_CPLOWER].', NPOINTS);

        for kk = 1:length(Upper) - 1
            yFixed = interp1q(Upper(:, 1), Upper(:, 2), x_UpperData.');
            yFixed(1) = 0;
            errUpper = trapz(x_UpperData, abs(y_UpperData - yFixed.'));
        end
        
        for kk = 1:length(Lower) - 1
            yFixed = interp1q(Lower(:, 1), Lower(:, 2), x_LowerData.');
            yFixed(1) = 0;
            errLower = trapz(x_LowerData, abs(y_LowerData - yFixed.'));
        end
        
        h = plot(x_CPUPPER, y_CPUPPER, 'ko', ...
             x_CPLOWER, y_CPLOWER, 'go', ...
             Upper(:, 1), Upper(:, 2), 'r-', ...
             Lower(:, 1), Lower(:, 2), 'r-', ...
             x_UpperData, y_UpperData, 'b--', ...
             x_LowerData, y_LowerData, 'b--', ...
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
end