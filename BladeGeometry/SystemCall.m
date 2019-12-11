%% Information
% File: SystemCall.m
% Author: Jered Dominguez-Trujillo
% Date: December 11, 2019
% Location: MIT Gas Turbine Laboratory

%% Function SystemCall
function SystemCall(command)

    fprintf([pwd, ':\t', command, '\n']);
    [status, cmdout] = system(command, '-echo');
    
    if status == 0
        fprintf(strcat(cmdout, '\n\n'));
    else
        fprintf(strcat(cmdout, '\n\n'));
        fprintf('Error Occured: %.0f\nTerminating Program...\n', status);
        return;
    end
    
end