The folder has code for analyzing brain imaging data. The steps are detailed below:

**1.** Convert data structure to BIDS using Heudiconv `01heudiconv.ipynb`, the study-specific heuristic file is `01convertall.py`

**2.** Run MRIQC `02MRIQC.ipynb`

**3.** Exclude the first TRs `03exclude_first_TRs.sh`

https://github.com/poldracklab/fmriprep/issues/1136

In this post, people discussed that excluding those dummy TRs BEFORE running fmriprep have different results (functional connectivity maps) than when you run fmriprep  --> then truncate --> then run GLM. Chris then bought up the steady state detection feature, and if that works well, then they (fmriprep people) don't have to have a new feature (i.e., specify dummy TRs before running fmriprep). 

From James Kent:

If the dummy scans were not already removed, then I think the most prudent action currently is to remove the TRs from the datasets prior to analysis with fmriprep and adjust the events.tsvs accordingly.

if you go the remove TRs route, just mark in the task json files with the key NumberOfVolumesDiscardedByUser where the value is the number of volumes you have discarded.

**4.** Getting the timing files ready for FEAT. `04BIDSto3col-allsub_hippo.sh` and `04BIDSto3col-allsub_sternberg.sh` will execute `04BIDSto3col-singlesub.sh`, so that event timing files in BIDS format (created by [this script](https://github.com/tientong98/BlockAnesthesia/blob/master/Behavioral%20Data/eventtiming.R)) will be converted to the 3 columns format for FSL.

**5.** The [start_to_finish.ipynb](https://github.com/tientong98/BlockAnesthesia/blob/master/Imaging%20Data/start_to_finish.ipynb) has the step-by-step fMRI pipeline:
  * Add Slice timing information and exclude dummy TRs 
  * Run fMRIPrep
  * Run first and second level analysis with FEAT

**6.** Use nilearn to plot the stat maps to send to collaborators using `statmap_nilearn.ipynb`
