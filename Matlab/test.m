% Execute this script and wait for the results

clear all;
close all;
clc
 
%[file,path] = uigetfile('.wav');

Nfiles = 100; % Number of files

% Define the MSE vector and the pitch average error vector
MSE = zeros(1,Nfiles);
avErr = MSE;
GPE = MSE;
Pv_uv = MSE;
Puv_v = MSE;

h = waitbar(0,'Please wait...');

% Male .wav files
for i=1:Nfiles/2
    waitbar(i/Nfiles)
    if i<10
        aux = 0;
    else
        aux = ''; 
    end
    
    filepath = ['evaluation/pitch_db/rl0' num2str(aux) num2str(i) '.wav'];
    [MSE(i), avErr(i), GPE(i), Pv_uv(i), Puv_v(i)] = comparePitchDetection(filepath,0);
end

% Female .wav files
for i=1:Nfiles/2
    waitbar((50+i)/Nfiles)
    if i<10
        aux = 0;
    else
        aux = ''; 
    end
    
    filepath = ['evaluation/pitch_db/sb0' num2str(aux) num2str(i) '.wav'];
    [MSE(50+i), avErr(50+i), GPE(50+i), Pv_uv(50+i), Puv_v(50+i)] = ...
        comparePitchDetection(filepath,0);
end

close(h)
figure, plot(MSE); title('Mean Square Error'); xlabel('# recording');
grid on; % Plot MSE
figure, plot(avErr); title('Pitch Average Error'); ylabel('Hz'); xlabel('# recording');
grid on; % Plot the Pitch average error in detection in Hz
figure, plot(GPE); title('Gross Pitch Error'); xlabel('# recording');
grid on; % Plot the Goss Pitch Error
figure, plot(Puv_v); hold on; plot(Pv_uv,'r'); title('Performance'); ...
grid on; legend('P(unvoiced|voiced)','P(voiced|unvoiced)')
