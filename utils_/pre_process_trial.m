function x = pre_process_trial(data,b,a,nTest,nTrial)
% PRE_PROCESS_TRIAL Function to pre-process head accelerations and angular
% rates during a single trial. 
% -------------------------------------------------------------------------
% Author: Paolo Tasca (Politecnico di Torino, paolo.tasca@polito.it)
% Version history: 
%   v1:                 Mar 12th 2023
%   v2:                 Jan 12th 2024
% -------------------------------------------------------------------------
% Inputs: 
%   data:   INDIP data (type: 1x1 struct)
%   b:      filter b-coefficients (type: double array).
%   a:      filter a-coefficients (type: double array).
%   nTest:  number of Test for standardized acquisitions (type: double). Ex.7
%   nTrial: number of Trial for standardized acquisitions (type: double). Ex.3
% Outputs: 
%   x:      pre-processed data of trial (type: double array)
% -------------------------------------------------------------------------
% Extract predictors
acc = data.TimeMeasure1.(['Test',num2str(nTest)]).(['Trial',num2str(nTrial)]).SU_INDIP.Head.Acc;
gyr = data.TimeMeasure1.(['Test',num2str(nTest)]).(['Trial',num2str(nTrial)]).SU_INDIP.Head.Gyr;
x = [acc,gyr]; % concatenation
% Pre-processing
x = filtfilt(b,a,x); % anti-causal filtering
x = normalize(x); % z-score normalization
end