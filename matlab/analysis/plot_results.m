clc;
clear;
close all;

%% ===================================
%  LOAD SIMULATION RESULTS
% ====================================

resultsFile = '../../results/massive_mimo_results.mat';

if ~exist(resultsFile, 'file')
    error('Results file not found. Run massive_mimo_simulation.m first.');
end

load(resultsFile);

fprintf('===================================\n');
fprintf('MASSIVE MIMO RESULT ANALYSIS\n');
fprintf('===================================\n');

fprintf('Results loaded successfully.\n');

%% ===================================
%  PLOT 1: SPECTRAL EFFICIENCY
%  VS SNR
% ====================================

figure;

plot(SNR_dB, SE_MRT(end,:), '-o', ...
    'LineWidth', 1.5);

hold on;

plot(SNR_dB, SE_ZF(end,:), '-s', ...
    'LineWidth', 1.5);

plot(SNR_dB, SE_MMSE(end,:), '-^', ...
    'LineWidth', 1.5);

xlabel('SNR (dB)');
ylabel('Spectral Efficiency (bit/s/Hz)');

title('Spectral Efficiency vs SNR - 64 BS Antennas');

legend('MRT', 'ZF', 'MMSE');

grid on;

%% ===================================
%  PLOT 2: THROUGHPUT
%  VS SNR
% ====================================

figure;

plot(SNR_dB, Throughput_MRT(end,:) / 1e6, ...
    '-o', 'LineWidth', 1.5);

hold on;

plot(SNR_dB, Throughput_ZF(end,:) / 1e6, ...
    '-s', 'LineWidth', 1.5);

plot(SNR_dB, Throughput_MMSE(end,:) / 1e6, ...
    '-^', 'LineWidth', 1.5);

xlabel('SNR (dB)');
ylabel('Throughput (Mbps)');

title('Throughput vs SNR - 64 BS Antennas');

legend('MRT', 'ZF', 'MMSE');

grid on;

%% ===================================
%  PLOT 3: SINR
%  VS NUMBER OF ANTENNAS
% ====================================

figure;

plot(antennaConfigurations, ...
    SINR_MRT(:,end), '-o', ...
    'LineWidth', 1.5);

hold on;

plot(antennaConfigurations, ...
    SINR_ZF(:,end), '-s', ...
    'LineWidth', 1.5);

plot(antennaConfigurations, ...
    SINR_MMSE(:,end), '-^', ...
    'LineWidth', 1.5);

xlabel('Number of BS Antennas');
ylabel('SINR (dB)');

title('SINR vs Number of BS Antennas');

legend('MRT', 'ZF', 'MMSE');

grid on;

%% ===================================
%  PLOT 4: SPECTRAL EFFICIENCY
%  VS NUMBER OF ANTENNAS
% ====================================

figure;

plot(antennaConfigurations, ...
    SE_MRT(:,end), '-o', ...
    'LineWidth', 1.5);

hold on;

plot(antennaConfigurations, ...
    SE_ZF(:,end), '-s', ...
    'LineWidth', 1.5);

plot(antennaConfigurations, ...
    SE_MMSE(:,end), '-^', ...
    'LineWidth', 1.5);

xlabel('Number of BS Antennas');
ylabel('Spectral Efficiency (bit/s/Hz)');

title('Spectral Efficiency vs Number of BS Antennas');

legend('MRT', 'ZF', 'MMSE');

grid on;

%% ===================================
%  DISPLAY ANALYSIS
% ====================================

fprintf('\n===================================\n');
fprintf('KEY PERFORMANCE OBSERVATIONS\n');
fprintf('===================================\n');

fprintf('\nIncreasing BS antennas:\n');
fprintf('16 -> 32 -> 64 antennas improves SINR and spectral efficiency.\n');

fprintf('\nAt 64 BS antennas and 20 dB SNR:\n');

fprintf('MRT  SE = %.2f bit/s/Hz\n', ...
    SE_MRT(end,end));

fprintf('ZF   SE = %.2f bit/s/Hz\n', ...
    SE_ZF(end,end));

fprintf('MMSE SE = %.2f bit/s/Hz\n', ...
    SE_MMSE(end,end));

fprintf('\nZF and MMSE provide substantially higher performance\n');
fprintf('than MRT under the simulated conditions.\n');

fprintf('\n===================================\n');
fprintf('ANALYSIS COMPLETED SUCCESSFULLY\n');
fprintf('===================================\n');