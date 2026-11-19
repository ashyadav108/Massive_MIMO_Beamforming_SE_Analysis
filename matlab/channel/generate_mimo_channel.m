clc;
clear;
close all;

%% Massive MIMO Configuration
Nt = 64;       % Number of BS antennas
K = 8;         % Number of users

%% Generate Rayleigh Fading Channel
H = (randn(K, Nt) + 1j*randn(K, Nt)) / sqrt(2);

%% Display Configuration
fprintf('===================================\n');
fprintf('MASSIVE MIMO CHANNEL\n');
fprintf('===================================\n');

fprintf('Number of BS antennas : %d\n', Nt);
fprintf('Number of users       : %d\n', K);

fprintf('Channel dimensions    : %d x %d\n', ...
    size(H,1), size(H,2));

%% Channel Power
channelPower = mean(abs(H(:)).^2);

fprintf('Average channel power : %.4f\n', ...
    channelPower);

fprintf('\nMassive MIMO channel generated successfully.\n');