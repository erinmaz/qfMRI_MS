#!/bin/tcsh
#call from a directory of dicoms for 1 epiRTmeasl run
#requires dicom_hinfo (from AFNI) and bet (from FSL) on your path
#EDIT THE scriptdir variable to point to your copy of epiRTmeasl_analysis
#$1 = output prefix for niftis created by niidicom2
#$2 = minTR in milliseconds
#example: run_preproc output_name 4197

set CWD = `pwd`
set nii_out = $1
set minTR = $2

set FWHM = 5
set scriptdir = ~/Desktop/Projects/qfMRI_MS/scripts
set alldirs = ${scriptdir}:/Users/erin/Documents/MATLAB/spm12:/Users/erin/Documents/MATLAB/spm12/toolbox/batch_scripts_pcasl
setenv MATLABPATH ${alldirs}

set dicomdir = `pwd`
 
niidicom2 ${nii_out}

cd ../medata
set mydir = `pwd`
set mydir2 = `echo \'$mydir\'`

matlab -nosplash -nodesktop -r "realign_smooth_WB(${mydir2},'${nii_out}*.nii',${FWHM}) ; quit"

cd $CWD