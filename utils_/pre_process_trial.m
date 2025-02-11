function processedData = pre_process_trial(data, b, a, testIdx, trialIdx)
% PRE_PROCESS_TRIAL Pre-processes head accelerations and angular rates for a single trial.
%
% Description:
%   This function extracts accelerometer and gyroscope signals from the 
%   INDIP dataset, applies low-pass filtering, and performs z-score 
%   normalization.
%
% Author:
%   Dr. Paolo Tasca, Politecnico di Torino
%   Email: paolo.tasca@polito.it
%
% Version History:
%   v1.0 - Mar 12, 2023 - Initial version
%   v2.0 - Jan 12, 2024 - Improved documentation and code readability
%
% Inputs:
%   data (struct)    - INDIP dataset containing gait measurement data.
%   b (double array) - Numerator coefficients of the low-pass filter.
%   a (double array) - Denominator coefficients of the low-pass filter.
%   testIdx (double) - Index of the test in the dataset (e.g., Test7 → 7).
%   trialIdx (double)- Index of the trial within the test (e.g., Trial3 → 3).
%
% Outputs:
%   processedData (double array) - Pre-processed trial data after filtering 
%                                  and normalization.
%
% -------------------------------------------------------------------------

%% Extract Raw Signals
accData = data.TimeMeasure1.(sprintf('Test%d', testIdx))...
                   .(sprintf('Trial%d', trialIdx)).SU_INDIP.Head.Acc;
gyrData = data.TimeMeasure1.(sprintf('Test%d', testIdx))...
                   .(sprintf('Trial%d', trialIdx)).SU_INDIP.Head.Gyr;

% Concatenate acceleration and gyroscope data
rawData = [accData, gyrData];

%% Pre-Processing
% Apply zero-phase low-pass filtering
filteredData = filtfilt(b, a, rawData); 

% Perform z-score normalization
processedData = normalize(filteredData, 'zscore');

end
