clc;
clear;
close all;

%% ===================================
%  MASSIVE MIMO SIMULATION
% ====================================

%% Simulation Configuration
antennaConfigurations = [16 32 64];
K = 8;                      % Number of users
SNR_dB = 0:5:20;            % SNR range
numRealizations = 100;      % Channel realizations
Bandwidth_Hz = 20e6;        % 20 MHz system bandwidth

numAntennaCases = length(antennaConfigurations);
numSNR = length(SNR_dB);

%% Result Storage
SINR_MRT = zeros(numAntennaCases, numSNR);
SINR_ZF = zeros(numAntennaCases, numSNR);
SINR_MMSE = zeros(numAntennaCases, numSNR);

SE_MRT = zeros(numAntennaCases, numSNR);
SE_ZF = zeros(numAntennaCases, numSNR);
SE_MMSE = zeros(numAntennaCases, numSNR);

Throughput_MRT = zeros(numAntennaCases, numSNR);
Throughput_ZF = zeros(numAntennaCases, numSNR);
Throughput_MMSE = zeros(numAntennaCases, numSNR);

%% ===================================
%  MAIN SIMULATION
% ====================================

for a = 1:numAntennaCases

    Nt = antennaConfigurations(a);

    fprintf('\n===================================\n');
    fprintf('BS ANTENNAS: %d\n', Nt);
    fprintf('===================================\n');

    for s = 1:numSNR

        %% SNR and Noise Power
        snrLinear = 10^(SNR_dB(s)/10);
        noisePower = 1 / snrLinear;

        sinrMRT = zeros(K,1);
        sinrZF = zeros(K,1);
        sinrMMSE = zeros(K,1);

        %% Channel Realizations
        for r = 1:numRealizations

            %% Generate Rayleigh MIMO Channel
            H = (randn(K,Nt) + ...
                1j*randn(K,Nt)) / sqrt(2);

            %% ===================================
            %  MRT BEAMFORMING
            % ====================================

            W_MRT = H';

            for k = 1:K
                W_MRT(:,k) = W_MRT(:,k) / ...
                    norm(W_MRT(:,k));
            end

            G_MRT = H * W_MRT;

            %% ===================================
            %  ZF BEAMFORMING
            % ====================================

            W_ZF = H' / (H * H');

            for k = 1:K
                W_ZF(:,k) = W_ZF(:,k) / ...
                    norm(W_ZF(:,k));
            end

            G_ZF = H * W_ZF;

            %% ===================================
            %  MMSE BEAMFORMING
            % ====================================

            W_MMSE = H' / ...
                (H * H' + noisePower * eye(K));

            for k = 1:K
                W_MMSE(:,k) = W_MMSE(:,k) / ...
                    norm(W_MMSE(:,k));
            end

            G_MMSE = H * W_MMSE;

            %% ===================================
            %  SINR CALCULATION
            % ====================================

            for k = 1:K

                % ---------- MRT ----------
                desired = abs(G_MRT(k,k))^2;

                interference = ...
                    sum(abs(G_MRT(k,:)).^2) - desired;

                sinrMRT(k) = sinrMRT(k) + ...
                    desired / ...
                    (interference + noisePower);


                % ---------- ZF ----------
                desired = abs(G_ZF(k,k))^2;

                interference = ...
                    sum(abs(G_ZF(k,:)).^2) - desired;

                sinrZF(k) = sinrZF(k) + ...
                    desired / ...
                    (interference + noisePower);


                % ---------- MMSE ----------
                desired = abs(G_MMSE(k,k))^2;

                interference = ...
                    sum(abs(G_MMSE(k,:)).^2) - desired;

                sinrMMSE(k) = sinrMMSE(k) + ...
                    desired / ...
                    (interference + noisePower);

            end

        end

        %% ===================================
        %  AVERAGE SINR
        % ====================================

        sinrMRT = sinrMRT / numRealizations;
        sinrZF = sinrZF / numRealizations;
        sinrMMSE = sinrMMSE / numRealizations;

        %% Average SINR in dB

        SINR_MRT(a,s) = ...
            mean(10 * log10(sinrMRT));

        SINR_ZF(a,s) = ...
            mean(10 * log10(sinrZF));

        SINR_MMSE(a,s) = ...
            mean(10 * log10(sinrMMSE));

        %% ===================================
        %  SPECTRAL EFFICIENCY
        % ====================================

        SE_MRT(a,s) = ...
            sum(log2(1 + sinrMRT));

        SE_ZF(a,s) = ...
            sum(log2(1 + sinrZF));

        SE_MMSE(a,s) = ...
            sum(log2(1 + sinrMMSE));

        %% ===================================
        %  THROUGHPUT
        % ====================================

        Throughput_MRT(a,s) = ...
            Bandwidth_Hz * SE_MRT(a,s);

        Throughput_ZF(a,s) = ...
            Bandwidth_Hz * SE_ZF(a,s);

        Throughput_MMSE(a,s) = ...
            Bandwidth_Hz * SE_MMSE(a,s);

    end
end

%% ===================================
%  FINAL RESULTS
% ====================================

fprintf('\n\n===================================\n');
fprintf('FINAL MASSIVE MIMO RESULTS\n');
fprintf('===================================\n');

fprintf('System Bandwidth: %.1f MHz\n', ...
    Bandwidth_Hz / 1e6);

fprintf('Final SNR: %d dB\n', ...
    SNR_dB(end));

for a = 1:numAntennaCases

    fprintf('\n-----------------------------------\n');
    fprintf('BS Antennas: %d\n', ...
        antennaConfigurations(a));
    fprintf('-----------------------------------\n');

    fprintf('MRT:\n');
    fprintf('  SINR       = %.2f dB\n', ...
        SINR_MRT(a,end));
    fprintf('  Spectral Efficiency = %.2f bit/s/Hz\n', ...
        SE_MRT(a,end));
    fprintf('  Throughput = %.2f Mbps\n', ...
        Throughput_MRT(a,end) / 1e6);

    fprintf('\nZF:\n');
    fprintf('  SINR       = %.2f dB\n', ...
        SINR_ZF(a,end));
    fprintf('  Spectral Efficiency = %.2f bit/s/Hz\n', ...
        SE_ZF(a,end));
    fprintf('  Throughput = %.2f Mbps\n', ...
        Throughput_ZF(a,end) / 1e6);

    fprintf('\nMMSE:\n');
    fprintf('  SINR       = %.2f dB\n', ...
        SINR_MMSE(a,end));
    fprintf('  Spectral Efficiency = %.2f bit/s/Hz\n', ...
        SE_MMSE(a,end));
    fprintf('  Throughput = %.2f Mbps\n', ...
        Throughput_MMSE(a,end) / 1e6);

end

%% ===================================
%  PLOT 1: SPECTRAL EFFICIENCY
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

title('64-Antenna Massive MIMO Spectral Efficiency');

legend('MRT', 'ZF', 'MMSE');

grid on;

%% ===================================
%  PLOT 2: THROUGHPUT
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

title('64-Antenna Massive MIMO Throughput');

legend('MRT', 'ZF', 'MMSE');

grid on;

%% ===================================
%  PLOT 3: SPECTRAL EFFICIENCY
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

title('Spectral Efficiency vs BS Antennas');

legend('MRT', 'ZF', 'MMSE');

grid on;

%% ===================================
%  SAVE RESULTS
% ====================================

resultsDir = '../../results';

if ~exist(resultsDir, 'dir')
    mkdir(resultsDir);
end

save(fullfile(resultsDir, ...
    'massive_mimo_results.mat'), ...
    'antennaConfigurations', ...
    'SNR_dB', ...
    'SINR_MRT', ...
    'SINR_ZF', ...
    'SINR_MMSE', ...
    'SE_MRT', ...
    'SE_ZF', ...
    'SE_MMSE', ...
    'Throughput_MRT', ...
    'Throughput_ZF', ...
    'Throughput_MMSE', ...
    'Bandwidth_Hz');

fprintf('\n===================================\n');
fprintf('SIMULATION COMPLETED SUCCESSFULLY\n');
fprintf('===================================\n');

fprintf('Results saved to:\n');
fprintf('%s\n', ...
    fullfile(resultsDir, ...
    'massive_mimo_results.mat'));