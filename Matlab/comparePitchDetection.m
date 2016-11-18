function [MSE,avErr,GPE,Pv_uv,Puv_v] = comparePitchDetection(filepath, plots)
% 	COMPAREPITCHDETECTION plots a comparison of the pitch of the loaded 
%   signal with the reference.
%   [MSE,avErr,GPE,Pv_uv,Puv_v] = COMPAREPITCHDETECTION(filepath, plot) compares the performance of this
%   detection algorithm with the values of the reference database. For this
%   purpose, 5 plots are presented: (1) Pitch Evolution, (2) r(1)/r(0) per 
%   each window, (3) number of zero-crossings, (4) r(P)/r(0) per each win-
%   dow and (5) the energy of each widnwo
%   Furthermore, it returns the MSE between both. 
%   
%   Outputs
%   * MSE: Mean Square Error value.
%   * avErr: average error of the Pitch estimation in Hz.
%   * GPE: Gross Pitch Error at 20%
%   * Pv_uv: Conditional probability of a voiced sound given an unvoiced sound
%   * Puv_v: Conditional probability of an unvoiced sound given a voiced sound
%
%   Inputs
%   * filepath: Input file path
%   * plots: 1 for plotting, 0 if plot is not desired.

% Obtain file name, i.e. from '/path/to/file/rl001.wav' to 'rl001'
    tmp = strsplit(filepath,'/');
    tmp = strsplit(char(tmp(end)),'.');
    name = char(tmp(1));
    
    [x,fs] = audioread(filepath); % load file

    %   x(abs(x)<0.006) = 0; % Center clipping
    
    N = 400; % Size of the Autocorrelation window w[n]
    L = floor(length(x)/N); % Autoccorelations to be computed
    
    tresh(1) = 0.8; % r(1)/r(0) threshold
    tresh(2) = N/80; % Zero crossing threshold
    tresh(3) = 0.4; % r(P)/r(0) threshold
    tresh(4) = var(x(1:end/100)); % Energy threshold
    
    pitch = zeros(1,L); % Define vector of the pitch
    sonorityP = pitch;
    sonority1 = pitch;
    energy = pitch;
    zerocrossing = pitch;
    
    % Iterate and find the pitch
    for i = 1:L-1
        s = x(1+(i-1)*N:i*N); % windowed segment
        [pitch(i),energy(i),sonorityP(i),sonority1(i),zerocrossing(i)] = ...
            pitchDetector(s,fs,tresh); % obtain results for the segment
    end
    
    for i = 2:L-2
        if pitch(i) > 1.5*mean(pitch(pitch>0)) % correct non-sense errors
            pitch(i) = 0.5*(pitch(i+1)+pitch(i-1));
        end
    end
    
    % Read reference file and plot results
    fileID = fopen(['evaluation/pitch_db/'  name '.f0ref'],'r');
    formatSpec = '%f';
    pitch_ref = fscanf(fileID,formatSpec); 

    % Obtain the parameters of the loaded reference file
    Nref = floor(length(x)/length(pitch_ref));
    Lref = length(pitch_ref);
    t_reference = Nref/fs*(0:1:(Lref-1));
    
    % Interpolate the computed pitch vector, in order to compute the MSE
    t_mine = N/fs*(0:1:(L-1));
    pitch_int = interp1(t_mine,pitch,t_reference)';
    pitch_int(isnan(pitch_int))=0; % Avoid sensless values, like NaN
    
    % Compute the MSE and the average error in Hz
    avErr = mean(pitch_int-pitch_ref);%immse(pitch_int,pitch_ref);
    MSE = immse(pitch_int,pitch_ref);
    GPE = sum(abs(pitch_ref-pitch_int)>0.2*pitch_ref)/length(pitch_ref);
    % Probability of voiced given unvoiced
    Pv_uv = sum(pitch_int(pitch_ref==0)> 0)/sum(pitch_ref==0); 
    % Probability of unvoiced given voiced
    Puv_v = sum(pitch_int(pitch_ref>0) == 0)/sum(pitch_ref>0); 
    
    if plots
        figure()
        subplot(5,1,1); 
        plot(t_reference, pitch_ref,'r'); hold on; 
        plot(t_reference,pitch_int,'b'); grid on;
        legend('Reference','Mine'); title('Pitch'); ylabel('Pitch (Hz)'); 
        xlabel('Time (s)');

        subplot(5,1,2); plot(t_mine,sonority1); hold on; plot(t_mine,tresh(1)*...
            ones(size(t_mine)));
        title('Correlation coefficents ratio'); 
        ylabel('r(1)/r(0)'); xlabel('Time (s)'); grid on;  
        
        subplot(5,1,3); plot(t_mine,zerocrossing); title('Zerocrossing'); ...
            ylabel('# Zero Crossing'); 
        xlabel('Time (s)'); grid on; hold on; plot(t_mine,tresh(2)*ones(size(t_mine)));
        
        subplot(5,1,4); plot(t_mine,energy); hold on; plot(t_mine,tresh(4)*...
            ones(size(t_mine))); title('Energy > tresh(1)?'); ylabel('Energy'); 
        xlabel('Time (s)'); grid on;
        
        subplot(5,1,5); plot(t_mine,sonorityP); hold on; plot(t_mine,tresh(3)*...
            ones(size(t_mine)));
        title('Correlation coefficents ratio: r(P)/r(0) > tresh(3)? -> PITCH'); 
        ylabel('r(P)/r(0)'); xlabel('Time (s)'); grid on;      
    end  
end