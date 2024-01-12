# icd_head_app: Initial Contact Detection for Head Motion Using Temporal Convolutional Networks

Welcome to the icd_head repository! This repository contains an example of Python application for the estimation of initial contacts from acceleration and angular velocity data recorded by a Head Inertial Measurement Unit (H-IMU). Inference is performed by a Temporal Convolutional Network (TCN) trained with over 100.000 gait cyles in both structured and real-world conditions!

## Overview

The provided application is ready-to-run, requiring minimal setup. The process involves two main steps:

1. **Matlab Pre-processing:**
   - Run the `main.m` script in Matlab to perform pre-processing on example raw data.
   - This step prepares the data for input into the Temporal Convolutional Network.

2. **Python Inference:**
   - After pre-processing, run the Python script to make the TCN infer initial contacts.
   - The relevant Python script is provided for seamless integration with the processed data.

## Prerequisites

Ensure you have the following dependencies installed before running the application:

- **Matlab:** MATLAB R2019a or later.
- **Python:** Python 3.11 or later, with the required libraries listed in `requirements.txt`.

## Usage

Clone the repository to your local machine:

```bash
git clone https://github.com/H-MOVE-LAB/icd_head.git
```

Once cloned, everything is set for you to start and play around!

1. **Matlab Pre-processing:**
   - Open the `main.m` script in Matlab and set `icd_head_app\` as the current folder.
   - Run the script to perform pre-processing on the example raw data. This include filtering, scaling and windowing.
   - Verify that pre-processed data is correctly saved in location `example_data\preprocessed\data.mat`.
   
2. **Python Inference:**
   - Open `icd_head_app\` as a project in your IDE (suggested: PyCharm).
   - Open the `main.py` script in a Python environment.
   - Run the script to make inference on the pre-processed data and measure detection performance.

## Example Data

Example raw data is provided in the `example_data` directory. Use this data to familiarize yourself with the application's workflow and as a reference for running the pre-processing and inference scripts.

## Acknowledgments

This application was developed by the H-MOVE-LAB for human motion analysis. If you find this tool useful, consider citing our work or providing feedback to help us improve.

## License

This project is licensed under the [MIT License](LICENSE).

Feel free to reach out if you have any questions or encounter issues while using the application.

Happy analyzing!

[![H-MOVE-LAB](utils_\hmovelab_logo.jpg)](https://github.com/H-MOVE-LAB)

