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

%% Initialize cell array for efficient concatenation
numFeatures = size(x, 2);
bufferedWindows = cell(1, numFeatures); % Preallocate memory for performance

%% Process Each Column Separately
for featureIdx = 1:numFeatures
    signalSegment = x(:, featureIdx); % Extract individual signal
    bufferedData = buffer(signalSegment, winSize, overlap, 'nodelay'); % Apply buffering
    bufferedWindows{featureIdx} = bufferedData; % Store in preallocated cell array
end

%% Convert Cell Array to Matrix
stackedWindows = cell2mat(bufferedWindows); % Efficient concatenation
stackedWindows = stackedWindows'; % Transpose to ensure observations in rows

end
