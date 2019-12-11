%% Information
% File: Geometry_Compare.m
% Author: Jered Dominguez-Trujillo
% Date: December 11, 2019
% Location: MIT Gas Turbine Laboratory

%% Function Geometry_Compare
function Geometry_Compare(Settings, outputGeometry, NPoints)

    inputGeometry = Settings.BLADEFILE;
    delimiterIn_IN = '\t';
    delimiterIn_OUT = ' ';
    INPUT_GEO = importdata(inputGeometry, delimiterIn_IN);
    OUTPUT_GEO = importdata(outputGeometry, delimiterIn_OUT);
    
    fprintf('Data readin completed.\n');

    %% SPLIT FILE IN PLOTTABLE PASSAGES
    NOSECT = 9;

    J_IGV = 146; J_ROTOR = 136; J_STATOR = 151;
    J_IGV_LE = 31; J_IGV_TE = 131;
    J_ROTOR_LE = 21; J_ROTOR_TE = 121;
    J_STATOR_LE = 21; J_STATOR_TE = 121;
    
    SECT_MID = 5;

    %% Output from Stagen
    
    % GET DATA TO GENERATE PLOT
    OUTPUT_PLOT_IGV = OUTPUT_GEO(1:NOSECT*J_IGV, :);
    OUTPUT_PLOT_ROTOR = OUTPUT_GEO(NOSECT*J_IGV + 1:NOSECT*(J_IGV+J_ROTOR), :);
    OUTPUT_PLOT_STATOR = OUTPUT_GEO(NOSECT*(J_IGV+J_ROTOR) + 1:end, :);

    OUTPUT_PLOT_IGV_MID = OUTPUT_PLOT_IGV((SECT_MID - 1)*J_IGV + 1:SECT_MID*J_IGV, :);
    OUTPUT_PLOT_ROTOR_MID = OUTPUT_PLOT_ROTOR((SECT_MID - 1)*J_ROTOR + 1:SECT_MID*J_ROTOR, :);
    OUTPUT_PLOT_STATOR_MID = OUTPUT_PLOT_STATOR((SECT_MID - 1)*J_STATOR + 1:SECT_MID*J_STATOR, :);
    
    % GET SECTIONWISE FILES
    OUTPUT_X_IGV_START = OUTPUT_PLOT_IGV_MID(J_IGV_LE, 2);
    OUTPUT_AX_IGV = OUTPUT_PLOT_IGV_MID(J_IGV_TE, 2) - OUTPUT_PLOT_IGV_MID(J_IGV_LE, 2);
    
    OUTPUT_X_ROTOR_START = OUTPUT_PLOT_ROTOR_MID(J_ROTOR_LE, 2);
    OUTPUT_AX_ROTOR = OUTPUT_PLOT_ROTOR_MID(J_ROTOR_TE, 2) - OUTPUT_PLOT_ROTOR_MID(J_ROTOR_LE, 2);

    OUTPUT_X_STATOR_START = OUTPUT_PLOT_STATOR_MID(J_STATOR_LE, 2);
    OUTPUT_AX_STATOR = OUTPUT_PLOT_STATOR_MID(J_STATOR_TE, 2) - OUTPUT_PLOT_STATOR_MID(J_STATOR_LE, 2);
 
    sectionCount = 0;
    
    figure(1);
    
    %% IGV
    
    for ii = 1:NOSECT
        sectionCount = sectionCount + 1;
        
        INPUT_XUPPER = INPUT_GEO((sectionCount - 1) * NPoints + 1:(sectionCount) * NPoints, 1);
        INPUT_XLOWER = INPUT_GEO((sectionCount - 1) * NPoints + 1:(sectionCount) * NPoints, 1);
        INPUT_YUPPER = INPUT_GEO((sectionCount - 1) * NPoints + 1:(sectionCount) * NPoints, 2);
        INPUT_YLOWER = INPUT_GEO((sectionCount - 1) * NPoints + 1:(sectionCount) * NPoints, 3);
        
        OUTPUT_TEMP_IGV = OUTPUT_PLOT_IGV((ii - 1) * J_IGV + 1:ii * J_IGV, :);

        OUTPUT_XUPPER = (OUTPUT_TEMP_IGV(J_IGV_LE:J_IGV_TE, 2) - OUTPUT_X_IGV_START) ./ OUTPUT_AX_IGV;
        OUTPUT_XLOWER = (OUTPUT_TEMP_IGV(J_IGV_LE:J_IGV_TE, 2) - OUTPUT_X_IGV_START) ./ OUTPUT_AX_IGV;

        OUTPUT_XUPPER = OUTPUT_XUPPER - min(OUTPUT_XUPPER);
        OUTPUT_XLOWER = OUTPUT_XLOWER - min(OUTPUT_XLOWER);
        
        OUTPUT_YUPPER = OUTPUT_TEMP_IGV(J_IGV_LE:J_IGV_TE, 3) ./ OUTPUT_AX_IGV;
        OUTPUT_YLOWER = (OUTPUT_TEMP_IGV(J_IGV_LE:J_IGV_TE, 3) - OUTPUT_TEMP_IGV(J_IGV_LE:J_IGV_TE, 4)) ./ OUTPUT_AX_IGV;

        DY = min(OUTPUT_YUPPER) - min(INPUT_YUPPER);
                
        OUTPUT_YUPPER = OUTPUT_YUPPER - DY;
        OUTPUT_YLOWER = OUTPUT_YLOWER - DY;
        
        Plot_Compare_Geometry(Settings, 'IGV', ii, OUTPUT_XUPPER, OUTPUT_XLOWER, OUTPUT_YUPPER, OUTPUT_YLOWER, INPUT_XUPPER, INPUT_XLOWER, INPUT_YUPPER, INPUT_YLOWER);
    end
    
    %% Rotor
    
    for ii = 1:NOSECT
        sectionCount = sectionCount + 1;
        
        INPUT_XUPPER = INPUT_GEO((sectionCount - 1) * NPoints + 1:(sectionCount) * NPoints, 1);
        INPUT_XLOWER = INPUT_GEO((sectionCount - 1) * NPoints + 1:(sectionCount) * NPoints, 1);
        INPUT_YUPPER = INPUT_GEO((sectionCount - 1) * NPoints + 1:(sectionCount) * NPoints, 2);
        INPUT_YLOWER = INPUT_GEO((sectionCount - 1) * NPoints + 1:(sectionCount) * NPoints, 3);
        
        OUTPUT_TEMP_ROTOR = OUTPUT_PLOT_ROTOR((ii - 1) * J_ROTOR + 1:ii * J_ROTOR, :);

        OUTPUT_XUPPER = (OUTPUT_TEMP_ROTOR(J_ROTOR_LE:J_ROTOR_TE, 2) - OUTPUT_X_ROTOR_START) ./ OUTPUT_AX_ROTOR;
        OUTPUT_XLOWER = (OUTPUT_TEMP_ROTOR(J_ROTOR_LE:J_ROTOR_TE, 2) - OUTPUT_X_ROTOR_START) ./ OUTPUT_AX_ROTOR;

        OUTPUT_XUPPER = OUTPUT_XUPPER - min(OUTPUT_XUPPER);
        OUTPUT_XLOWER = OUTPUT_XLOWER - min(OUTPUT_XLOWER);
        
        OUTPUT_YUPPER = OUTPUT_TEMP_ROTOR(J_ROTOR_LE:J_ROTOR_TE, 3) ./ OUTPUT_AX_ROTOR;
        OUTPUT_YLOWER = (OUTPUT_TEMP_ROTOR(J_ROTOR_LE:J_ROTOR_TE, 3) - OUTPUT_TEMP_ROTOR(J_ROTOR_LE:J_ROTOR_TE, 4)) ./ OUTPUT_AX_ROTOR;

        DY = min(OUTPUT_YUPPER) - min(INPUT_YUPPER);
                
        OUTPUT_YUPPER = OUTPUT_YUPPER - DY;
        OUTPUT_YLOWER = OUTPUT_YLOWER - DY;
        
        Plot_Compare_Geometry(Settings, 'Rotor', ii, OUTPUT_XUPPER, OUTPUT_XLOWER, OUTPUT_YUPPER, OUTPUT_YLOWER, INPUT_XUPPER, INPUT_XLOWER, INPUT_YUPPER, INPUT_YLOWER);
    end

    %% Stator
    
    for ii = 1:NOSECT
        sectionCount = sectionCount + 1;
        
        INPUT_XUPPER = INPUT_GEO((sectionCount - 1) * NPoints + 1:(sectionCount) * NPoints, 1);
        INPUT_XLOWER = INPUT_GEO((sectionCount - 1) * NPoints + 1:(sectionCount) * NPoints, 1);
        INPUT_YUPPER = INPUT_GEO((sectionCount - 1) * NPoints + 1:(sectionCount) * NPoints, 2);
        INPUT_YLOWER = INPUT_GEO((sectionCount - 1) * NPoints + 1:(sectionCount) * NPoints, 3);
        
        OUTPUT_TEMP_STATOR = OUTPUT_PLOT_STATOR((ii - 1) * J_STATOR + 1:ii * J_STATOR, :);

        OUTPUT_XUPPER = (OUTPUT_TEMP_STATOR(J_STATOR_LE:J_STATOR_TE, 2) - OUTPUT_X_STATOR_START) ./ OUTPUT_AX_STATOR;
        OUTPUT_XLOWER = (OUTPUT_TEMP_STATOR(J_STATOR_LE:J_STATOR_TE, 2) - OUTPUT_X_STATOR_START) ./ OUTPUT_AX_STATOR;

        OUTPUT_XUPPER = OUTPUT_XUPPER - min(OUTPUT_XUPPER);
        OUTPUT_XLOWER = OUTPUT_XLOWER - min(OUTPUT_XLOWER);
        
        OUTPUT_YUPPER = OUTPUT_TEMP_STATOR(J_STATOR_LE:J_STATOR_TE, 3) ./ OUTPUT_AX_STATOR;
        OUTPUT_YLOWER = (OUTPUT_TEMP_STATOR(J_STATOR_LE:J_STATOR_TE, 3) - OUTPUT_TEMP_STATOR(J_STATOR_LE:J_STATOR_TE, 4)) ./ OUTPUT_AX_STATOR;

        DY = min(OUTPUT_YLOWER) - min(INPUT_YLOWER);
                
        OUTPUT_YUPPER = OUTPUT_YUPPER - DY;
        OUTPUT_YLOWER = OUTPUT_YLOWER - DY;
        
        Plot_Compare_Geometry(Settings, 'Stator', ii, OUTPUT_XUPPER, OUTPUT_XLOWER, OUTPUT_YUPPER, OUTPUT_YLOWER, INPUT_XUPPER, INPUT_XLOWER, INPUT_YUPPER, INPUT_YLOWER);
    end
    
    close all;
end
