clc;
clear;
close all;

%% Massive MIMO Configuration
Nt = 64;       % BS antennas
K = 8;         % Users
SNR_dB = 10;   % SNR

%% Generate Rayleigh MIMO Channel
H = (randn(K,Nt) + 1j*randn(K,Nt)) / sqrt(2);

%% Noise Power
SNR_linear = 10^(SNR_dB/10);
noisePower = 1 / SNR_linear;

%% MMSE Beamforming
% W = H^H * inv(H*H^H + sigma^2 I)

W = H' / (H * H' + noisePower * eye(K));

%% Normalize Each Beamforming Vector
for k = 1:K
    W(:,k) = W(:,k) / norm(W(:,k));
end

%% Effective Channel
G = H * W;

%% Calculate Interference Power
interference = abs(G).^2;

for k = 1:K
    interference(k,k) = 0;
end

totalInterference = sum(interference(:));

%% Display Results
fprintf('===================================\n');
fprintf('MMSE BEAMFORMING\n');
fprintf('===================================\n');

fprintf('BS antennas : %d\n', Nt);
fprintf('Users       : %d\n', K);
fprintf('SNR         : %d dB\n', SNR_dB);

fprintf('\nBeamforming matrix dimensions: %d x %d\n', ...
    size(W,1), size(W,2));

fprintf('Effective channel dimensions: %d x %d\n', ...
    size(G,1), size(G,2));

fprintf('\nTotal residual interference power: %.6e\n', ...
    totalInterference);

fprintf('\nBeamforming vector norms:\n');

for k = 1:K
    fprintf('User %d: %.4f\n', k, norm(W(:,k)));
end

fprintf('\nMMSE beamforming completed successfully.\n');