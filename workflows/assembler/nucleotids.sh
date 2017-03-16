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
readonly READS=$(readlink -f $3)
readonly SRC=$(dirname ${READS})
readonly READ_FILE=$(basename ${READS})


# The destination directory where output contigs should go
readonly DST=$(readlink -f $4)
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
    ${CONTAINER_SRC_DIR}/${READ_FILE} ${CONTAINER_DST_DIR}

# Remove container after it has been used
#docker rm $(cat ${CONTAINER_FILE})
