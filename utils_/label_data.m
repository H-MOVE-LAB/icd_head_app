function labeledData = label_data(data, winSize, overlap)
% LABEL_DATA Partitions micro-walking bouts into fixed-size windows and labels initial contacts.
%
% Description:
%   This function segments micro-walking bouts (mWB) into equal-length 
%   windows with a given overlap, labeling initial contacts (ICs) as 1s 
%   and all other data points as 0s. The resulting labeled dataset is 
%   appended to the INDIP data structure.
%
% Author:
%   Dr. Paolo Tasca, Politecnico di Torino
%   Email: paolo.tasca@polito.it
%
% Version History:
%   v1.0 - Mar 12, 2023 - Initial version
%   v2.0 - Jan 12, 2024 - Improved documentation, readability, and variable naming
%
% Inputs:
%   data (struct)       - INDIP dataset containing gait measurement data.
%   winSize (double)    - Window size for segmentation (e.g., 200 samples).
%   overlap (double)    - Overlap size between windows (e.g., 100 samples).
%
% Outputs:
%   labeledData (struct) - INDIP dataset with labeled micro-walking bout windows.
%
% -------------------------------------------------------------------------

%% Define Parameters
samplingFreq = 100;  % Sampling frequency in Hz
firstTestIdx = 4;    % Ignore Test1 (Static), Test2 (Standing), Test3 (Personalization)

% Extract test names from data structure
testNames = fieldnames(data.TimeMeasure1); 

%% Iterate Over Tests
for testIdx = firstTestIdx:numel(testNames)
    % Extract trial names for the current test
    trialNames = fieldnames(data.TimeMeasure1.(testNames{testIdx}));
    
    % Iterate over all trials in the test
    for trialIdx = 1:numel(trialNames)
        % Get number of micro-walking bouts (mWB) in the current trial
        numMicroWB = numel(data.TimeMeasure1.(sprintf('Test%d', testIdx))...
                                  .(sprintf('Trial%d', trialIdx)).Standards.INDIP.MicroWB);

        % Extract processed and raw head motion data
        processedData = data.TimeMeasure1.(sprintf('Test%d', testIdx))...
                                      .(sprintf('Trial%d', trialIdx)).SU_INDIP.Head.pred_processed;
        rawData = [data.TimeMeasure1.(sprintf('Test%d', testIdx))...
                                      .(sprintf('Trial%d', trialIdx)).SU_INDIP.Head.Acc, ...
                   data.TimeMeasure1.(sprintf('Test%d', testIdx))...
                                      .(sprintf('Trial%d', trialIdx)).SU_INDIP.Head.Gyr];

        %% Iterate Over Micro-Walking Bouts
        for microWBIdx = 1:numMicroWB
            % Extract initial contact (IC) event times (in seconds) and convert to samples
            ICs = fix(samplingFreq * data.TimeMeasure1.(sprintf('Test%d', testIdx))...
                                               .(sprintf('Trial%d', trialIdx))...
                                               .Standards.INDIP.MicroWB(microWBIdx).InitialContact_Event);
            ICs = round(rmmissing(ICs));  % Remove NaN events

            % Get start and end indices for current micro-walking bout (mWB)
            startIdx = fix(samplingFreq * data.TimeMeasure1.(sprintf('Test%d', testIdx))...
                                                      .(sprintf('Trial%d', trialIdx))...
                                                      .Standards.INDIP.MicroWB(microWBIdx).Start);
            endIdx = fix(samplingFreq * data.TimeMeasure1.(sprintf('Test%d', testIdx))...
                                                    .(sprintf('Trial%d', trialIdx))...
                                                    .Standards.INDIP.MicroWB(microWBIdx).End);

            % Shift IC indices relative to the start of the bout
            ICs = ICs - startIdx + 1;

            % Create binary label signal for IC events
            labelVector = zeros(1, fix(endIdx - startIdx + 1));
            labelVector(ICs) = 1; 

            % Extract segment of processed and raw data for the current mWB
            segmentProcessed = processedData(startIdx:endIdx, :);
            segmentRaw = rawData(startIdx:endIdx, :);

            % Concatenate data with label vector
            labeledProcessed = [segmentProcessed, labelVector'];
            labeledRaw = [segmentRaw, labelVector'];

            % Apply windowing
            bufferedProcessed = divide_into_windows(labeledProcessed, winSize, overlap);
            bufferedRaw = divide_into_windows(labeledRaw, winSize, overlap);

            %% Store Processed Data in Structured Format
            labeledData.TimeMeasure1.(sprintf('Test%d', testIdx))...
                                      .(sprintf('Trial%d', trialIdx))...
                                      .Standards.INDIP.MicroWB(microWBIdx).dataset_p = bufferedProcessed;
            labeledData.TimeMeasure1.(sprintf('Test%d', testIdx))...
                                      .(sprintf('Trial%d', trialIdx))...
                                      .Standards.INDIP.MicroWB(microWBIdx).dataset_r = bufferedRaw;

            % Copy relevant metadata from original data
            fieldsToCopy = {'Stride_Speed', 'Start', 'End', 'InitialContact_Event', 'NumberStrides'};
            for fieldIdx = 1:numel(fieldsToCopy)
                field = fieldsToCopy{fieldIdx};
                labeledData.TimeMeasure1.(sprintf('Test%d', testIdx))...
                                          .(sprintf('Trial%d', trialIdx))...
                                          .Standards.INDIP.MicroWB(microWBIdx).(field) = ...
                    data.TimeMeasure1.(sprintf('Test%d', testIdx))...
                                       .(sprintf('Trial%d', trialIdx))...
                                       .Standards.INDIP.MicroWB(microWBIdx).(field);
            end
        end
    end
end

end
