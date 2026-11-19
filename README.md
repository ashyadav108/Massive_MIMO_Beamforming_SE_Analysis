# Massive MIMO Beamforming and Spectral Efficiency Analysis

## Overview

This project simulates a multi-user 5G Massive MIMO communication system and evaluates different downlink beamforming and precoding techniques.

The implemented techniques are:

- Maximum Ratio Transmission (MRT)
- Zero-Forcing (ZF)
- Minimum Mean Square Error (MMSE)

The performance of each technique is analyzed using **SINR, spectral efficiency, and throughput** for different numbers of base-station antennas and SNR conditions.

---

## Objectives

- Model a multi-user Massive MIMO system using a Rayleigh fading channel.
- Implement MRT, ZF, and MMSE beamforming.
- Evaluate received SINR for multiple users.
- Calculate achievable spectral efficiency.
- Calculate system throughput for a 20 MHz bandwidth.
- Compare performance for 16, 32, and 64 BS antennas.
- Analyze performance over an SNR range of 0–20 dB.

---

## System Configuration

| Parameter | Value |
|---|---:|
| BS antennas | 16, 32, 64 |
| Number of users | 8 |
| Channel model | Rayleigh fading |
| SNR range | 0–20 dB |
| SNR step | 5 dB |
| Channel realizations | 100 |
| System bandwidth | 20 MHz |

---

## Beamforming Techniques

### MRT — Maximum Ratio Transmission

MRT aligns the transmitted beam with the user's channel to maximize the received signal power.

The beamforming matrix is generated as:

```text
W_MRT = Hᴴ
```

where `H` is the channel matrix.

Each beamforming vector is normalized before transmission.

### ZF — Zero-Forcing

ZF suppresses multi-user interference by using the pseudo-inverse of the channel:

```text
W_ZF = Hᴴ(HHᴴ)⁻¹
```

ZF is particularly effective when the number of BS antennas is significantly larger than the number of users.

### MMSE — Minimum Mean Square Error

MMSE beamforming provides a trade-off between interference suppression and noise enhancement:

```text
W_MMSE = Hᴴ(HHᴴ + σ²I)⁻¹
```

where `σ²` represents the noise power.

---

## Simulation Flow

```text
                 Rayleigh MIMO Channel
                          │
                          ▼
                  Multi-user Channel H
                          │
              ┌───────────┼───────────┐
              │           │           │
              ▼           ▼           ▼
             MRT          ZF         MMSE
              │           │           │
              └───────────┼───────────┘
                          ▼
                  Effective Channel
                          │
                          ▼
                   SINR Calculation
                          │
                          ▼
                Spectral Efficiency
                          │
                          ▼
                     Throughput
                          │
                          ▼
                   Result Analysis
```

---

## Performance Results

At **20 dB SNR** with **8 users**:

### 16 BS Antennas

| Technique | SINR (dB) | Spectral Efficiency (bit/s/Hz) | Throughput (Mbps) |
|---|---:|---:|---:|
| MRT | 4.18 | 14.84 | 296.90 |
| ZF | 29.47 | 78.34 | 1566.79 |
| MMSE | 29.48 | 78.35 | 1567.02 |

### 32 BS Antennas

| Technique | SINR (dB) | Spectral Efficiency (bit/s/Hz) | Throughput (Mbps) |
|---|---:|---:|---:|
| MRT | 7.16 | 21.05 | 421.04 |
| ZF | 33.97 | 90.29 | 1805.86 |
| MMSE | 33.97 | 90.29 | 1805.89 |

### 64 BS Antennas

| Technique | SINR (dB) | Spectral Efficiency (bit/s/Hz) | Throughput (Mbps) |
|---|---:|---:|---:|
| MRT | 10.44 | 28.74 | 574.75 |
| ZF | 37.60 | 99.92 | 1998.33 |
| MMSE | 37.60 | 99.92 | 1998.34 |

---

## Key Observations

- Increasing the number of BS antennas improves the SINR and spectral efficiency.
- MRT provides lower interference suppression because it primarily maximizes signal gain.
- ZF significantly reduces multi-user interference.
- MMSE provides a balance between interference suppression and noise effects.
- ZF and MMSE significantly outperform MRT under the simulated conditions.
- At 64 BS antennas and 20 dB SNR, ZF and MMSE achieve approximately **99.92 bit/s/Hz** spectral efficiency.
- The ZF and MMSE results are nearly identical in this configuration because the system has 64 BS antennas for only 8 users and operates at relatively high SNR.

---

## Project Structure

```text
Massive_MIMO_Beamforming_SE_Analysis/
│
├── README.md
│
├── matlab/
│   │
│   ├── channel/
│   │   └── generate_mimo_channel.m
│   │
│   ├── beamforming/
│   │   ├── mrt_beamforming.m
│   │   ├── zf_beamforming.m
│   │   └── mmse_beamforming.m
│   │
│   ├── simulation/
│   │   └── massive_mimo_simulation.m
│   │
│   └── analysis/
│       └── plot_results.m
│
└── results/
    └── massive_mimo_results.mat
```

---

## MATLAB Implementation

### Channel Generation

```text
matlab/channel/generate_mimo_channel.m
```

Generates a complex Rayleigh fading channel for the selected number of BS antennas and users.

### MRT

```text
matlab/beamforming/mrt_beamforming.m
```

Implements Maximum Ratio Transmission and verifies the normalized beamforming vectors.

### ZF

```text
matlab/beamforming/zf_beamforming.m
```

Implements Zero-Forcing beamforming and evaluates residual multi-user interference.

### MMSE

```text
matlab/beamforming/mmse_beamforming.m
```

Implements MMSE beamforming using the noise-dependent regularization term.

### Main Simulation

```text
matlab/simulation/massive_mimo_simulation.m
```

Runs the complete simulation across:

- 16, 32, and 64 BS antennas
- 0–20 dB SNR
- 100 channel realizations
- MRT, ZF, and MMSE

The simulation calculates:

```text
SINR
Spectral Efficiency
Throughput
```

and saves the results to:

```text
results/massive_mimo_results.mat
```

### Result Analysis

```text
matlab/analysis/plot_results.m
```

Loads the saved simulation results and generates performance comparisons for:

- Spectral Efficiency vs SNR
- Throughput vs SNR
- SINR vs Number of BS Antennas
- Spectral Efficiency vs Number of BS Antennas

---

## How to Run

Open the project directory in MATLAB.

Run the channel-generation script:

```matlab
matlab/channel/generate_mimo_channel
```

Run the individual beamforming implementations:

```matlab
matlab/beamforming/mrt_beamforming
```

```matlab
matlab/beamforming/zf_beamforming
```

```matlab
matlab/beamforming/mmse_beamforming
```

Run the complete simulation:

```matlab
matlab/simulation/massive_mimo_simulation
```

After the simulation completes, run:

```matlab
matlab/analysis/plot_results
```

This loads the saved results and generates the performance analysis plots.

---

## Tools and Technologies

- MATLAB
- 5G Communication Systems
- Massive MIMO
- Digital Beamforming
- Linear Precoding
- Rayleigh Fading Channel
- SINR Analysis
- Spectral Efficiency Analysis
- Throughput Analysis

---

## Resume Description

**Massive MIMO Beamforming and Spectral Efficiency Analysis — MATLAB**

Simulated a multi-antenna 5G communication system and evaluated MRT, ZF, and MMSE beamforming techniques. Compared SINR, spectral efficiency, and throughput across different BS antenna configurations and SNR conditions using Rayleigh fading channel realizations.