%% Information
% File: Runner_GeometryUI.m
% Author: Jered Dominguez-Trujillo
% Date: December 11, 2019
% Location: MIT Gas Turbine Laboratory

%% Function: Runner_GeometryUI
    % Inputs: 
        % 1. file -> Path to grid2d.data (Original Blade Coordinates)
        % 2. Settings -> Struct containing file paths and output settings
        
    % Example Run:
        % load('Settings.mat');
        % Runner_GeometryUI('./Input/grid2d.dat', Settings);
        
    % Other Notes:
    % Uncomment lines 60-113 to find best control points for given input
    % data
    
    % Control point determination is located in getControlPoints.m
    
    % Current configuration takes forever to run... shorten by adjusting
    % lines 4-12 of getControlPoints.m
    
function Runner_GeometryUI(file, Settings)
    close all;
    
    % Generate Output Directories
    SystemCall('mkdir ./Output');
    SystemCall('mkdir ./Output/Files');
    SystemCall('mkdir ./Output/Figures');
    SystemCall('mkdir ./Output/Figures/Mod');
    SystemCall('mkdir ./Output/Figures/STAGENINOUT');
    
    % Read in Blade Data from ./Input/grid2d.dat
    delimiterIn = ' ';
    RAW_INPUT = importdata(file, delimiterIn);

    fprintf('Data readin completed.\n');

    %% SPLIT FILE IN PLOTTABLE PASSAGES
    NOSECT = 9;

    % Values dependent on grid from previous stagen/multall run
    J_IGV = 146; J_ROTOR = 136; J_STATOR = 151;
    J_IGV_LE = 31; J_IGV_TE = 131;
    J_ROTOR_LE = 21; J_ROTOR_TE = 121;
    J_STATOR_LE = 21; J_STATOR_TE = 121;
    
    SECT_MID = 5;
    
    % GET DATA TO GENERATE PLOT
    PLOT_IGV = RAW_INPUT(1:NOSECT*J_IGV, :);
    PLOT_ROTOR = RAW_INPUT(NOSECT*J_IGV + 1:NOSECT*(J_IGV+J_ROTOR), :);
    PLOT_STATOR = RAW_INPUT(NOSECT*(J_IGV+J_ROTOR) + 1:end, :);

    PLOT_IGV_MID = PLOT_IGV((SECT_MID - 1)*J_IGV + 1:SECT_MID*J_IGV, :);
    PLOT_ROTOR_MID = PLOT_ROTOR((SECT_MID - 1)*J_ROTOR + 1:SECT_MID*J_ROTOR, :);
    PLOT_STATOR_MID = PLOT_STATOR((SECT_MID - 1)*J_STATOR + 1:SECT_MID*J_STATOR, :);
    
    % GET SECTIONWISE FILES
    X_IGV_START = PLOT_IGV_MID(J_IGV_LE, 2);
    AX_IGV = PLOT_IGV_MID(J_IGV_TE, 2) - PLOT_IGV_MID(J_IGV_LE, 2);
    
    X_ROTOR_START = PLOT_ROTOR_MID(J_ROTOR_LE, 2);
    AX_ROTOR = PLOT_ROTOR_MID(J_ROTOR_TE, 2) - PLOT_ROTOR_MID(J_ROTOR_LE, 2);

    X_STATOR_START = PLOT_STATOR_MID(J_STATOR_LE, 2);
    AX_STATOR = PLOT_STATOR_MID(J_STATOR_TE, 2) - PLOT_STATOR_MID(J_STATOR_LE, 2);
 
