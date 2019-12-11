%% Information
% File: writeControlPoints.m
% Author: Jered Dominguez-Trujillo
% Date: December 11, 2019
% Location: MIT Gas Turbine Laboratory

%% Function wrtieControlPoints
function writeControlPoints(Settings, CP_UPPER, CP_LOWER)
    FICP = Settings.FICP;

    fid = fopen(FICP, 'a');
    for jj = 1:length(CP_UPPER)
        fprintf(fid, '%.4f\t%.4f\t%.4f\t%.4f\n', ...
            CP_LOWER(jj, 1), CP_LOWER(jj, 2)), ...
            CP_UPPER(jj, 1), CP_UPPER(jj, 2);
        fprintf('%.4f\t%.4f\t%.4f\t%.4f\n', ...
            CP_LOWER(jj, 1), CP_LOWER(jj, 2)), ...
            CP_UPPER(jj, 1), CP_UPPER(jj, 2);
    end
    fclose(fid);
end