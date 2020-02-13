#!/bin/bash
function Usage {
    cat <<USAGE
`basename $0` created a BOLD that is motion corrected, slice timing corrected, denoised non-aggressively with ICA_AROMA but NOT SMOOTHED, then extract average WM and CSF
Usage:
`basename $0`  -s subject_id
               -h <help>
Example:
  bash $0 -s 20200206
Arguments:
  -s subject_id  The subject id
  -h help
USAGE
    exit 1
}

# Parse input operators -------------------------------------------------------
while getopts "s:h" option
do
case "${option}"
in
  s) # subject_id
    subid=${OPTARG}
    ;;
  h) # help
    Usage >&2
    exit 0
    ;;
  *) # unknown options
    echo "ERROR: Unrecognized option -$OPT $OPTARG"
    exit 1
    ;;
esac
done

export FSLDIR="/Shared/pinc/sharedopt/apps/fsl/Linux/x86_64/5.0.8/"
. ${FSLDIR}/etc/fslconf/fsl.sh
export PATH=${PATH}:${FSLDIR}/bin
export PATH=$PATH:/Shared/pinc/sharedopt/apps/afni/Linux/x86_64/20.0.03

fmriprepdir=/Shared/rblock_mr/derivatives/fmriprep

# created a BOLD that is motion corrected, slice timing corrected, denoised non-aggressively with ICA_AROMA but NOT SMOOTHED

for sub in ${subid} ; do
  for task in rest sternberg hippo ; do
    fsl_regfilt -i $fmriprepdir/sub-${sub}/func/sub-${sub}_task-${task}_space-MNI152NLin6Asym_desc-preproc_bold.nii.gz \
      -f $(cat $fmriprepdir/sub-${sub}/func/sub-${sub}_task-${task}_AROMAnoiseICs.csv) \
      -d $fmriprepdir/sub-${sub}/func/sub-${sub}_task-${task}_desc-MELODIC_mixing.tsv \
      -o $fmriprepdir/sub-${sub}/func/sub-${sub}_task-${task}_space-MNI152NLin6Asym_desc-unsmoothAROMAnonaggr_bold.nii.gz
  done
done


for sub in ${subid} ; do

  # create WM and CSF rois with voxels that are >= 95% probabilty to be in WM/CSF

  fslmaths $fmriprepdir/sub-${sub}/anat/sub-${sub}_space-MNI152NLin6Asym_label-CSF_probseg.nii.gz \
        -thr 0.95 -bin \
        $fmriprepdir/sub-${sub}/anat/sub-${sub}_space-MNI152NLin6Asym_label-CSF_probseg95.nii.gz

  fslmaths $fmriprepdir/sub-${sub}/anat/sub-${sub}_space-MNI152NLin6Asym_label-WM_probseg.nii.gz \
        -thr 0.95 -bin \
         $fmriprepdir/sub-${sub}/anat/sub-${sub}_space-MNI152NLin6Asym_label-WM_probseg95.nii.gz

  # resample WM and CSF rois to non-aggressively denoised unsmoothed BOLD registered to MNI

  3dresample \
    -master $fmriprepdir/sub-${sub}/func/sub-${sub}_task-rest_space-MNI152NLin6Asym_desc-unsmoothAROMAnonaggr_bold.nii.gz \
    -prefix $fmriprepdir/sub-${sub}/anat/sub-${sub}_space-MNI152NLin6Asym_label-CSF_probseg95BOLD.nii.gz \
    -input $fmriprepdir/sub-${sub}/anat/sub-${sub}_space-MNI152NLin6Asym_label-CSF_probseg95.nii.gz

  3dresample \
    -master $fmriprepdir/sub-${sub}/func/sub-${sub}_task-rest_space-MNI152NLin6Asym_desc-unsmoothAROMAnonaggr_bold.nii.gz \
    -prefix $fmriprepdir/sub-${sub}/anat/sub-${sub}_space-MNI152NLin6Asym_label-WM_probseg95BOLD.nii.gz \
    -input $fmriprepdir/sub-${sub}/anat/sub-${sub}_space-MNI152NLin6Asym_label-WM_probseg95.nii.gz

done


# get WM and CSF time series from step 1

for sub in ${subid} ; do
  for task in rest sternberg hippo ; do
    3dmaskave \
      -mask $fmriprepdir/sub-${sub}/anat/sub-${sub}_space-MNI152NLin6Asym_label-CSF_probseg95BOLD.nii.gz \
      -quiet $fmriprepdir/sub-${sub}/func/sub-${sub}_task-${task}_space-MNI152NLin6Asym_desc-unsmoothAROMAnonaggr_bold.nii.gz \
       > $fmriprepdir/sub-${sub}/func/sub-${sub}_task-${task}_CSFts.txt

    3dmaskave \
      -mask $fmriprepdir/sub-${sub}/anat/sub-${sub}_space-MNI152NLin6Asym_label-WM_probseg95BOLD.nii.gz \
      -quiet $fmriprepdir/sub-${sub}/func/sub-${sub}_task-${task}_space-MNI152NLin6Asym_desc-unsmoothAROMAnonaggr_bold.nii.gz \
       > $fmriprepdir/sub-${sub}/func/sub-${sub}_task-${task}_WMts.txt
  done
done
