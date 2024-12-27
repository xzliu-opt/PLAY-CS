function [A,y,x,D,seqlen] = gen_data(n,m,sigma_m)
% Function to generate synthetic data for the signal reconstruction problem
%
% Inputs:
% n        : Signal dimension (number of variables in the signal)
% m        : Measurement dimension (number of observations)
% sigma_m  : Noise variance (for generating noisy measurements)
%
% Outputs:
% A        : Measurement matrix (m x n x seqlen)
% y        : Noisy measurements (cell array of length seqlen)
% x        : Sparse signal (n x seqlen)
% D        : Dictionary matrix (n x n)
% seqlen   : Number of sequences (based on the input data size)

% Load synthetic data (e.g., channel matrix)
load("data/synthetic_data.mat")

% Extract specific channel data from the loaded file
H_polar1_user1_sc1 = H_output(1:32,1,1,:); % Data for a specific user and subcarrier
H_polar1_user1_sc1 = squeeze(H_polar1_user1_sc1); % Remove singleton dimensions
[~, seqlen] = size(H_polar1_user1_sc1); % Determine the sequence length (number of columns in the data)

% Construct the dictionary matrix D for sparse representation
t = -1 : 2/n : 1 - 2/n; 
g = 0 : n-1; 
D = 1/sqrt(n) * exp(1j * pi * g' * t); % Dictionary matrix based on a Fourier transform

% Normalize and transform the signal x using the dictionary D
scale_factor = 1;
for t = 1 :seqlen
    x(:,t) = D' * H_polar1_user1_sc1(:,t) / scale_factor; % Sparse signal for each sequence
end

% Generate multiple measurement matrices A for each sequence
T = 4;
for i = 1:T
    Agen = randn(m,n); % Random matrix for measurements
    B = zeros(size(Agen));
    for col = 1:n
        B(:,col) = Agen(:,col) / norm( Agen(:,col) ); % Normalize each column of Agen
    end
    AT(i,:,:) =   B * D * scale_factor;
end

% Assign one of the measurement matrices AT to each sequence in A
for seq  = 1:seqlen
    t = rem(seq,T);
    if t ==0
        A(seq,:,:) = AT(T,:,:);
    else
        A(seq,:,:) = AT(t,:,:);
    end
end

% Generate noisy observations
for seq=1:seqlen
    F = squeeze(A(seq,:,:));
    y{seq}=F*x(:,seq) + sqrt(sigma_m / m)*randn(m,1); % Add Gaussian noise
end

end