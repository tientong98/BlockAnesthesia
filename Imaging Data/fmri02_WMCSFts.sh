#!/bin/bash

source ~/sourcefiles/fsl_source.sh
source ~/sourcefiles/afni_source.sh

fmriprepdir=/Shared/rblock_mr/derivatives/fmriprep

#sub=(8006 8019 8022 8028 8031 8036 8041 8050 8054 8058 8060 8016 8021 8025 8030 8034 8049 8052 8056 8059 8061)
sub=(8024 8045 8070)

for n in 0 1 2 ; do

# create WM and CSF rois with voxels that are >= 95% probabilty to be in WM/CSF

fslmaths $fmriprepdir/sub-${sub[$n]}/anat/sub-${sub[$n]}_space-MNI152NLin6Asym_label-CSF_probseg.nii.gz -thr 0.95 -bin $fmriprepdir/sub-${sub[$n]}/anat/sub-${sub[$n]}_space-MNI152NLin6Asym_label-CSF_probseg95.nii.gz

fslmaths $fmriprepdir/sub-${sub[$n]}/anat/sub-${sub[$n]}_space-MNI152NLin6Asym_label-WM_probseg.nii.gz -thr 0.95 -bin $fmriprepdir/sub-${sub[$n]}/anat/sub-${sub[$n]}_space-MNI152NLin6Asym_label-WM_probseg95.nii.gz

# resample WM and CSF rois to non-aggressively denoised unsmoothed BOLD registered to MNI

3dresample -master $fmriprepdir/sub-${sub[$n]}/func/sub-${sub[$n]}_task-rest_space-MNI152NLin6Asym_desc-unsmoothAROMAnonaggr_bold.nii.gz -prefix $fmriprepdir/sub-${sub[$n]}/anat/sub-${sub[$n]}_space-MNI152NLin6Asym_label-CSF_probseg95BOLD.nii.gz -input $fmriprepdir/sub-${sub[$n]}/anat/sub-${sub[$n]}_space-MNI152NLin6Asym_label-CSF_probseg95.nii.gz

3dresample -master $fmriprepdir/sub-${sub[$n]}/func/sub-${sub[$n]}_task-rest_space-MNI152NLin6Asym_desc-unsmoothAROMAnonaggr_bold.nii.gz -prefix $fmriprepdir/sub-${sub[$n]}/anat/sub-${sub[$n]}_space-MNI152NLin6Asym_label-WM_probseg95BOLD.nii.gz -input $fmriprepdir/sub-${sub[$n]}/anat/sub-${sub[$n]}_space-MNI152NLin6Asym_label-WM_probseg95.nii.gz

for task in rest sternberg hippo ; do

# get WM and CSF time series

3dmaskave -mask $fmriprepdir/sub-${sub[$n]}/anat/sub-${sub[$n]}_space-MNI152NLin6Asym_label-CSF_probseg95BOLD.nii.gz -quiet $fmriprepdir/sub-${sub[$n]}/func/sub-${sub[$n]}_task-${task}_space-MNI152NLin6Asym_desc-unsmoothAROMAnonaggr_bold.nii.gz > $fmriprepdir/sub-${sub[$n]}/func/sub-${sub[$n]}_task-${task}_CSFts.txt

3dmaskave -mask $fmriprepdir/sub-${sub[$n]}/anat/sub-${sub[$n]}_space-MNI152NLin6Asym_label-WM_probseg95BOLD.nii.gz -quiet $fmriprepdir/sub-${sub[$n]}/func/sub-${sub[$n]}_task-${task}_space-MNI152NLin6Asym_desc-unsmoothAROMAnonaggr_bold.nii.gz > $fmriprepdir/sub-${sub[$n]}/func/sub-${sub[$n]}_task-${task}_WMts.txt

   
done
done
