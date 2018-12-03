#!/bin/bash

MYSUB=$1
MAINDIR=/Users/erin/Desktop/Projects/qfMRI_MS
DICOMDIR=${MAINDIR}/dicoms
SUBDIR=${DICOMDIR}/${MYSUB}
ANALYSISDIR=${MAINDIR}/analysis/${MYSUB}
SPMDIR=/Users/erin/Documents/MATLAB/spm12
SCRIPTSDIR=${MAINDIR}/scripts
minTR=3480
minTR_WB=4025 # don't actually use this
TR=3.5

mkdir ${ANALYSISDIR}


###### DE-PCASL ##########################################################################
CWD=`pwd`

cd ${SUBDIR}/CO2_epiRTmeasl
${SCRIPTSDIR}/run_preproc.sh CO2_O2_raw ${minTR}

cd $CWD

mv ${SUBDIR}/medata/* ${ANALYSISDIR}/.
rm -r ${SUBDIR}/medata

#SPM is setting the TR to 1, need to set it back to the correct value
for f in ${ANALYSISDIR}/rCO2_O2_raw.e01 ${ANALYSISDIR}/rCO2_O2_raw.e02 
do
	fslchfiletype NIFTI_GZ ${f}
	fslmerge -tr ${f} ${f} ${TR}	

done

fsleyes ${ANALYSISDIR}/rCO2_O2_raw.e01 &
fsleyes ${ANALYSISDIR}/rCO2_O2_raw.e02 &
fsleyes ${ANALYSISDIR}/meanCBF_2_srCO2_O2_raw.e01 -dr 0 100 &


###### T1 ################################################################################
rm ${SUBDIR}/SAG_FSPGR_BRAVO_/*.nii*
dcm2niix ${SUBDIR}/SAG_FSPGR_BRAVO_
mv ${SUBDIR}/SAG_FSPGR_BRAVO_/*.nii.gz ${ANALYSISDIR}/T1_raw.nii.gz
fsleyes ${ANALYSISDIR}/T1_raw ${ANALYSISDIR}/spm_mask &

