#!/bin/bash

source ~/sourcefiles/fsl_source.sh

fmriprepdir=/Shared/rblock_mr/derivatives/fmriprep

#sub=(8006 8019 8022 8028 8031 8036 8041 8050 8054 8058 8060 8016 8021 8025 8030 8034 8049 8052 8056 8059 8061)
sub=(8024 8045 8070)

for n in 0 1 2 ; do
for task in rest sternberg hippo ; do


fsl_regfilt -i $fmriprepdir/sub-${sub[$n]}/func/sub-${sub[$n]}_task-${task}_space-MNI152NLin6Asym_desc-preproc_bold.nii.gz \
    -f $(cat $fmriprepdir/sub-${sub[$n]}/func/sub-${sub[$n]}_task-${task}_AROMAnoiseICs.csv) \
    -d $fmriprepdir/sub-${sub[$n]}/func/sub-${sub[$n]}_task-${task}_desc-MELODIC_mixing.tsv \
    -o $fmriprepdir/sub-${sub[$n]}/func/sub-${sub[$n]}_task-${task}_space-MNI152NLin6Asym_desc-unsmoothAROMAnonaggr_bold.nii.gz


done
done
