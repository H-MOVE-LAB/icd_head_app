# -*- coding: utf-8 -*-
"""

@author: Paolo Tasca 
@date: 11/01/2024
@version: 1.0
@mail: paolo.tasca@polito.it
"""
                                                                               
# %% IMPORT PACKAGES
import os
from scipy.io import savemat
import keras
from utils_.functions_ import *
# %% DATA LOADING
# get current directory
subj_dir = '0002'
# load the model
model = keras.models.load_model('MyModel6',compile= False)
# load data
processed_data_path = os.path.join('example_data','preprocessed','data.mat')
original_data_path = os.path.join('example_data','original',subj_dir,'Mobility Test','Results','data.mat')

dataset = load_mat_struct(processed_data_path, dataset_name = "pre_processed_data") # load processed dataset
raw_dataset = load_mat_struct(original_data_path, dataset_name = "data")
# main loop
print('Processing subject',subj_dir,'...')
for iTest in list(dataset["TimeMeasure1"].keys()): # e.g. 'Test3'
    for iTrial in list(dataset["TimeMeasure1"][iTest].keys()): # e.g. 'Trial1'
        print('Processing',iTest,iTrial)
        data = dataset["TimeMeasure1"][iTest][iTrial]["Standards"]["INDIP"]["MicroWB"]
        if type(data) is dict:
            mWB = data
            # pre-processed windows during current mWB
            x = mWB["dataset_p"]
            # reshape dataset
            x, t = buildDataSet(x)
            # evaluation of extra ICs, missed ICs, time errors, predicted ICs and target ICs for each mWB
            ExtraEvents, MissedEvents, Predicted_Initial_Contact_Events, Target_Initial_Contact_Events = modelEvaluate(model,x,t)
            # saving into dict
            dataset["TimeMeasure1"][iTest][iTrial]["Standards"]["INDIP"]["MicroWB"]["ExtraEvents"] = ExtraEvents
            dataset["TimeMeasure1"][iTest][iTrial]["Standards"]["INDIP"]["MicroWB"]["MissedEvents"] = MissedEvents
            dataset["TimeMeasure1"][iTest][iTrial]["Standards"]["INDIP"]["MicroWB"]["Predicted_Initial_Contact_Events"] = Predicted_Initial_Contact_Events
            dataset["TimeMeasure1"][iTest][iTrial]["Standards"]["INDIP"]["MicroWB"]["Target_Initial_Contact_Events"] = Target_Initial_Contact_Events
        else:
            for mWBi in range(len(data)):
                mWB = data[mWBi]
                # processed windows during current mWB
                x = mWB.dataset_p
                # reshape dataset
                x, t = buildDataSet(x)
                # evaluation of extra ICs, missed ICs, time errors, predicted ICs and target ICs for each mWB
                ExtraEvents, MissedEvents, Predicted_Initial_Contact_Events, Target_Initial_Contact_Events = modelEvaluate(model,x,t)
                # saving into dict
                dataset["TimeMeasure1"][iTest][iTrial]["Standards"]["INDIP"]["MicroWB"][mWBi].ExtraEvents = ExtraEvents
                dataset["TimeMeasure1"][iTest][iTrial]["Standards"]["INDIP"]["MicroWB"][mWBi].MissedEvents = MissedEvents
                dataset["TimeMeasure1"][iTest][iTrial]["Standards"]["INDIP"]["MicroWB"][mWBi].Predicted_Initial_Contact_Events = Predicted_Initial_Contact_Events
                dataset["TimeMeasure1"][iTest][iTrial]["Standards"]["INDIP"]["MicroWB"][mWBi].Target_Initial_Contact_Events = Target_Initial_Contact_Events
# %% VIEW predicted and target initial contacts for the mWB
plot_first_mwb(dataset)

# %% Export dataset as .mat file (Uncomment to save)
# save_path = os.path.join('outputs',subj_dir)
# savemat(save_path, dataset, long_field_names = True, oned_as='column')
