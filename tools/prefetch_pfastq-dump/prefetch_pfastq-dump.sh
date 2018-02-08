#!/bin/bash

RUN_ID=$1
READ_TYPE=$2
NTHREADS=$3

# split RUN IDs
IDS=(`echo ${RUN_ID} | tr -s ',' ' '`)

# loop
for i in ${IDS[@]}; do
  # execute prefetch (sra-toolkit) to get a SRA file from NCBI.
  prefetch ${i}
  # move the downloaded sra file to user's specified directory.
  mv ~/ncbi/public/sra/${i}.sra .

  if [ "${READ_TYPE}" = single ]; then
    pfastq-dump --threads ${NTHREADS} --split-spot --readids --outdir . ${i}.sra
  else
    pfastq-dump --threads ${NTHREADS} --split-spot --readids --split-files --outdir . ${i}.sra
  fi
done

### merge FASTQ files if multiple FASTQ files exist.
# paired end
if [ "${READ_TYPE}" = pair -a ${#IDS[*]} -gt 0 ]; then
  BASEFASTQ1=
  BASEFASTQ2=
  count=0
  for i in ${IDS[@]}; do
    if [ -f "${i}_1.fastq" -a -f "${i}_2.fastq" ]; then
      if [ $count = 0 ]; then
        BASEFASTQ1=${i}_1.fastq 
        BASEFASTQ2=${i}_2.fastq 
      else
        cat ${i}_1.fastq >> ${BASEFASTQ1}
        cat ${i}_2.fastq >> ${BASEFASTQ2}
      fi
      let count++
    fi
  done
fi
# single end
if [ "${READ_TYPE}" = single -a ${#IDS[*]} -gt 0 ]; then
  BASEFASTQ=
  count=0
  for i in ${IDS[@]}; do
    if [ -f "${i}.fastq" ]; then
      if [ $count = 0 ]; then
        BASEFASTQ=${i}.fastq 
      else
        cat ${i}.fastq >> ${BASEFASTQ}
      fi
      let count++
    fi
  done
fi

# output version.
VERSION=`pfastq-dump --version`
VERSION=`echo ${VERSION%using*}`
VERSION=`echo ${VERSION//pfastq-dump version /}`
echo "pfastq-dump	${VERSION}" > pfastq-dump_version


echo $?
