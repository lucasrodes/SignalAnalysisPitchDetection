%   Execute this script and select a recording file to analyze.

close all;
clc
 
[file,path] = uigetfile('.wav'); % load file

disp('running...');

filepath = [path file];
% execute pitch detection algorithm
[MSE,avErr,GPE,Pv_uv,Puv_v] = comparePitchDetection(filepath,1); 

disp(['MSE error:' num2str(MSE)]); 
disp(['Average pitch error (Hz):' num2str(avErr)]);
disp(['Gross Pitch Error (20%): ' num2str(GPE*100) ' %']);
disp(['P(voiced|unvoiced) = ' num2str(Pv_uv*100) '%']);
disp(['P(unvoiced|voiced) = ' num2str(Puv_v*100) '%']);