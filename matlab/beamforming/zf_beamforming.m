clc;
clear;
close all;

%% Massive MIMO Configuration
Nt = 64;       % BS antennas
K = 8;         % Users

%% Generate Rayleigh MIMO Channel
H = (randn(K,Nt) + 1j*randn(K,Nt)) / sqrt(2);

%% ZF Beamforming
% W = H^H * inv(H*H^H)

W = H' / (H * H');

%% Normalize each beamforming vector
for k = 1:K
    W(:,k) = W(:,k) / norm(W(:,k));
end

%% Effective Channel
G = H * W;

%% Calculate Interference
interference = abs(G).^2;
for k = 1:K
    interference(k,k) = 0;
end

totalInterference = sum(interference(:));

%% Display Results
fprintf('===================================\n');
fprintf('ZF BEAMFORMING\n');
fprintf('===================================\n');

fprintf('BS antennas : %d\n', Nt);
fprintf('Users       : %d\n', K);

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

fprintf('\nZF beamforming completed successfully.\n');