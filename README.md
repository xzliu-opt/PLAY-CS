# PLAY-CS: A Unified Algorithmic Framework for Dynamic Compressive Sensing

This repository provides the implementation of the **PLAY-CS** algorithm for dynamic signal reconstruction. The algorithm is designed to recover sparse signals from compressed measurements and is particularly applied to synthetic channel datasets.

## Table of Contents
- [Overview](#overview)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Files](#files)
- [License](#license)
- [Contact](#contact)

## Overview

The **PLAY-CS** algorithm is used to recover sparse signals from compressed measurements. This repository includes:
- The main **PLAY-CS** algorithm implemented in MATLAB.
- A data generation function to create synthetic datasets.
- Example code to demonstrate the reconstruction performance.

### Paper Information
- **Title**: A Unified Algorithmic Framework for Dynamic Compressive Sensing
- **Authors**: Xiaozhi Liu, Yong Xia
- **Arxiv Link**: [https://arxiv.org/abs/2310.07202](https://arxiv.org/abs/2310.07202)

## Requirements

- MATLAB (version R2019b or later)
- Required MATLAB toolboxes:
  - **SPGL1** for sparse optimization (used for sparse basis pursuit)
- All dependencies are included within the `Algorithms` and `utils` directories.

## Installation

To get started, you need to clone this repository to your local machine.

```bash
git clone https://github.com/your-username/PLAY-CS.git
cd PLAY-CS
```

### Install Dependencies
Ensure that you have the required toolboxes and the SPGL1 solver for sparse reconstruction. SPGL1 can be downloaded from [here](https://friedlander.io/spgl1/).

Once you’ve cloned the repository, you can run the provided examples or modify them as needed.

## Usage

### 1. Data Generation
To generate synthetic data for testing, you can run the `gen_data` function, which creates synthetic signals and measurement matrices for a given signal dimension (`n`) and measurement dimension (`m`). The function also adds noise based on the specified signal-to-noise ratio (`sigma_m`).

Example:

```matlab
% Parameters
n = 32;  % Signal dimension
m = 24;  % Measurement dimension
sigma_m = 0.1;  % Noise variance

% Generate data
[A, y, x, D, seqlen] = gen_data(n, m, sigma_m);
```

### 2. Running the PLAY-CS Algorithm
To run the **PLAY-CS** algorithm on the generated synthetic data, call the `play_cs` function. This function estimates the sparse signal from the measurements.

Example:

```matlab
% Parameters
x0 = zeros(n,1);  % Initial guess for the signal
P0 = zeros(n,n);  % Initial guess for the covariance matrix
R = 100 * eye(m);  % Measurement noise covariance
Q = 3000 * eye(n);  % Signal covariance
T = 4;  % Number of subcarriers
alpha = 3.7;  % Threshold for support
a = 1;  % Regularization parameter
b = 100;  % Regularization parameter

% Run the algorithm
xhat = play_cs(A, y, x0, P0, R, Q, [], alpha, a, b);

% Evaluate the results
nmse = mean(norm(D * xhat - D * x) / norm(D * x));
fprintf('NMSE: %.3f\n', nmse);
```

### 3. Results
The algorithm will output the reconstructed signal `xhat` and the **Normalized Mean Squared Error (NMSE)**, which you can use to evaluate the performance of the reconstruction.

## Files

- **`main.m`**: Demo used to show the reconstruction performance of PLAY-CS on a synthetic channel dataset.
- **`play_cs.m`**: The main implementation of the PLAY-CS algorithm.
- **`gen_data.m`**: Function to generate synthetic data, including measurement matrices and noisy observations.
- **`data/`**: Synthetic data used for testing (e.g., `synthetic_data.mat`).

## Contact

For any questions or further information, please email **[xzliu@buaa.edu.cn](mailto:xzliu@buaa.edu.cn)**. You can also find more about my work on my [website](https://xzliu-opt.github.io/).
