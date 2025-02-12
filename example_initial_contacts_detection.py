# -*- coding: utf-8 -*-
"""
Script for processing pre-processed mobility test data and evaluating initial contact events.

Author: Paolo Tasca (Politecnico di Torino)
Date: 11/01/2024
Version: 1.1
Email: paolo.tasca@polito.it
"""

# %% IMPORT PACKAGES
import logging
from pathlib import Path
import tf_keras as k3
from utils_.functions_ import *
from scipy.io import savemat

# %% SETUP LOGGING
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

# %% DATA LOADING
SUBJECT_ID = "0002"
DATA_DIR = Path("example_data")

# Load the trained model
MODEL_PATH = "Trained initial contacts model"
model = k3.models.load_model(MODEL_PATH, compile=False)

# Load dataset paths
processed_data_path = DATA_DIR / "preprocessed" / "data.mat"
original_data_path = DATA_DIR / "original" / SUBJECT_ID / "Mobility Test" / "Results" / "data.mat"

# Load datasets
dataset = load_mat_struct(processed_data_path, dataset_name="preProcessedData")
raw_dataset = load_mat_struct(original_data_path, dataset_name="data")

logging.info(f"Processing subject {SUBJECT_ID}...")

# %% MAIN PROCESSING LOOP
for test_name, test_data in dataset["TimeMeasure1"].items():  # e.g., 'Test3'
    for trial_name, trial_data in test_data.items():  # e.g., 'Trial1'
        logging.info(f"Processing {test_name} {trial_name}...")

        micro_walking_bouts = trial_data["Standards"]["INDIP"]["MicroWB"]

        if isinstance(micro_walking_bouts, dict):  # Single micro-walking bout
            micro_walking_bouts = [micro_walking_bouts]

        for i, mwb in enumerate(micro_walking_bouts):
            # Extract pre-processed windows
            x = mwb["dataset_p"]

            # Reshape dataset
            x, t = buildDataSet(x)

            # Evaluate initial contact events
            extra_events, missed_events, predicted_IC, target_IC = modelEvaluate(model, x, t)

            # Save results back into dataset
            mwb["ExtraEvents"] = extra_events
            mwb["MissedEvents"] = missed_events
            mwb["Predicted_Initial_Contact_Events"] = predicted_IC
            mwb["Target_Initial_Contact_Events"] = target_IC

# %% PLOT RESULTS
plot_first_mwb(dataset)

# %% EXPORT RESULTS TO .MAT FILE
SAVE_DIR = Path("TCN_outputs") / SUBJECT_ID
SAVE_DIR.mkdir(parents=True, exist_ok=True)
SAVE_PATH = SAVE_DIR / "results.mat"

savemat(SAVE_PATH, dataset, long_field_names=True, oned_as="column")

logging.info(f"Results saved to {SAVE_PATH}")
