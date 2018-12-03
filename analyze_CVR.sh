#!/bin/bash

MYSUB=$1
MAINDIR=/Users/erin/Desktop/Projects/qfMRI_MS
ANALYSISDIR=${MAINDIR}/analysis/${MYSUB}
SCRIPTSDIR=${MAINDIR}/scripts

fslroi ${ANALYSISDIR}/rCO2_O2.e01 ${ANALYSISDIR}/rCO2.e01 0 102
fslroi ${ANALYSISDIR}/srCO2_O2.e01 ${ANALYSISDIR}/srCO2.e01 0 102
fslroi ${ANALYSISDIR}/rCO2_O2.e02 ${ANALYSISDIR}/rCO2.e02 0 102

perfusion_subtract ${ANALYSISDIR}/rCO2.e01 ${ANALYSISDIR}/rCO2.e01_sub -m
perfusion_subtract ${ANALYSISDIR}/srCO2.e01 ${ANALYSISDIR}/srCO2.e01_sub -m

sed 's/MYSUB/'${MYSUB}'/g' /Users/erin/Desktop/Projects/qfMRI_MS/scripts/template_rCO2.e01_CVR.fsf > /Users/erin/Desktop/Projects/qfMRI_MS/analysis/${MYSUB}/rCO2.e01_CVR.fsf 

sed 's/MYSUB/'${MYSUB}'/g' /Users/erin/Desktop/Projects/qfMRI_MS/scripts/template_srCO2.e01_CVR.fsf > /Users/erin/Desktop/Projects/qfMRI_MS/analysis/${MYSUB}/srCO2.e01_CVR.fsf 

sed 's/MYSUB/'${MYSUB}'/g' /Users/erin/Desktop/Projects/qfMRI_MS/scripts/template_rCO2.e02_CVR.fsf > /Users/erin/Desktop/Projects/qfMRI_MS/analysis/${MYSUB}/rCO2.e02_CVR.fsf 

feat /Users/erin/Desktop/Projects/qfMRI_MS/analysis/${MYSUB}/rCO2.e01_CVR.fsf &
feat /Users/erin/Desktop/Projects/qfMRI_MS/analysis/${MYSUB}/srCO2.e01_CVR.fsf &
feat /Users/erin/Desktop/Projects/qfMRI_MS/analysis/${MYSUB}/rCO2.e02_CVR.fsf 
