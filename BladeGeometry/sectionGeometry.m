%% Information
% File: sectionGeometry.m
% Author: Jered Dominguez-Trujillo
% Date: December 11, 2019
% Location: MIT Gas Turbine Laboratory

%% Function sectionGeometry
function [XUPPER, XLOWER, YUPPER, YLOWER] = sectionGeometry(SEC, PLOT, J, J_LE, J_TE, XSTART, AX)
        TEMP = PLOT((SEC - 1) * J + 1:SEC * J, :);
        
        XUPPER = (TEMP(J_LE:J_TE, 2) - XSTART) ./ AX;
        XLOWER = (TEMP(J_LE:J_TE, 2) - XSTART) ./ AX;
        
        YUPPER = TEMP(J_LE:J_TE, 3) ./ AX;
        YLOWER = (TEMP(J_LE:J_TE, 3) - TEMP(J_LE:J_TE, 4)) ./ AX;
end