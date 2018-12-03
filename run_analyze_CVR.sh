#!/bin/bash

#Subjects with unique timings, see https://docs.google.com/spreadsheets/d/1OScnl0fbfhZ_VrQzXVfV7oBRgmAZxN8pyopPw1H0r_w/edit?usp=sharing
SCRIPTSDIR=/Users/erin/Desktop/Projects/qfMRI_MS/scripts
echo 124 120 1 > /Users/erin/Desktop/Projects/qfMRI_MS/analysis/qfmri_02_001/CO2_6min.txt 
echo 148 120 1 > /Users/erin/Desktop/Projects/qfMRI_MS/analysis/qfmri_02_005/CO2_6min.txt 
echo 130 144 1 > /Users/erin/Desktop/Projects/qfMRI_MS/analysis/qfmri_02_006/CO2_6min.txt 

for MYSUB in qfmri_01_006 qfmri_01_013 qfmri_02_003 qfmri_02_009 qfmri_01_001 qfmri_01_007 qfmri_01_014 qfmri_02_004 qfmri_02_010 qfmri_01_002 qfmri_01_008 qfmri_01_015 qfmri_02_011 qfmri_01_003 qfmri_01_009 qfmri_01_016 qfmri_02_012 qfmri_01_004 qfmri_01_011 qfmri_02_007 qfmri_02_014 qfmri_01_005 qfmri_01_012 qfmri_02_002 qfmri_02_008 qfmri_02_015
do 
  cp /Users/erin/Desktop/Projects/qfMRI_MS/scripts/CO2_6min.txt /Users/erin/Desktop/Projects/qfMRI_MS/analysis/${MYSUB}/.
done

for MYSUB in qfmri_01_006 qfmri_01_013 qfmri_02_003 qfmri_02_009 qfmri_01_001 qfmri_01_007 qfmri_01_014 qfmri_02_004 qfmri_02_010 qfmri_01_002 qfmri_01_008 qfmri_01_015 qfmri_02_011 qfmri_01_003 qfmri_01_009 qfmri_01_016 qfmri_02_012 qfmri_01_004 qfmri_01_011 qfmri_02_007 qfmri_02_014 qfmri_01_005 qfmri_01_012 qfmri_02_002 qfmri_02_008 qfmri_02_015 qfmri_02_001 qfmri_02_005 qfmri_02_006
do 
  ${SCRIPTSDIR}/analyze_CVR.sh $MYSUB
done
#just trying it for qfmri_01_001 before I do the loop