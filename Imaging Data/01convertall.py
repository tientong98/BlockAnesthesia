import os


def create_key(template, outtype=('nii.gz',), annotation_classes=None):
    if template is None or not template:
        raise ValueError('Template must be a valid format string')
    return template, outtype, annotation_classes


def infotodict(seqinfo):
    """Heuristic evaluator for determining which runs belong where

    allowed template fields - follow python string module:

    item: index within category
    subject: participant id
    seqitem: run number during scanning
    subindex: sub index within group
    """

    rest = create_key('sub-{subject}/func/sub-{subject}_task-rest_bold')
    sternberg = create_key('sub-{subject}/func/sub-{subject}_task-sternberg_bold')
    hippo = create_key('sub-{subject}/func/sub-{subject}_task-hippo_bold')
    t1w = create_key('sub-{subject}/anat/sub-{subject}_T1w')
    t2w = create_key('sub-{subject}/anat/sub-{subject}_T2w')
    dwi_b1800 = create_key('sub-{subject}/dwi/sub-{subject}_acq-b1800_dwi')
    dwi_b1000 = create_key('sub-{subject}/dwi/sub-{subject}_acq-b1000_dwi')

    info = {
            rest: [],
            sternberg: [],
            hippo: [],
            t1w: [],
            t2w: [],
            dwi_b1800: [],
            dwi_b1000: [],
            }

    for s in seqinfo:
        """
        The namedtuple `s` contains the following fields:

        * total_files_till_now
        * example_dcm_file
        * series_id
        * dcm_dir_name
        * unspecified2
        * unspecified3
        * dim1
        * dim2
        * dim3
        * dim4
        * TR
        * TE
        * protocol_name
        * is_motion_corrected
        * is_derived
        * patient_id
        * study_description
        * referring_physician_name
        * series_description
        * image_type
        """

        if (s.series_description == 'REST STATE') :
            info[rest] = [s.series_id]
        if (s.series_description == 'STERNBERG TASK') :
            info[sternberg].append(s.series_id)
        if (s.series_description == 'HIPPO TASK') :
            info[hippo] = [s.series_id]
        if (s.series_description == 'COR_MPRAGE_PROMO') :
            info[t1w] = [s.series_id]
        if (s.series_description == 'COR_CUBE_T2_PROMO') :
            info[t2w] = [s.series_id]
        if (s.series_description == 'DKI b=1800 60 Dir MB') :
            info[dwi_b1800] = [s.series_id]
        if (s.series_description == 'DKI b=1000 60 Dir MB') :
            info[dwi_b1000] = [s.series_id]

    return info
