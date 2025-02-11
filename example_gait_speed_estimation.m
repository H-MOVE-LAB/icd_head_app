% Main script for Gait Speed Estimation

% 1. Load the results.mat file from a folder in the project
load('path_to_project_folder/results.mat'); % Modify this path according to your project folder

% 2. Call the function 'build_data_for_gait_speed_estimator'
% This function processes the raw data by segmenting, filtering and extracting features.
dataForEstimator = build_data_for_gait_speed_estimator(results);

% The output 'dataForEstimator' can be further used for training or testing the GPR model

%% Function 1: 'build_data_for_gait_speed_estimator'
function dataForEstimator = build_data_for_gait_speed_estimator(results)
% Initialize an empty cell array to store features for each trial
dataForEstimator = {};

% Iterate through the structure 'results', which contains Test4-7, each with Trial1-3
for testIdx = 4:7  % Test4-7
    for trialIdx = 1:3  % Trial1-3
        % Extract the raw data and the predicted ICs for the current test and trial
        rawData = results.(['Test' num2str(testIdx)]).(['Trial' num2str(trialIdx)]).Standards.INDIP.MicroWB.dataset_r;
        predictedICs = results.(['Test' num2str(testIdx)]).(['Trial' num2str(trialIdx)]).Standards.INDIP.MicroWB.Predicted_Initial_Contact_Events;

        % Get the number of windows N (rows) and the number of columns (1400)
        [N, ~] = size(rawData);

        % Segment the raw data using the predicted ICs
        segmentedData = segment_data(rawData, predictedICs, N);

        % Apply low-pass filtering to the segmented data
        filteredData = low_pass_filter(segmentedData);

        % Extract features from the filtered data
        features = extractFeature(filteredData);

        % Append the features for this particular trial
        dataForEstimator{end+1} = features; % Store the features for this trial
    end
end
end

%% Function 2: 'segment_data'
function segmentedData = segment_data(rawData, predictedICs, N)
% Initialize an empty array to store the segmented data
segmentedData = {};

% Segment the data based on predicted initial contact events
for i = 1:length(predictedICs) - 1  % Iterate through the predicted ICs
    % Extract the window of data between two consecutive ICs
    startIdx = predictedICs(i);
    endIdx = predictedICs(i+1);

    % Make sure the indices are within bounds
    if startIdx <= N && endIdx <= N
        segment = rawData(startIdx:endIdx, :);
        segmentedData{end+1} = segment; % Store the segment
    end
end
end

%% Function 3: 'low_pass_filter'
function filteredData = low_pass_filter(segmentedData)
% Define the cutoff frequency for the low-pass filter (e.g., 10 Hz)
cutoffFreq = 10;  % This is an example value, adjust based on your needs
fs = 1000;  % Sampling frequency (example value, adjust as necessary)

% Design the low-pass filter
[b, a] = butter(2, cutoffFreq / (fs / 2), 'low');

% Apply the low-pass filter to each segment of the data
filteredData = {};
for i = 1:length(segmentedData)
    segment = segmentedData{i};
    % Apply the filter to each channel (column) of the segment
    for j = 1:size(segment, 2)
        segment(:, j) = filtfilt(b, a, segment(:, j));
    end
    filteredData{end+1} = segment; % Store the filtered segment
end
end

%% Function 4: 'extractFeature'
function features = extractFeature(filteredData)
% Initialize an empty array to store features for all the segments
features = [];

% Iterate through the filtered data and extract features for each segment
for i = 1:length(filteredData)
    segment = filteredData{i};

    % Extract relevant features from the segment (example features)
    % For instance, you could compute mean, standard deviation, etc.
    featureVector = [];
    featureVector = [featureVector; mean(segment, 1)];  % Mean of each channel
    featureVector = [featureVector; std(segment, 0, 1)];  % Standard deviation of each channel

    % Concatenate the feature vector for this segment to the overall features
    features = [features; featureVector];
end
end