%     %% Control Points
%     count = 1;
%     CP_UPPER = cell(3 * NOSECT, 1); CP_LOWER = cell(3 * NOSECT, 1);
%     
%     for ii = 1:NOSECT
%         TITLE = sprintf('IGV Section %.0f', ii);
%         fprintf('Getting Initial Control Points of %s\n', TITLE);
%         [XUPPER, XLOWER, YUPPER, YLOWER] = ...
%             sectionGeometry(ii, PLOT_IGV, J_IGV, J_IGV_LE, J_IGV_TE, X_IGV_START, AX_IGV);
%         
%         YUPPER = YUPPER - YUPPER(1);
%         YLOWER = YLOWER - YLOWER(1);
%     
%         CP_UPPER{count} = getControlPoints(XUPPER, YUPPER);
%         CP_LOWER{count} = getControlPoints(XLOWER, YLOWER);
%         
%         writeControlPoints(Settings, CP_UPPER{count}, CP_LOWER{count});
%         
%         count = count + 1;
%     end
%     
%     for ii = 1:NOSECT
%         TITLE = sprintf('ROTOR Section %.0f', ii);
%         fprintf('Getting Initial Control Points of %s\n', TITLE);
%         [XUPPER, XLOWER, YUPPER, YLOWER] = ...
%             sectionGeometry(ii, PLOT_ROTOR, J_ROTOR, J_ROTOR_LE, J_ROTOR_TE, X_ROTOR_START, AX_ROTOR);
%         
%         YUPPER = YUPPER - YUPPER(1);
%         YLOWER = YLOWER - YLOWER(1);
%         
%         CP_UPPER{count} = getControlPoints(XUPPER, YUPPER);
%         CP_LOWER{count} = getControlPoints(XLOWER, YLOWER);
%         
%         writeControlPoints(Settings, CP_UPPER{count}, CP_LOWER{count});
%         
%         count = count + 1;
%     end
%     
%     for ii = 1:NOSECT
%         TITLE = sprintf('STATOR Section %.0f', ii);
%         fprintf('Getting Initial Control Points of %s\n', TITLE);
%         [XUPPER, XLOWER, YUPPER, YLOWER] = ...
%             sectionGeometry(ii, PLOT_STATOR, J_STATOR, J_STATOR_LE, J_STATOR_TE, X_STATOR_START, AX_STATOR);
%         
%         YUPPER = YUPPER - YUPPER(1);
%         YLOWER = YLOWER - YLOWER(1);
%         
%         CP_UPPER{count} = getControlPoints(XUPPER, YUPPER);
%         CP_LOWER{count} = getControlPoints(XLOWER, YLOWER);
%         
%         writeControlPoints(Settings, CP_UPPER{count}, CP_LOWER{count});
%         
%         count = count + 1;
%     end
    
    % Get updated control points
    fid = fopen(Settings.FICP, 'r');
    
    for ii = 1:3 * NOSECT
        for jj = 1:5
            data = fgetl(fid);
            data = str2num(data);
            CP_UPPER{ii}(jj, :) = data(1:2);
            CP_LOWER{ii}(jj, :) = data(3:4);
        end
    end
    
    fclose(fid);
    
    %% IGV
    count = 1;
    for ii = 1:NOSECT
        [XUPPER, XLOWER, YUPPER, YLOWER] = ...
            sectionGeometry(ii, PLOT_IGV, J_IGV, J_IGV_LE, J_IGV_TE, X_IGV_START, AX_IGV);
    
        YUPPER = YUPPER - YUPPER(1);
        YLOWER = YLOWER - YLOWER(1);
        
        Data.xUpper = XUPPER;
        Data.xLower = XLOWER;
        Data.yUpper = YUPPER;
        Data.yLower = YLOWER;
        Data.cpUpper = CP_UPPER{count};
        Data.cpLower = CP_LOWER{count};
        
        TITLE = sprintf('IGV Section %.0f', ii);
        Settings.Title = TITLE;
        
        BladeGeometry(Data, Settings);
        count = count + 1;
        pause;
    end
    
    
    %% Rotor
    
    for ii = 1:NOSECT
        [XUPPER, XLOWER, YUPPER, YLOWER] = ...
            sectionGeometry(ii, PLOT_ROTOR, J_ROTOR, J_ROTOR_LE, J_ROTOR_TE, X_ROTOR_START, AX_ROTOR);
        
        YUPPER = YUPPER - YUPPER(1);
        YLOWER = YLOWER - YLOWER(1);
        
        Data.xUpper = XUPPER;
        Data.xLower = XLOWER;
        Data.yUpper = YUPPER;
        Data.yLower = YLOWER;
        Data.cpUpper = CP_UPPER{count};
        Data.cpLower = CP_LOWER{count};
        
        TITLE = sprintf('Rotor Section %.0f', ii);
        Settings.Title = TITLE;
        
        BladeGeometry(Data, Settings);
        count = count + 1;
        pause;
    end
    
    %% Stator
    
    for ii = 1:NOSECT
        [XUPPER, XLOWER, YUPPER, YLOWER] = ...
            sectionGeometry(ii, PLOT_STATOR, J_STATOR, J_STATOR_LE, J_STATOR_TE, X_STATOR_START, AX_STATOR);
        
        YUPPER = YUPPER - YUPPER(1);
        YLOWER = YLOWER - YLOWER(1);
        
        Data.xUpper = XUPPER;
        Data.xLower = XLOWER;
        Data.yUpper = YUPPER;
        Data.yLower = YLOWER;
        Data.cpUpper = CP_UPPER{count};
        Data.cpLower = CP_LOWER{count};
        
        TITLE = sprintf('Stator Section %.0f', ii);
        Settings.Title = TITLE;
        
        BladeGeometry(Data, Settings);
        count = count + 1;
        pause;
    end
    
    close all;
    
    BladeGeometry_ModifyStagen(length(Settings.XOUTPUT), './Input/stagen_original.dat', Settings.CFILE, Settings.TFILE);
    
    SystemCall('./STAGEN < ./Output/Files/stagen.dat');
    SystemCall('mv grid2d.dat ./Output/Files/grid2d.dat');
    SystemCall('mv blade.dat ./Output/Files/blade.dat');
    SystemCall('mv stage_new.dat ./Output/Files/stage_new.dat');
    SystemCall('mv stage_old.dat ./Output/Files/stage_old.dat');
    SystemCall('mv stagen.out ./Output/Files/stagen.out');
    close all;
    
    Geometry_Compare(Settings, './Output/Files/grid2d.dat', 1001);
end  
 







