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

cd ${SUBDIR}/PU_CO2_epiRTmeasl_
${SCRIPTSDIR}/run_preproc.sh CO2_O2 ${minTR}

# use a separate script for this one because 1) spm_realign_asl fails for only two volumes and 2) we don't need to calculate CBF for this run
# WB data were not acquired for all participants
if [ -e ${SUBDIR}/PU_WB_epiRTmeasl ]; then
cd ${SUBDIR}/PU_WB_epiRTmeasl
${SCRIPTSDIR}/run_preproc_WB.sh WB
fi

cd ${SUBDIR}/PU_epiRTmeasl_motor_run1
${SCRIPTSDIR}/run_preproc.sh motor_run1 ${minTR}

cd ${SUBDIR}/PU_epiRTmeasl_motor_run2
${SCRIPTSDIR}/run_preproc.sh motor_run2 ${minTR}

cd $CWD

mv ${SUBDIR}/medata/* ${ANALYSISDIR}/.
rm -r ${SUBDIR}/medata

#SPM is setting the TR to 1, need to set it back to the correct value
for f in `ls -d ${ANALYSISDIR}/*e0*.nii*`
do
	fslchfiletype NIFTI_GZ ${f}
	fslmerge -tr ${f} ${f} ${TR}	
done

for f in `ls -d ${ANALYSISDIR}/r*e0*.nii.gz`
do
	fsleyes $f &
done 

for f in `ls ${ANALYSISDIR}/meanCBF*.nii.gz`
do
	fsleyes $f -dr 0 100 &
done 


###### T1 ################################################################################
rm ${SUBDIR}/PU*BRAVO*/*.nii*
dcm2niix ${SUBDIR}/PU*BRAVO*
mv ${SUBDIR}/PU*BRAVO*/*.nii.gz ${ANALYSISDIR}/T1.nii.gz
fslchfiletype NIFTI ${ANALYSISDIR}/T1
export MATLABPATH="${SPMDIR}:${SCRIPTSDIR}"
nice matlab -nosplash -nodesktop -r "segment_job({'${ANALYSISDIR}/T1.nii,1'}) ; quit"
fslchfiletype NIFTI_GZ ${ANALYSISDIR}/T1
fslmaths ${ANALYSISDIR}/c1T1 -add ${ANALYSISDIR}/c2T1 -add ${ANALYSISDIR}/c3T1 -bin -fillh ${ANALYSISDIR}/spm_mask
fslmaths ${ANALYSISDIR}/T1 -mas ${ANALYSISDIR}/spm_mask ${ANALYSISDIR}/T1_brain
fsleyes ${ANALYSISDIR}/T1 ${ANALYSISDIR}/spm_mask &


###### FLAIR #############################################################################	
rm ${SUBDIR}/FL_B_PU_Sag_CUBE_FLAIR_1_x_1.5_x_1.5/*.nii*
dcm2niix ${SUBDIR}/FL_B_PU_Sag_CUBE_FLAIR_1_x_1.5_x_1.5
mv ${SUBDIR}/FL_B_PU_Sag_CUBE_FLAIR_1_x_1.5_x_1.5/*.nii.gz ${ANALYSISDIR}/FLAIR.nii.gz
fsleyes ${ANALYSISDIR}/FLAIR.nii.gz &



###### eASL ##############################################################################
rm ${SUBDIR}/eASL__Transit-corrected_Flow/*.nii*
dcm2niix ${SUBDIR}/eASL__Transit-corrected_Flow
mv ${SUBDIR}/eASL__Transit-corrected_Flow/*.nii.gz ${ANALYSISDIR}/eASL_transit_corrected_flow.nii.gz
	
rm ${SUBDIR}/eASL__Transit_delay_/*.nii*
dcm2niix ${SUBDIR}/eASL__Transit_delay_
mv ${SUBDIR}/eASL__Transit_delay_/*.nii.gz ${ANALYSISDIR}/eASL_transit_delay.nii.gz

fsleyes ${ANALYSISDIR}/eASL_transit_corrected_flow.nii.gz -dr 0 100 ${ANALYSISDIR}/eASL_transit_delay.nii.gz &


