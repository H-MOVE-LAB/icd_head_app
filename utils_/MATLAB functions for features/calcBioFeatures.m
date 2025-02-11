function bio_features = calcBioFeatures(x)
% CALCTIMEFEATURES Function to extract biomechanically interpretable features from a
% single sequence x of length len.
% - x: input sequence. lenx1 double array. 
% bio_features: vector of biomechanical features. 1xp double array
%% settings and initialization
fs = 100; % sampling frequency (Hz)
len = length(x); % number of samples of x
p = 3; % number of extracted biomechanical features
bio_features = zeros(1,p); % initialize biomechanical features vector
%% Integration
v = trapz(x); 
%% biomechanical features
% Reference: 
% 1) Atrsaei 2021
bio_features(1) = mean(v); % mean of velocity 
bio_features(2) = max(v); % maximum of velocity
bio_features(3) = min(v); % minimum of velocity
end