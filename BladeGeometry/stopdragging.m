%% Information
% File: stopdragging.m
% Author: Jered Dominguez-Trujillo
% Date: December 11, 2019
% Location: MIT Gas Turbine Laboratory

%% Function stopdragging
function stopdragging(fig, ~)
    set(fig,'windowbuttonmotionfcn','');
    set(fig,'windowbuttonupfcn','');
end