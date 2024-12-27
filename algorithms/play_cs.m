function xhat = play_cs(A,y,x0,P0,R,Q,T,alpha,a,b)
% Function to implement the PLAY-CS algorithm for signal reconstruction
%
% Inputs:
% A      : Measurement matrix (dimensions: [m, n, seqlen])
% y      : Measurements for each sequence (cell array of length seqlen)
% x0     : Initial guess for the signal (optional)
% P0     : Initial covariance matrix (optional)
% R      : Measurement noise covariance matrix
% Q      : Signal covariance matrix
% T      : Initial support (indices of non-zero elements of the signal)
% alpha  : Threshold for support identification
% a, b   : Regularization parameters for weighting the update

% Output:
% xhat   : Reconstructed signal for each sequence [n, seqlen]

% Get the number of sequences and the signal dimension
seqlen=length(y); 
n=size(A,3); % The third dimension of A represents the sequence length

% Extract the measurement noise variance from R and Q
sigma_1 = R(1,1);
sigma_2 = Q(1,1);

% Initialize F (measurement matrix for the first sequence)
F = squeeze(A(1,:,:));

% Setup SPG (Sparse Reconstruction) solver options
opts = spgSetParms('verbosity',0);

% First sequence: solve for x using sparse basis pursuit (SPG method)
x = spg_bp(F,y{1},opts);
xhat(:,1)=x;

% Identify the initial support (non-zero elements in the signal)
T=find(abs(x)>alpha);

% Loop over the remaining sequences
for seq=2:seqlen
    % Extract the measurement matrix for the current sequence
    F1 = squeeze(A(seq,:,:));

    % Initialize F2 as an identity matrix for the support set T
    F2 = zeros(n);
    F2(sub2ind(size(F2), T, T)) = 1;
    
    % Compute the filtered measurements for the current sequence
    y_filter = y{seq} - F1*xhat(:,seq-1);
    
    % Construct the combined matrix F and vector Y for the optimization step
    F = [1/sigma_1*F1;
        1/sigma_2*F2];
    Y = [1/sigma_1*y_filter;
        zeros(n,1)];
    
    % Initialize weight matrix W for regularization
    W = eye(n);
    W = 1e-3*W;

    % Update the weights for the non-support indices using a and b
    for i = 1:n
        if ~ismember(i,T)
            W(i,i) = a / (abs(xhat(i,seq-1)) + b);
        end
    end

    % Solve the sparse reconstruction problem using SPG
    opts = spgSetParms('verbosity',0);
    z = spg_bp(F/W,Y,opts);

    % Update the signal estimate using the solution z
    x = W\z;
    x = xhat(:,seq-1) + x; % Combine the previous estimate with the new one
    
    % Store the updated signal estimate
    xhat(:,seq) = x;

    % Update the support set based on the current estimate
    T = find(abs(x)>alpha); 
end
end