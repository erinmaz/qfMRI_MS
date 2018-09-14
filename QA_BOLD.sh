#!/bin/bash

MYSUB=$1
MAINDIR=/Users/erin/Desktop/Projects/qfMRI_MS
DICOMDIR=${MAINDIR}/dicoms
SUBDIR=${DICOMDIR}/${MYSUB}
ANALYSISDIR=${MAINDIR}/analysis/${MYSUB}
SPMDIR=/Users/erin/Documents/MATLAB/spm12
SCRIPTSDIR=${MAINDIR}/scripts


###### T1 ################################################################################
rm ${SUBDIR}/SAG_FSPGR_BRAVO_/*.nii*
dcm2niix ${SUBDIR}/SAG_FSPGR_BRAVO_
mv ${SUBDIR}/SAG_FSPGR_BRAVO_/*.nii.gz ${ANALYSISDIR}/T1_raw.nii.gz
fsleyes ${ANALYSISDIR}/T1_raw.nii.gz &


###### BOLD ##############################################################################
rm ${SUBDIR}/BOLD/*.nii*
dcm2niix ${SUBDIR}/BOLD
mv ${SUBDIR}/BOLD/*.nii.gz ${ANALYSISDIR}/BOLD_raw.nii.gz
fsleyes ${ANALYSISDIR}/BOLD_raw &

fslmaths ${ANALYSISDIR}/BOLD_raw -Tmean ${ANALYSISDIR}/BOLD_raw_Tmean
fslmaths ${ANALYSISDIR}/BOLD_raw -Tstd ${ANALYSISDIR}/BOLD_raw_Tstd
fslmaths ${ANALYSISDIR}/BOLD_raw_Tmean -div ${ANALYSISDIR}/BOLD_raw_Tstd ${ANALYSISDIR}/BOLD_raw_Tsnr
fsleyes ${ANALYSISDIR}/BOLD_raw_Tsnr &

nslices=`fslinfo ${ANALYSISDIR}/BOLD_raw | grep -w "dim3" | awk '{print $2}'`
file1=`find ${SUBDIR}/BOLD -type f | head -1` 
tr=`dicom_hinfo -tag 0018,0080 $file1 | awk '{print $2}'`

echo $MYSUB,$nslices,$tr
