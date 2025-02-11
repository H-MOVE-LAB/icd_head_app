function preProcessedData = pre_process(data)
% PRE_PROCESS Pre-processes INDIP data for gait analysis.
%
% Description:
%   This function applies pre-processing steps to the INDIP dataset, 
%   including low-pass filtering, normalization, and windowing.
%   The pre-processed data is then labeled and structured for further analysis.
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
%   data (struct) - INDIP dataset containing gait measurement data.
%
% Outputs:
%   preProcessedData (struct) - Pre-processed INDIP dataset, including
%                               filtered and normalized signals with 
%                               windowed structure.
%
% -------------------------------------------------------------------------

%% Initialization
firstTestIndex = 4; % Ignore Test1 (Static), Test2 (Standing), and Test3 (Data Personalization)
testNames = fieldnames(data.TimeMeasure1); % Extract test names (e.g., 'Test4')

% Low-pass filter design parameters
fCutoff = 5;  % Pass-band frequency (Hz)
fStop = 10;   % Stop-band frequency (Hz)
[b, a] = LowPassFilter(fCutoff, fStop); % Compute filter coefficients

% Windowing parameters
winSize = 200;   % Window size (samples)
overlap = 0;     % Number of overlapped samples (set to 100 during training)

%% Pre-Processing Loop
for testIdx = firstTestIndex:numel(testNames)
    trialNames = fieldnames(data.TimeMeasure1.(testNames{testIdx})); % Extract trial names (e.g., 'Trial1')

    for trialIdx = 1:numel(trialNames)
        % Filtering and normalization of trial data
        preprocessedTrialData = pre_process_trial(data, b, a, testIdx, trialIdx);

        % Store the processed trial data in the corresponding structure field
        data.TimeMeasure1.(sprintf('Test%d', testIdx)).(sprintf('Trial%d', trialIdx))...
            .SU_INDIP.Head.pred_processed = preprocessedTrialData;
    end
end

%% Labeling Data and Structuring Output
preProcessedData = label_data(data, winSize, overlap);

end
