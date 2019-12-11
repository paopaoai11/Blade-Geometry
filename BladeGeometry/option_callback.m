%% Information
% File: option_callback.m
% Author: Jered Dominguez-Trujillo
% Date: December 11, 2019
% Location: MIT Gas Turbine Laboratory

%% Function option_callback
function option_callback(src, ~, Settings)
    if src.Value == 3
        TITLE = strrep(Settings.Title, ' ', '_');
        fprintf('Saving Figure\n');
        saveas(gcf, sprintf('./Output/Figures/Mod/%s.png', TITLE));
        fprintf('Continuing...\n');
        
        NPOINTS = Settings.N;
        DELTA = floor(NPOINTS ./ length(Settings.XOUTPUT));
        CPFILE = Settings.CPFILE;
        SFILE = Settings.SFILE;
        CFILE = Settings.CFILE;
        TFILE = Settings.TFILE;
        BLADEFILE = Settings.BLADEFILE;
        XOUTPUT = Settings.XOUTPUT;
        
        h1=gca;
        x={h1.Children.XData};
        y={h1.Children.YData};
        
        xLOWER = x{3}; yLOWER = y{3};
        xUPPER = x{4}; yUPPER = y{4};
        
        x_CPLOWER = x{5}; y_CPLOWER = y{5};
        x_CPUPPER = x{6}; y_CPUPPER = y{6};
        
        fid = fopen(CPFILE, 'a');
        
        for ii = 1:length(x_CPLOWER)
            fprintf(fid, '%.4f\t%.4f\t%.4f\t%.4f\n', x_CPUPPER(ii), y_CPUPPER(ii), x_CPLOWER(ii), y_CPLOWER(ii));
        end
        
        fclose(fid);
        
        fid = fopen(SFILE, 'a');
    
        SUP = zeros(1, length(XOUTPUT));
        SLOW = zeros(1, length(XOUTPUT));

        for ii = 1:length(XOUTPUT)
            XCurU = XOUTPUT(ii);
            InxU = find(xUPPER <= XCurU, 1, 'last');
            
            XCurL = XOUTPUT(ii);
            InxL = find(xLOWER <= XCurL, 1, 'last');

            if ii == 1
                SUP(ii) = atan2(yUPPER(DELTA + 1) - yUPPER(1), xUPPER(DELTA + 1) - xUPPER(1)) .* 180 ./ pi;
                SLOW(ii) = atan2(yLOWER(DELTA + 1) - yLOWER(1), xLOWER(DELTA + 1) - xLOWER(1)) .* 180 ./ pi;
            elseif ii == length(XOUTPUT)
                SUP(ii) = atan2(yUPPER(end) - yUPPER(end - DELTA), xUPPER(end) - xUPPER(end - DELTA)) .* 180 ./ pi;
                SLOW(ii) = atan2(yLOWER(end) - yLOWER(end - DELTA), xLOWER(end) - xLOWER(end - DELTA)) .* 180 ./ pi;
            else 
                SLOW(ii) = atan2(yLOWER(InxU + DELTA ./ 2) - yLOWER(InxU - DELTA ./ 2), xLOWER(InxU + DELTA ./ 2) - xLOWER(InxU - DELTA ./ 2)) .* 180 ./ pi;
                SLOW(ii) = atan2(yLOWER(InxL + DELTA ./ 2) - yLOWER(InxL - DELTA ./ 2), xLOWER(InxL + DELTA ./ 2) - xLOWER(InxL - DELTA ./ 2)) .* 180 ./ pi;
            end

            fprintf(fid, '%.4f\t%.4f\t%.4f\n', XOUTPUT(ii), SUP(ii), SLOW(ii));
        end

        fclose(fid);

        fid = fopen(CFILE, 'a');

        yUPPER_Fixed = interp1q(xUPPER.', yUPPER.', xLOWER.').';
        yLOWER_Fixed = interp1q(xLOWER.', yLOWER.', xLOWER.').';
        
        CAMBER = ((yUPPER_Fixed + yLOWER_Fixed) ./ 2);
        DEG = zeros(1, NPOINTS);

        for ii = 1:length(XOUTPUT)
            XCurL = XOUTPUT(ii);
            InxL = find(xLOWER >= XCurL, 1);

            if ii == 1
                DEG(ii) = atan2(CAMBER(DELTA + 1) - CAMBER(1), xLOWER(DELTA + 1) - xLOWER(1)) .* 180 ./ pi;
            elseif ii == length(XOUTPUT)
                DEG(ii) = atan2(CAMBER(end) - CAMBER(end - DELTA), xLOWER(end) - xLOWER(end - DELTA)) .* 180 ./ pi;
            else 
                DEG(ii) = atan2(CAMBER(InxL + DELTA ./ 2) - CAMBER(InxL - DELTA ./ 2), xLOWER(InxL + DELTA ./ 2) - xLOWER(InxL - DELTA ./ 2)) .* 180 ./ pi;
            end

            fprintf(fid, '%.4f\t%.4f\n', XOUTPUT(ii), DEG(ii));
        end

        fclose(fid);

        fid = fopen(TFILE, 'a');

        THICKNESS = yUPPER_Fixed - yLOWER_Fixed;
        
        for ii = 1:length(XOUTPUT)
            if ii == 1 || ii == NPOINTS
                fprintf(fid, '%.4f\t%.4f\n', XOUTPUT(ii), 0);
            else
                fprintf(fid, '%.4f\t%.4f\n', XOUTPUT(ii), THICKNESS(find(xLOWER <= XOUTPUT(ii), 1, 'last')));
            end
        end

        fclose(fid);

        fid = fopen(BLADEFILE, 'a');

        for ii = 1:NPOINTS
            fprintf(fid, '%.4f\t%.4f\t%.4f\t%.4f\t%.4f\n', xLOWER(ii), yUPPER_Fixed(ii), yLOWER_Fixed(ii), THICKNESS(ii), CAMBER(ii));
        end

        fclose(fid);
        return;
    end
end