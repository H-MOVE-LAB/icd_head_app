function stackedWindows = divide_into_windows(x, winSize, overlap)
% DIVIDE_INTO_WINDOWS Buffers input matrix x into overlapping windows.
%
% Description:
%   This function segments the input signal matrix `x` into overlapping 
%   windows of fixed length `winSize` with overlap `overlap`. It processes 
%   each signal component separately and returns a structured dataset.
%
% Author:
%   Dr. Paolo Tasca, Politecnico di Torino
%   Email: paolo.tasca@polito.it
%
% Version History:
%   v1.0 - Mar 12, 2023 - Initial version
%   v2.0 - Jan 12, 2024 - Improved performance and documentation
%
% Inputs:
%   x (nx7 double array) - Matrix containing predictors and labels.
%   winSize (double)      - Length of each window (e.g., 200 samples).
%   overlap (double)      - Number of overlapping samples (e.g., 100).
%
% Outputs:
%   stackedWindows (matrix) - Stacked windows of predictors and labels 
%                             with specified overlap.
%
% -------------------------------------------------------------------------
%% Initialize output array
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
