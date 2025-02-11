function selected_features = calcSelectedFeatures(filteredStrideNorms, filteredStrideSignals)
% CALCSELECTEDFEATURES Function to compute selected features for gait speed estimation.
% This function extracts a subset of features from the input data, specifically:
% 1. Temporal features: min, range, max-mean, step amplitude, sum of absolute values, sum of squared values, variance)
% 2. Stride duration (calculated based on the length of the signal and the sampling frequency)
% 3. Mean vertical velocity (calculated from the acceleration signal)
%
% - filteredStrideNorms: The filtered signal containing the normalized stride data (N x seqSize array)
% - filteredStrideSignals: The raw filtered signals (N x m channels)
%
% Output:
% - selected_features: A table containing the selected features with appropriate column names

%% Settings and Initialization
fs = 100; % Sampling frequency (Hz)
len = size(filteredStrideNorms, 1); % Number of samples in the stride data

x = filteredStrideNorms; 
% Extract the desired temporal features
selected_features(1) = min(x); % minimum
selected_features(2) = range(x); % range
selected_features(3) = min(x)-mean(x); % absolute step amplitude
selected_features(4) = selected_features(3)./len; % relative step amplitude
selected_features(5) = sumabs(x); % sum of absolute values
selected_features(6) = sumsqr(x); % sum of squared values
selected_features(7) = var(x); % variance
selected_features(8) = len / fs; % stride duration (in seconds)
v_acc = filteredStrideSignals(:, 2); % Assuming the second column contains the vertical acceleration data
selected_features(9) = mean(trapz(v_acc)); % mean vertical velocity
end
