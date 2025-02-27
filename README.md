# `HeadGait` - Deep and Machine Learning Models for Initial Contacts Detection and Gait Speed Estimation with a Head-Worn Inertial Measurement Unit
![TOWalk illustration](utils_/README_figures/TOWalk_illustration.png "TOWalk illustration")

Welcome to the `HeadGait` repository! This repository contains a basic example of a Matlab-Python application for the detection of initial contacts and the estimation of gait speed from acceleration and angular velocity data recorded by a Head-worn Inertial Measurement Unit (H-IMU). Raw data is preprocessed in Matlab, then initial contacts are detected by a Temporal Convolutional Network (TCN) trained with over 100.000 gait cyles in both structured and real-world conditions. Finally, gait speed is inferred by a trained Gaussian Process Regression (GPR) model fed with nine time-domain features extracted from the previously segmented gait cycles. 

The study design and the procedures for data collection, model training, optimization and evaluation are described in the work <b>"Estimating Gait Speed in the Real World with a Head-Worn Inertial Sensor"</b> by Tasca et al. (2025) published in <i>IEEE Transactions on Neural Systems and Rehabilitation Engineering</i> <a href="#1">[1]</a>.

## Requirements

Ensure you have the following dependencies installed before running the application:

- **Matlab:** MATLAB R2022a or later.
- **Python:** Python 3.12, with the required libraries listed in `requirements.txt`.

## Installation in Windows

Clone the repository to your local machine :

```bash
git clone https://github.com/H-MOVE-LAB/headgait.git
```

(Optional) We recommend creating a virtual environment with the required modules (example: `venv_headgait`) : 

```bash
python -m venv venv_headgait
venv_headgait\Scripts\activate     
pip install -r requirements.txt
```

## Run `HeadGait` examples

Now, everything is set for you to start and play around!

1. **Matlab Pre-processing:**
   - Open the `preprocessing.m` script in Matlab. Be sure that `headgait\` is the current folder.
   - Run the script to perform pre-processing on the example raw data. This include filtering, scaling and windowing.
   - Verify that pre-processed data is correctly saved in location `example_data\preprocessed\data.mat`.
   
2. **Initial Contacts Detection:**
   - Open `headgait\` as a project in your IDE (suggested: PyCharm).
   - Open the `example_initial_contacts_detection.py` script in a Python environment.
   - Run the script to make inference on the pre-processed data and measure detection performance.
![ICs detection results on a trial of indoor walking.](utils_/README_figures/detected_ics.png "ICs detection results on a trial of indoor walking.")

3. **Gait Speed Estimation:**
   - Open `example_gait_speed_estimation.m` in Matlab and set `headgait\` as the current folder.
   - Run the script to make inference on the data segmented using the previously detected initial contacts and estimate gait speed.
![Target and predicted gait speed for one participant.](utils_/README_figures/gait_speed_line.png "Target and predicted gait speed for one participant.")

## Example Data

Example raw data is provided in the `example_data\` directory. Use this data to familiarize yourself with the application's workflow and as a reference for running the pre-processing and inference scripts. The full dataset [TO-Walk](https://dx.doi.org/10.21227/z3g5-nk54) is available on IEEE DataPort.


## Citing `HeadGait`

If you are using mobgap in your research or work, we would like to ask you to mention the library in your publications.
For papers, we recommend citing the library using the following reference:

```
Tasca, P. HeadGait - Deep and Machine Learning Models for Initial Contacts Detection and Gait Speed Estimation with a Head-Worn Inertial Measurement Unit (Version 1.0.0) [Computer software]. https://doi.org/10.3390/s23146565
```

```
@software{Tasca_HeadGait_-_Deep,
author = {Tasca, Paolo},
doi = {10.3390/s23146565},
title = {{HeadGait - Deep and Machine Learning Models for Initial Contacts Detection and Gait Speed Estimation with a Head-Worn Inertial Measurement Unit}},
url = {https://github.com/H-MOVE-LAB/headgait},
version = {1.0.0}
}
```
Additionally, please also cite the corresponding paper:

<a id="1">[1]</a> 
P. Tasca, F. Salis, S. Rosati, G. Balestra, C. Mazzà, A. Cereatti, 
*Estimating Gait Speed in the Real World with a Head-Worn Inertial Sensor*,
IEEE Transactions in Neural Systems and Rehabiliation Engineering, 
February 14, 2025.
[10.1109/TNSRE.2025.3542568](https://doi.org/10.1109/TNSRE.2025.3542568) <br><br>


## Other works featuring `HeadGait`

<a id="2">[2]</a> 
P. Tasca, F. Salis, A. Cereatti, 
*Real-world gait detection with a head-worn inertial unit and features-based machine learning*,
Gait & Posture, 
October, 2024.
[https://doi.org/10.1016/j.gaitpost.2024.08.068](https://doi.org/10.1016/j.gaitpost.2024.08.068) <br><br>
<a id="3">[3]</a> 
P. Tasca, F. Salis, S. Rosati, G. Balestra, A. Cereatti,
*A machine learning-based pipeline for stride speed estimation with a head-worn inertial sensor*,
Gait & Posture,
Volume 105, Supplement 1,
2023,
Pages S47-S48,
ISSN 0966-6362,
[https://doi.org/10.1016/j.gaitpost.2023.07.341.](https://doi.org/10.1016/j.gaitpost.2023.07.341.) <br><br>
<a id="4">[4]</a> 
P. Tasca,
*A machine learning approach to spatio-temporal gait analysis based on a head-mounted inertial sensor*,
Supervisors: Andrea Cereatti, Gabriella Balestra, Samanta Rosati, Francesca Salis. Politecnico di Torino, 2022
[https://webthesis.biblio.polito.it/25348/](https://webthesis.biblio.polito.it/25348/) <br><br>

## Acknowledgements
The code for the TCN training, optimization and evaluation is based on [my-gait-events-tcn](https://github.com/rmndrs89/my-gait-events-tcn.git) <a href="#5">[5]</a>. Ground truth data was provided by the INDIP reference system, described in <a href="#6">[6]</a>.


<a id="5">[5]</a>
R. Romijnders, F. Salis, C. Hansen, A. Küderle, A. Paraschiv-Ionescu, A. Cereatti, W. Maetzler *et al.*, *Ecological validity of a deep learning algorithm to detect gait events from real-life walking bouts in mobility-limiting diseases*, Frontiers in Neurology, 2023, [10.3389/fneur.2023.1247532. ](10.3389/fneur.2023.1247532. ) <br><br>
<a id="6">[6]</a>
Salis F, Bertuletti S, Bonci T, Caruso M, Scott K, Alcock L, Buckley E, *et al.*, *A multi-sensor wearable system for the assessment of diseased gait in real-world conditions.*, Frontiers in Bioengineering, 2023, [10.3389/fbioe.2023.1143248](10.3389/fbioe.2023.1143248) <br><br>



<!--## License

This project is licensed under the [MIT License](LICENSE).-->

Feel free to reach out if you have any questions or encounter issues while using the application.

Happy analyzing!

[![H-MOVE-LAB](utils_/hmovelab_logo.jpg)](https://github.com/H-MOVE-LAB)



