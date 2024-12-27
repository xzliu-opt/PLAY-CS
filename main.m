% This demo is used to show the reconstruction performance of PLAY-CS on a synthetic channel dataset.

close all
clear;clc

% Add necessary paths to algorithms and utilities
addpath(genpath('algorithms'))
addpath(genpath('utils'))

% Set random number generator to default for reproducibility
rng('default')

% Signal and measurement parameters
n = 32; % Signal dimension (number of variables in the signal)
m = 24;  % Measurement dimension (number of observations)
energy_x = 560; % Energy of the original signal
snr = 40; % Signal-to-noise ratio in dB
sigma_m = energy_x / 10^(snr/10); % Noise variance based on SNR

% Generate the data
[A,y,x,D,seqlen] = gen_data(n,m,sigma_m);

%% Proposed Algorithm
% Initialization of variables
x0 = zeros(n,1); % Initial guess for the signal (zero vector)
P0 = zeros(n,n); % Initial guess for the covariance matrix (identity matrix)
sigma_1 = 100; % Parameter for the measurement noise covariance
R = sigma_1 * eye(m); % Measurement noise covariance matrix (diagonal matrix)
sigma_2 = 3000; % Parameter for the prior signal covariance
Q = sigma_2*eye(n); % Signal covariance matrix (diagonal matrix)
threshold = 3.7; % Threshold for support identification
supp = []; % Initialize the support set (empty)
a = 1; b = 100;

% Run the proposed algorithm to estimate the signal
xhat = play_cs(A,y,x0,P0,R,Q,supp,threshold,a,b);

%% Results Evaluation
% Initialize arrays to store performance metrics
nmse = zeros(seqlen,1); % Normalized Mean Squared Error (NMSE)
Corr = zeros(seqlen,1); % Correlation between estimated and true signals

% Calculate NMSE and Correlation for each sequence
for seq=1:seqlen
    nmse(seq)=norm(D*xhat(:,seq)-D*x(:,seq)) / norm(D*x(:,seq));
end

for seq = 1:seqlen
    Corr(seq) = abs( corr(D*xhat(:,seq),D*x(:,seq)) );
end

% Print the average NMSE and correlation across all sequences
fprintf('PLAY-CS: TNMSE=%.3f, TCorr=%.3f\n',mean(nmse),mean(Corr))
