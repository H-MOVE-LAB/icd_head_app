clear all; close all; clc; 
% Main script for Gait Speed Estimation
addpath(genpath('utils_'))
% 1. Load the results.mat file from a folder in the project
load('TCN_outputs\0002\results.mat'); % Results are loaded as a struct variable "TimeMeasure"

% 2. Call the function 'build_data_for_gait_speed_estimator'
% This function processes the raw data by segmenting, filtering and extracting features.
dataForEstimator = build_data_for_gait_speed_estimator(TimeMeasure1);

% 3. Load the trained CompactGPRegression model
modelFile = fullfile('Trained gait speed model', 'trainedGPRModel.mat'); % Update with the actual filename
if exist(modelFile, 'file')
    load(modelFile, 'trainedGPRModel'); % The model should be saved as 'GPRModel'
else
    error('Trained model file not found. Please check the filename and location.');
end
disp('Trained GPR model successfully loaded.');

% 4. Extract input features (X) and target gait speed (Y)
X = table2array(dataForEstimator(:, 1:end-1)); % All columns except the last one (input features)
Y_true = dataForEstimator{:, end}; % Last column as ground truth (gait speed)

% 5. Predict gait speed using the trained GPR model
Y_pred = predict(trainedGPRModel, X);

% 6. Evaluate model performance
rmse = sqrt(mean((Y_pred - Y_true).^2)); % Root Mean Squared Error
fprintf('Root Mean Squared Error (RMSE): %.4f m/s\n', rmse);

%% Plot results
figure;
scatter(Y_true, Y_pred, 'filled');
hold on;
plot([min(Y_true), max(Y_true)], [min(Y_true), max(Y_true)], 'r--', 'LineWidth', 1.5); % Diagonal reference line
xlabel('True Gait Speed (m/s)');
ylabel('Predicted Gait Speed (m/s)');
title('GPR Model Predictions vs. Ground Truth');
grid on;
legend('Predictions', 'Ideal Fit', 'Location', 'best');

disp('Prediction and evaluation complete.');
