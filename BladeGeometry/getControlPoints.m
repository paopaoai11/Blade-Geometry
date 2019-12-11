%% Information
% File: getControlPoints.m
% Author: Jered Dominguez-Trujillo
% Date: December 11, 2019
% Location: MIT Gas Turbine Laboratory

%% Function getControlPoints
function ControlPoints = getControlPoints(xData, yData)
    POINTS_LEFT = [0, yData(1)];
    range = max(yData) - min(yData);
    
    [XX_MID1, YY_MID1] = ndgrid(0: 0.05/8: 0.05, min(yData):range / 11:max(yData));
    POINTS_MID1 = [XX_MID1(:), YY_MID1(:)];
    
    [XX_MID2, YY_MID2] = ndgrid(0.1:0.4/8:0.5, min(yData)  - range: 3 * range / 11: max(yData) + range);
    POINTS_MID2 = [XX_MID2(:), YY_MID2(:)];

    [XX_MID3, YY_MID3] = ndgrid(0.55:0.4/8:0.95, min(yData)  - range: 3 * range / 11: max(yData) + range);
    POINTS_MID3 = [XX_MID3(:), YY_MID3(:)];
    
    POINTS_RIGHT = [1, yData(end)];
    
    count = 1;
    POINTS = zeros(length(POINTS_MID1) * length(POINTS_MID2) * length(POINTS_MID3), 10);
    for ii = 1:length(POINTS_MID1)
        for jj = 1:length(POINTS_MID2)
            for kk = 1:length(POINTS_MID3)
                POINTS(count, :) = [POINTS_LEFT(1, 1), POINTS_LEFT(1, 2), ...
                    POINTS_MID1(ii, 1), POINTS_MID1(ii, 2), ...
                    POINTS_MID2(jj, 1), POINTS_MID2(jj, 2), ...
                    POINTS_MID3(kk, 1), POINTS_MID3(kk, 2), ...
                    POINTS_RIGHT(1, 1), POINTS_RIGHT(1, 2)];
                count = count + 1;
            end
        end
    end

    POINTS = unique(POINTS, 'rows');
    eps = 1000;
    fprintf('Moving on... %.0f\t%.0f\n', count, length(POINTS));
    
    for ii = 1:length(POINTS)
        err = 0;
        px1 = POINTS(ii, 1); py1 = POINTS(ii, 2);
        px2 = POINTS(ii, 3); py2 = POINTS(ii, 4);
        px3 = POINTS(ii, 5); py3 = POINTS(ii, 6);
        px4 = POINTS(ii, 7); py4 = POINTS(ii, 8);
        px5 = POINTS(ii, 9); py5 = POINTS(ii, 10);
        
        Bez = bezier_curv([px1, px2, px3, px4, px5; ...
            py1, py2, py3, py4, py5].', 101);
        
        yFixed = interp1q(Bez(:, 1), Bez(:, 2), xData);
        if isnan(yFixed(1))
            yFixed(1) = 0;
        elseif isnan(yFixed(end))
            yFixed(end) = yFixed(end - 1);
        end
        err = err + trapz(xData, abs(yData - yFixed));
        
        if err < eps
            eps = err;
            ControlPoints = [px1, py1; px2, py2; px3, py3; px4, py4; px5, py5];
        end
    end
end