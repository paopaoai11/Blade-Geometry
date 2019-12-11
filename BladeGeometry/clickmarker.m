%% Information
% File: clickmarker.m
% Author: Jered Dominguez-Trujillo
% Date: December 11, 2019
% Location: MIT Gas Turbine Laboratory

%% Function clickmarker
function clickmarker(src, ~, Settings)
    set(ancestor(src, 'figure'), 'windowbuttonmotionfcn', {@dragmarker, src, Settings});
    set(ancestor(src, 'figure'), 'windowbuttonupfcn', @stopdragging);
end