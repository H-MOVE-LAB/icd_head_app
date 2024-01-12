function stackedWindows = divide_into_windows(x,winSize,overlap)
% DIVIDE_INTO_WINDOWS Function to buffer matrix x into matrices of data
% frames of length winSize with specified overlap. Reference: Romijnders 2022. 
% -------------------------------------------------------------------------
% Author: Paolo Tasca (Politecnico di Torino, paolo.tasca@polito.it)
% Version history:
%   v1:                 Mar 12th 2023
%   v2:                 Jan 12th 2024
% -------------------------------------------------------------------------
% Inputs:
%   x:                  array of predictors and label (type: nx7 double array).
%   winSize:            size of windows (type: double). Ex. winSize = 200.
%   overlap:            number of overlapped samples (type: double). Ex. overlap = 100.
% Outputs:
%   stackedWindows:     stacked windows of predictors and labels of length
%                       "winSize" and with overlap "overlap". 
% -------------------------------------------------------------------------
% initialization of output array
stackedWindows = []; 
for i=1:size(x,2) 
    timeSerie = x(:,i); % full sequence of acceleration/gyroscope component
    [windows,~] = buffer(timeSerie,winSize,overlap,'nodelay'); % bufferization
% [1-200: AP-acc;
% 201-400: V-acc;
% 401-600: ML-acc;
% 601-800: AP-gyr;
% 801-1000: V-gyr;
% 1001-1200: ML-gyr; 
% 1201-1400: target label]
    stackedWindows = [stackedWindows;windows]; 
end
stackedWindows = stackedWindows'; % rows: observations, columns: samples.
end
