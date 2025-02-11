function [filteredStrideNorms,filteredStrideSignals] = segment_acc_stride(signal,s,e)
% SEGMENT_ACC_NORM Takes a 3D acceleration signal and returns the portion of
% the signal between start s and end e. The segmented stride is then used
% to derive the 3D norm and filter it.

% segment acceleration data during stride
stride = signal(s:e,1:3);
%% norms
% compute norms of 3D acceleration and angular rate
strideAccNorm = vecnorm(stride(:,1:3)')';
% low-pass filter norms and concatenate
[b,a] = LowPassFilter(5,10); 
% filtered signal must be at least 3 times longer than filter order
if size(stride,1)>3*max(length(b)-1,length(a)-1)
    filteredAccStride = filtfilt(b,a,strideAccNorm);
    filteredStrideNorms = [filteredAccStride];
else % not filter
    filteredAccStride = strideAccNorm;
    filteredStrideNorms = [filteredAccStride];
end
%% predictors
% low-pass filter predictors
[b,a] = LowPassFilter(3,6); 
if size(stride,1)>3*max(length(b)-1,length(a)-1)
    filteredStrideSignals = filtfilt(b,a,stride);
else
    filteredStrideSignals = stride; 
end
end