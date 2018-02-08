#!/bin/bash

# Exit this script if any subsequent command fails
set -o errexit

# Exit if any of the variables are unset
set -o nounset

# Verbose logging
set -o xtrace

# Name of assembler image
readonly IMAGE=$1

# Name of config bundle to use
readonly BUNDLE=$2

# Location of the fastq.gz file of reads
readonly READ1=$(readlink -f $3)
readonly READ2=$(readlink -f $4)
readonly SRC=$(dirname ${READ1})
readonly READ_FILE1=$(basename ${READ1})
readonly READ_FILE2=$(basename ${READ2})


# The destination directory where output contigs should go
readonly DST=$(readlink -f $5)
mkdir -p $DST

# Location of mounted volumes inside the container
readonly CONTAINER_SRC_DIR=/inputs
readonly CONTAINER_DST_DIR=/outputs

readonly CONTAINER_FILE="$(mktemp -d)/container_id"

# Assemble the reads using docker and the image
docker run \
    --volume ${DST}:${CONTAINER_DST_DIR}:rw \
    --volume ${SRC}:${CONTAINER_SRC_DIR}:ro \
    --detach=false \
    --cidfile="${CONTAINER_FILE}" \
    ${IMAGE} \
    ${BUNDLE} \
    ${CONTAINER_SRC_DIR}/${READ_FILE1} ${CONTAINER_SRC_DIR}/${READ_FILE2} ${CONTAINER_DST_DIR}

# Remove container after it has been used
#docker rm $(cat ${CONTAINER_FILE})
