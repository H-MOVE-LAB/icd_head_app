% main.m
% -------------------------------------------------------------------------
% Author: Paolo Tasca (Politecnico di Torino, paolo.tasca@polito.it)
% Version history: 
%   v1:                 Mar 12th 2023
%   v2:                 Jan 12th 2024
% -------------------------------------------------------------------------
% Main code for pre-processing data saved in Mobilised-D struct
clear all; close all; clc;
%Stampa nella command window
fprintf('\n Program for data pre-processing \n\n');
fprintf('\n Performed pre-processing operations: \n');
fprintf('1) Low-pass filtering (cutoff: 5 Hz) \n');
fprintf('2) Z-score normalization (each trial is scaled using its mean and STD) \n');
fprintf('3) Partitioning into equal-length windows (200 samples, 0 overlap) \n');
%% Data loading
% current folder
current_folder = pwd; 
% add utils_ folder to path
addpath(genpath([current_folder filesep 'utils_']))
% path to the folder that contains sub-folders of subjects
example_data_folder = 'example_data'; 
% subject name
subID = '0002'; 
% path to current subject's data folder
sub_path = [example_data_folder filesep 'original' filesep subID]; 
load([sub_path filesep 'Mobility Test' filesep 'Results' filesep 'data.mat'])
%% Pre-processing
pre_processed_data = pre_process(data); 
%% Saving
% create folder for storing pre-processed data
save_path = [current_folder filesep example_data_folder filesep 'preprocessed']; 
mkdir(save_path)
save([save_path filesep 'data.mat'],'pre_processed_data')