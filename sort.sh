#!/bin/bash

# Sort data from qfMRI study. 

MYSUB=$1
MAINDIR=/Users/erin/Desktop/Projects/qfMRI_MS
DICOMDIR=${MAINDIR}/dicoms
SUBDIR=${DICOMDIR}/${MYSUB}
ANALYSISDIR=${MAINDIR}/analysis/${MYSUB}

mkdir ${ANALYSISDIR}

mkdir ${SUBDIR}_sorted
echo SERIES_NUM SERIES_NAME > ${ANALYSISDIR}/series_order.txt
for f in `ls -d ${SUBDIR}/*`
do
#	echo $f
	file1=`find ${f}/. -name "*" -not -name "." | head -1` 
#	echo $file1
	seriesname=`dicom_hdr $file1 | egrep "ID Series Description" | cut -f5- -d "/"`
	seriesname=${seriesname// /_}
	seriesname=${seriesname//\//_}
	seriesname=${seriesname//:/_}
#	echo $seriesname
	mv ${f} ${SUBDIR}_sorted/${seriesname}
	echo ${f} ${seriesname} >> ${ANALYSISDIR}/series_order.txt
done

mv ${SUBDIR}_sorted/* ${SUBDIR}/.
rm -r ${SUBDIR}_sorted/

