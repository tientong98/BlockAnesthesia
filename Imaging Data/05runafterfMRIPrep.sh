#!/bin/bash

# run all the necessary steps after fMRIPrep, getting things ready for Feat

for sub in 20200206 8006 ; do

sh /Shared/rblock_mr/code/fmri01_aromaunsmooth_WMCSFts.sh -s ${sub}

/Shared/rblock_mr/code/fmri02_makeconfound.R -s ${sub}

done
