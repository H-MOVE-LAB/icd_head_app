function data_new = label_data(data,winSize,overlap)
% LABEL_DATA Function to partition micro-walking bouts into equal-length
% windows of length "winSize" and with overlap "overlap" and label them.
% Initial contacts are labeled as 1s, other data points are labeled as 0s.
% -------------------------------------------------------------------------
% Author: Paolo Tasca (Politecnico di Torino, paolo.tasca@polito.it)
% Version history:
%   v1:                 Mar 12th 2023
%   v2:                 Jan 12th 2024
% -------------------------------------------------------------------------
% Inputs:
%   data:               INDIP data (type: 1x1 struct)
%   winSize:            size of windows (type: double). Ex. winSize = 200.
%   overlap:            number of overlapped samples (type: double). Ex. overlap = 100.
% Outputs:
%   data_new:           INDIP data with labeled windows (type: 1x1 struct).
% -------------------------------------------------------------------------
% sampling frequency (Hz)
fs = 100; 
first_test = 4; % Ignore Test1 (Static), Test2 (Standing) and Test3 (Data Personalization)
% Returning cell array with the names of each test
struct_test_names = fieldnames(data.TimeMeasure1); % Test names. es. 'Test4'
for nTest = first_test:numel(struct_test_names)
    % Returning cell array with the names of each trial
    struct_trial_names = fieldnames(data.TimeMeasure1.(struct_test_names{nTest})); % Trial names. es. 'Trial1'
    for nTrial = 1:numel(struct_trial_names)
        num_mWB = size(data.TimeMeasure1.(['Test',num2str(nTest)]).(['Trial',num2str(nTrial)]).Standards.INDIP.MicroWB,2);
        % Extract raw and processed predictors
        x_processed = data.TimeMeasure1.(['Test',num2str(nTest)]).(['Trial',num2str(nTrial)]).SU_INDIP.Head.pred_processed;
        x_raw = [...
            data.TimeMeasure1.(['Test',num2str(nTest)]).(['Trial',num2str(nTrial)]).SU_INDIP.Head.Acc,... % raw accelerations
            data.TimeMeasure1.(['Test',num2str(nTest)]).(['Trial',num2str(nTrial)]).SU_INDIP.Head.Gyr];   % raw angular rates
        % Loop for each micro-walking bout (mWB)
        for mWBi=1:num_mWB
            % Target ICs for the mWBi-th micro-walking bout
            ICs = data.TimeMeasure1.(['Test',num2str(nTest)]).(['Trial',num2str(nTrial)])...
                .Standards.INDIP.MicroWB(mWBi).InitialContact_Event;
            ICs = fix(fs*ICs); % seconds --> samples
            % Segment mWB
            % Start of mWB
            s = fix(fs*data.TimeMeasure1.(['Test',num2str(nTest)]).(['Trial',num2str(nTrial)]).Standards.INDIP.MicroWB(mWBi).Start);
            % End of mWB
            e = fix(fs*data.TimeMeasure1.(['Test',num2str(nTest)]).(['Trial',num2str(nTrial)]).Standards.INDIP.MicroWB(mWBi).End);
            % Remove nan events and shift with respect to the start of mWB
            indices = round(rmmissing(ICs))-s+1;
            % Create binary label signal from target ICs for current mWB
            targetMicroWB = zeros(1,fix(e-s+1)); % initialize vector of 0s with length equal to mWB
            targetMicroWB(indices) = 1; % set ICs to 1
            % Create buffer of processed and raw data
            predMicroWB_p = x_processed(s:e,:); predMicroWB_r = x_raw(s:e,:);
            microWB_p = [predMicroWB_p,targetMicroWB']; microWB_r = [predMicroWB_r,targetMicroWB'];
            microWBbuffered_p = divide_into_windows(microWB_p,winSize,overlap);
            microWBbuffered_r = divide_into_windows(microWB_r,winSize,overlap);
            % append to INDIP data structure
            data_new.TimeMeasure1.(['Test',num2str(nTest)]).(['Trial',num2str(nTrial)]).Standards.INDIP.MicroWB(mWBi).dataset_p = microWBbuffered_p;
            data_new.TimeMeasure1.(['Test',num2str(nTest)]).(['Trial',num2str(nTrial)]).Standards.INDIP.MicroWB(mWBi).dataset_r = microWBbuffered_r;
            % append relevant fields
            % Stride speed
            data_new.TimeMeasure1.(['Test',num2str(nTest)]).(['Trial',num2str(nTrial)]).Standards.INDIP.MicroWB(mWBi).Stride_Speed = ...
                data.TimeMeasure1.(['Test',num2str(nTest)]).(['Trial',num2str(nTrial)]).Standards.INDIP.MicroWB(mWBi).Stride_Speed;
            % Start
            data_new.TimeMeasure1.(['Test',num2str(nTest)]).(['Trial',num2str(nTrial)]).Standards.INDIP.MicroWB(mWBi).Start = ...
                data.TimeMeasure1.(['Test',num2str(nTest)]).(['Trial',num2str(nTrial)]).Standards.INDIP.MicroWB(mWBi).Start;
            % End
            data_new.TimeMeasure1.(['Test',num2str(nTest)]).(['Trial',num2str(nTrial)]).Standards.INDIP.MicroWB(mWBi).End = ...
                data.TimeMeasure1.(['Test',num2str(nTest)]).(['Trial',num2str(nTrial)]).Standards.INDIP.MicroWB(mWBi).End;
            % Initial Contacts
            data_new.TimeMeasure1.(['Test',num2str(nTest)]).(['Trial',num2str(nTrial)]).Standards.INDIP.MicroWB(mWBi).InitialContact_Event = ...
                data.TimeMeasure1.(['Test',num2str(nTest)]).(['Trial',num2str(nTrial)]).Standards.INDIP.MicroWB(mWBi).InitialContact_Event;
            % Number of strides
            data_new.TimeMeasure1.(['Test',num2str(nTest)]).(['Trial',num2str(nTrial)]).Standards.INDIP.MicroWB(mWBi).NumberStrides = ...
                data.TimeMeasure1.(['Test',num2str(nTest)]).(['Trial',num2str(nTrial)]).Standards.INDIP.MicroWB(mWBi).NumberStrides;
        end
    end
end
end