% -------------------------------------------------------------------------
% Script: Preprocessing for Initial Contacts Detection
% -------------------------------------------------------------------------
% Description:
%   This script performs pre-processing on data stored in a Mobilised-D struct.
%   The operations include:
%   1) Low-pass filtering (cutoff frequency: 5 Hz)
%   2) Z-score normalization (scaling each trial using its mean and standard deviation)
%   3) Partitioning into equal-length windows (200 samples per window, 0% overlap)
%
% Author:
%   Dr. Paolo Tasca, Politecnico di Torino
%   Email: paolo.tasca@polito.it
%
% Version History:
%   v1.0 - Mar 12, 2023 - Initial version
%   v2.0 - Jan 12, 2024 - Improved documentation and code readability
%
% -------------------------------------------------------------------------
clear all; close all; clc;
%% Set Paths and Load Data
currentFolder = pwd;

% Add utility functions to path
addpath(genpath(fullfile(currentFolder, 'utils_')));

% Define the data folder path
exampleDataFolder = 'example_data'; 
subjectID = '0002';

% Construct subject data path
subjectPath = fullfile(exampleDataFolder, 'original', subjectID);
dataFilePath = fullfile(subjectPath, 'Mobility Test', 'Results', 'data.mat');

% Load data
if exist(dataFilePath, 'file')
    load(dataFilePath);
else
    error('Data file not found: %s', dataFilePath);
end

%% Pre-processing
preProcessedData = pre_process(data);

%% Save Processed Data
savePath = fullfile(currentFolder, exampleDataFolder, 'preprocessed');

% Create the directory if it does not exist
if ~exist(savePath, 'dir')
    mkdir(savePath);
end

% Save the processed data
save(fullfile(savePath, 'data.mat'), 'preProcessedData');

fprintf('Pre-processing completed. Processed data saved to: %s\n', savePath);