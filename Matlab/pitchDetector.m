function [pitch,energy,sonorityP,sonority1,zerocrossing] = pitchDetector(s,fs,tresh)
% PITCHDETECTOR detects the pitch of a signal.
%   [pitch,energy,sonorityP,sonority1,zerocrossing] = PITCHDETECTOR(s,fs,tresh) obtains the 
%   pitch of the segment s with sample rate fs. Its outputs are:
%
%   Outputs
%   * pitch: Estimated pitch
%   * energy: Energy of the segment
%   * sonorityP: r(P)/r(0) relation
%   * sonority1: r(1)/r(0) relation
%   * zerocrossing: Number of zero crossings
%
%   Inputs
%   * s: Signal segment
%   * fs: Sampling rate
%   * tresh: Tresholds for sonority1, zerocrossing, energy and sonorityP
%   tests
    
    
    N = length(s); % Size of the segment
    offset = N + floor(fs/400); % Parameter to optimize the detection.
    
    energy = var(s) + mean(s)^2; % Compute the energy of the segment
    zerocrossing = sum(abs(s) <= 5e-5); % Number of samples crozzing the x-axis
    
    r = xcorr(s); % correlation
    [~,k] = max(r(offset:end)); % Obtain the sample index that maximizes 
                                % the autocorrelation
    k0 = k + offset-1; % Consider the previous line shifting, remove offset
    k = k0 - N; % This is caused by the MATLAB indexing, remove offset
    sonorityP = r(k0)/r(N);
    sonority1 = r(N+1)/r(N);

    if sonority1>tresh(1) && zerocrossing < tresh(2) && (sonorityP > tresh(3)...
            || energy > tresh(4))
        pitch = fs/k;
    else
        pitch = 0;
    end

end