function featuresTable = build_data_for_gait_speed_estimator(results)
fs = 100; % sampling frequency (Hz)
featuresArray = []; % initialize features array

% Iterate through the structure 'results', which contains Test4-7, each with Trial1-3
for testIdx = 4:7  % Test4-7
    for trialIdx = 1:3  % Trial1-3
        % Extract the raw data and the predicted ICs for the current test and trial
        rawData = results.(['Test' num2str(testIdx)]).(['Trial' num2str(trialIdx)]).Standards.INDIP.MicroWB.dataset_r;
        predictedICs = results.(['Test' num2str(testIdx)]).(['Trial' num2str(trialIdx)]).Standards.INDIP.MicroWB.Predicted_Initial_Contact_Events;

        % Get the number of windows N (rows) and the window length (w_len)
        [N, n_col] = size(rawData);
        w_len = n_col/7; % n_col = number of channels (7) x window length (usually 200)

        % Call the unwrap_signals function
        predictors = unwrap_signals(rawData, w_len);

        % Segment the raw data using the predicted ICs
        fprintf('Standardized gait. Test %d, Trial %d \n',testIdx,trialIdx);
        ICs = {results.(['Test',num2str(testIdx)]).(['Trial',num2str(trialIdx)]).Standards.INDIP.MicroWB.InitialContact_Event}';
        ICs = vertcat(ICs{:});
        ICs = [ICs(1:end-2), ICs(3:end)]; 
        % target stride speeds
        WS = {results.(['Test',num2str(testIdx)]).(['Trial',num2str(trialIdx)]).Standards.INDIP.MicroWB.Stride_Speed}';
        WS = [WS{:}];
        fprintf('Number of strides: %d\n',length(WS));
        for jj=1:length(WS)
            fprintf('Stride %d\n',jj);
            if ~isnan(WS(jj)) % ignore "false" strides
                s = fix(fs*ICs(jj,1)); e = fix(fs*ICs(jj,2));
                [filteredStrideNorms,filteredStrideSignals] = segment_acc_stride(predictors,s,e);
                features = calcSelectedFeatures(filteredStrideNorms,filteredStrideSignals);
                featuresArray = [featuresArray;features,WS(jj)];
            end
        end
    end
end
%% Combine all features into one table
% Define the feature names
feature_names = {'Min', 'Range', 'Abs_step_amp', 'Rel_step_amp', 'AbsSum', 'SqrSum', 'Variance', 'Stride_dur', 'Mean_vel_y', 'Gait_speed'};

% Create a table for the selected features
featuresTable = table(featuresArray, 'VariableNames', feature_names);

end