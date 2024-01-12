function [b,a] = LowPassFilter(fCutoff,fStop)
% LOWPASSFILTER Returns coefficients of LP filter with specified cut-off
% frequency fCutoff and stop-band frequency fStop.
% -------------------------------------------------------------------------
% Author: Paolo Tasca (Politecnico di Torino, paolo.tasca@polito.it)
% Version history: 
%   v1:                 Mar 12th 2023
%   v2:                 Jan 12th 2024
% -------------------------------------------------------------------------
% Input: 
%   fCutoff:    cut-off frequency in Hz (type: double).
%   fStop:      stop-band frequency in Hz (tupe: double).
% Output: 
%   b:          filter b-coefficients (type: double array).
%   a:          filter a-coefficients (type: double array).
% -------------------------------------------------------------------------
fs = 100; % sampling frequency (Hz)
fNy = fs/2; % Nyquist frequency (Hz)
%% define filter settings
% LOW PASS CUT-OFF FREQUENCY FROM LITERATURE (Hz)
% Aminian 1995: 16
% Vathsangam 2010: 20
% Zihajehzadeh 2016: 20
% Zihajehzadeh 2017: 5
% Supratak 2018: 20 
% Soltani 2020: 4
% Atrsaei 2021: 3
% Daumer 2022: 0.1 
% Meigal 2022: 3 
Wp = fCutoff/fNy; % Cut-off frequency
Ws = fStop/fNy; % Start of stop-band
Rp = 3; % ripple in pass-band (dB)
Rs = 60; % ripple in stop-band (dB)
%% Filter order and cut-off frequency optimization
% returns minimum order n and normalized cut-off frequency Wn of
% Butterworth filter with specified settings. Input for butter function. 
[~,Wn] = buttord(Wp,Ws,Rp,Rs); 
%% Filter design
[b,a] = butter(10,Wn); 
%% View filtered data (uncomment to plot)
% figure()
% freqz(b,a,1000,fs)
% %% Filtering (anticausal filter)
% x_filtered = filtfilt(b,a,x);     
end