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
set file1 = `find $dicomdir -type f | head -1` 
set ldtmp = `dicom_hinfo -tag 0019,10b0 $file1`
set ld = $ldtmp[2]
set titmp = `dicom_hinfo -tag 0019,10ad $file1`
set ti = $titmp[2]
set pld = `echo $ti $ld | awk '{print $1 - $2}'`
set te1tmp = `dicom_hinfo -tag 0018,0081 $file1`
set te1 = $te1tmp[2]

set sltot = `dicom_hinfo -tag 0020,1002 $file1 | awk '{print $2}'`
@ sln = $sltot / 2
 
niidicom2 ${nii_out}

cd ../medata
set mydir = `pwd`
set mydir2 = `echo \'$mydir\'`

matlab -nosplash -nodesktop -r "asltbx_inputparams(${mydir2},'${nii_out}*.nii','e01',${ld},${pld},${te1},${minTR},${sln},${FWHM}) ; quit"

cd $CWD