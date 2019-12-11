%% Information
% File: BladeGeometry_ModifyStagen.m
% Author: Jered Dominguez-Trujillo
% Date: December 11, 2019
% Location: MIT Gas Turbine Laboratory

%% Function BladeGeomery_ModifyStagen
function BladeGeometry_ModifyStagen(NPOINTS, stagen, new_camber, new_thickness)
    FNAME = stagen;
    FID = fopen(FNAME);
    
    LINE = fgetl(FID);
    LINES = cell(0, 1);
    
    while ischar(LINE)
        LINES{end + 1, 1} = LINE;
        LINE = fgetl(FID);
    end
    
    fclose(FID);
    
    FNAME = new_camber;
    FID = fopen(FNAME);
    
    LINE = fgetl(FID);
    NCAMBER = cell(0, 1);
    
    while ischar(LINE)
        NCAMBER{end + 1, 1} = str2num(LINE);
        LINE = fgetl(FID);
    end
    
    fclose(FID);
    
    FNAME = new_thickness;
    FID = fopen(FNAME);
    
    LINE = fgetl(FID);
    NTHICKNESS = cell(0, 1);
    
    while ischar(LINE)
        NTHICKNESS{end + 1, 1} = str2num(LINE);
        SIZEN = size(NTHICKNESS);
%         if mod(SIZEN(1), NPOINTS) == 1
%             if NTHICKNESS{end, 1}(2) == 0
%                 if SIZEN(1) < 90
%                     NTHICKNESS{end, 1}(2) = 0.01;
%                 else
%                     NTHICKNESS{end, 1}(2) = 0.015;
%                 end
%             end
%         end
        LINE = fgetl(FID);
    end
    
    fclose(FID);
    
    INTYPE = regexp(LINES, 'INTYPE', 'match', 'once');
    INTYPE = ~cellfun(@isempty, INTYPE);
    INTYPE = find(INTYPE);
    
    for ii = 1:length(INTYPE)
        LINES{INTYPE(ii)} = '    2                    INTYPE- TYPE OF BLADE GEOMETRY INPUT';
        LINES{INTYPE(ii) + 1} = sprintf('    %2.0f 200    4          NPIN, NXPTS, NSMOOTH ', NPOINTS);
    end

    count = 1;
    
    for ii = 1:length(NCAMBER)
        X(ii) = NCAMBER{ii}(1);
        CAMBER(ii) = NCAMBER{ii}(2);
    end
    
    for ii = 1:length(NTHICKNESS)
        THICKNESS(ii) = NTHICKNESS{ii}(2) ./ 2;
    end
    
    for ii = 1:length(INTYPE)
        INTYPE = regexp(LINES, 'INTYPE', 'match', 'once');
        INTYPE = ~cellfun(@isempty, INTYPE);
        INTYPE = find(INTYPE);
    
        LINES = {LINES{1:INTYPE(ii) + 1}, LINES{INTYPE(ii) + 8:end}};
        
        for jj = 1:NPOINTS
            LINES = {LINES{1:INTYPE(ii) + jj}, ...
                sprintf('%12.4f%10.4f%10.4f%10.4f', X(count), CAMBER(count), THICKNESS(count), THICKNESS(count))...
                LINES{INTYPE(ii) + jj + 1:end}};
            count = count + 1;
        end
        
        VALS = str2num(LINES{INTYPE(ii) + jj + 2}(1:end-30));
        MAX_THICK = max(THICKNESS(count-NPOINTS:count-1)) .* 2;
        INX = THICKNESS(count-NPOINTS:count-1) == MAX_THICK ./ 2;
        XMAX_THICK = X(count-NPOINTS:count-1);
        XMAX_THICK = XMAX_THICK(INX);
        LINES{INTYPE(ii) + jj + 2} = sprintf('%10.4f%10.4f%10.4f%10.4f%10.4f%10.4f%10.4f     BLADE PROFILE SPECIFICATION', ...
            VALS(1), VALS(2), MAX_THICK, XMAX_THICK, VALS(5), VALS(6), VALS(7));
    end
    
    FNAME = 'stagen.dat';
    
    FID = fopen(FNAME, 'w');
    
    [~, cols] = size(LINES);
    
    for r = 1:cols
        fprintf(FID, '%s\n', LINES{r});
    end
    
    fclose(FID);
    
    SystemCall('mv stagen.dat ./Output/Files/stagen.dat');
end