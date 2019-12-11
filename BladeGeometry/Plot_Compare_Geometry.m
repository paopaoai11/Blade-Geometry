%% Information
% File: Plot_Compare_Geometry.m
% Author: Jered Dominguez-Trujillo
% Date: December 11, 2019
% Location: MIT Gas Turbine Laboratory

%% Function Plot_Compare_Geometry
function Plot_Compare_Geometry(Settings, Row, Sec, OUT_XUP, OUT_XLOW, OUT_YUP, OUT_YLOW, IN_XUP, IN_XLOW, IN_YUP, IN_YLOW)    
    close all;
    
    figCompare = figure(1);
    figure('units','normalized','outerposition',[0 0 1 1]);
    TITLE = sprintf('./Output/Figures/STAGENINOUT/%s_Section_%.0f_STAGENINOUT.png', Row, Sec);
    plot(IN_XUP, IN_YUP, 'r', 'HandleVisibility', 'Off', 'LineWidth', 2) ;
    hold on;
    plot(IN_XLOW, IN_YLOW, 'r', 'DisplayName', 'Stagen Input', 'LineWidth', 2);
    
    plot(OUT_XUP, OUT_YUP, 'k', 'HandleVisibility', 'Off', 'LineWidth', 2);
    plot(OUT_XLOW, OUT_YLOW, 'k', 'DisplayName', 'Stagen Output', 'LineWidth', 2);
    
    title(sprintf('%s Section %.0f', Row, Sec));
    xlabel('$$\frac{x}{C_{ax}}$$', 'interpreter', 'latex');
    ylabel('$$\frac{H}{C_{ax}}$$', 'interpreter', 'latex');
    xlim([Settings.XLIM(1) Settings.XLIM(2)]); 
    ylim([Settings.YLIM(1) Settings.YLIM(2)]);
    
    daspect([1 1 1]);
    legend('show');
    saveas(gcf, TITLE);
    pause;
    hold off;
    close all;
end