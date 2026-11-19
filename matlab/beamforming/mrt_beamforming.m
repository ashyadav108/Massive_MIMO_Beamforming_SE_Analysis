clc;
clear;
close all;

%% Massive MIMO Configuration
Nt = 64;       % BS antennas
K = 8;         % Users

%% Generate Rayleigh MIMO Channel
H = (randn(K,Nt) + 1j*randn(K,Nt)) / sqrt(2);

%% MRT Beamforming
% For each user, the beamforming vector is
% proportional to the conjugate of its channel.

W = H';

%% Normalize each beamforming vector
for k = 1:K
    W(:,k) = W(:,k) / norm(W(:,k));
end

%% Effective Channel
G = H * W;

%% Display Results
fprintf('===================================\n');
fprintf('MRT BEAMFORMING\n');
fprintf('===================================\n');

fprintf('BS antennas : %d\n', Nt);
fprintf('Users       : %d\n', K);

fprintf('\nBeamforming matrix dimensions: %d x %d\n', ...
    size(W,1), size(W,2));

fprintf('Effective channel dimensions: %d x %d\n', ...
    size(G,1), size(G,2));

fprintf('\nBeamforming vector norms:\n');

for k = 1:K
    fprintf('User %d: %.4f\n', k, norm(W(:,k)));
end

fprintf('\nMRT beamforming completed successfully.\n');