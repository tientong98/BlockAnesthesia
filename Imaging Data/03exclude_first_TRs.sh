#!/bin/bash

source ~/sourcefiles/afni_source.sh

bidsdir=/Shared/rblock_mr/rawdata/

sub=(8062)

for n in 0 ; do

################################################################
#################### rest remove 5TR = 10s ####################

      cd $bidsdir/sub-${sub[$n]}/func
      3dcalc -a sub-${sub[$n]}_task-rest_bold.nii.gz'[5..239]' \
             -exp '(a)' -prefix sub-${sub[$n]}_task-rest_bold_new.nii.gz
      rm -rf sub-${sub[$n]}_task-rest_bold.nii.gz
      mv sub-${sub[$n]}_task-rest_bold_new.nii.gz sub-${sub[$n]}_task-rest_bold.nii.gz

################################################################
#################### sternberg remove 3TR = 6s #################

      cd $bidsdir/sub-${sub[$n]}/func
      3dcalc -a sub-${sub[$n]}_task-sternberg_bold.nii.gz'[3..332]' \
             -exp '(a)' -prefix sub-${sub[$n]}_task-sternberg_bold_new.nii.gz
      rm -rf sub-${sub[$n]}_task-sternberg_bold.nii.gz
      mv sub-${sub[$n]}_task-sternberg_bold_new.nii.gz sub-${sub[$n]}_task-sternberg_bold.nii.gz

##################################################################
#################### hippocampus remove 3TR = 6s  ################

      cd $bidsdir/sub-${sub[$n]}/func
      3dcalc -a sub-${sub[$n]}_task-hippo_bold.nii.gz'[3..332]' \
             -exp '(a)' -prefix sub-${sub[$n]}_task-hippo_bold_new.nii.gz
      rm -rf sub-${sub[$n]}_task-hippo_bold.nii.gz
      mv sub-${sub[$n]}_task-hippo_bold_new.nii.gz sub-${sub[$n]}_task-hippo_bold.nii.gz

done
