#!/bin/bash

MYSUB=$1
MAINDIR=/Users/erin/Desktop/Projects/qfMRI_MS
DICOMDIR=${MAINDIR}/dicoms
SUBDIR=${DICOMDIR}/${MYSUB}
ANALYSISDIR=${MAINDIR}/analysis/${MYSUB}
SPMDIR=/Users/erin/Documents/MATLAB/spm12
SCRIPTSDIR=${MAINDIR}/scripts

myfiles=""
myresults=""

for e in e01 e02
do
for f in `ls -d ${ANALYSISDIR}/rCO2_O2.${e}.nii.gz` `ls -d ${ANALYSISDIR}/rmotor_run1.${e}.nii.gz` `ls -d ${ANALYSISDIR}/rmotor_run2.${e}.nii.gz`
do
	g=`basename $f .nii.gz`
	myfiles=`echo ${myfiles},${g}`
	fslmaths $f -Tmean ${ANALYSISDIR}/${g}_Tmean
	fslmaths $f -Tstd ${ANALYSISDIR}/${g}_Tstd
	fslmaths ${ANALYSISDIR}/${g}_Tmean -div ${ANALYSISDIR}/${g}_Tstd ${ANALYSISDIR}/${g}_Tsnr
	fsleyes ${ANALYSISDIR}/${g}_Tsnr &
	taskname_tmp=${g:1}
	taskname=`basename ${taskname_tmp} .${e}`
	result=`fslstats ${ANALYSISDIR}/${g}_Tsnr -k ${ANALYSISDIR}/mean${taskname}_brain_mask -M`
	myresults=`echo ${myresults},${result}`
done
done

for f in ${ANALYSISDIR}/rCO2_O2.e01.nii.gz ${ANALYSISDIR}/rmotor_run1.e01.nii.gz ${ANALYSISDIR}/rmotor_run2.e01.nii.gz
do
	g=`basename $f .nii.gz`
	myfiles=`echo ${myfiles},${g}_sub`
	perfusion_subtract $f ${ANALYSISDIR}/${g}_sub -m
	fsleyes ${ANALYSISDIR}/${g}_sub &
	fslmaths ${ANALYSISDIR}/${g}_sub -Tmean ${ANALYSISDIR}/${g}_sub_Tmean
	fslmaths ${ANALYSISDIR}/${g}_sub -Tstd ${ANALYSISDIR}/${g}_sub_Tstd
	fslmaths ${ANALYSISDIR}/${g}_sub_Tmean -div ${ANALYSISDIR}/${g}_sub_Tstd ${ANALYSISDIR}/${g}_sub_Tsnr
	fsleyes ${ANALYSISDIR}/${g}_sub_Tsnr &
	taskname_tmp=${g:1}
	taskname=`basename ${taskname_tmp} .e01`
	result=`fslstats ${ANALYSISDIR}/${g}_sub_Tsnr -k ${ANALYSISDIR}/mean${taskname}_brain_mask -M`
	myresults=`echo ${myresults},${result}`
done
echo $myfiles
echo $myresults	