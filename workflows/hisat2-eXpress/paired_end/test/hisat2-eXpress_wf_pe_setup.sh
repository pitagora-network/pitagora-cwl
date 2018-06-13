#!/bin/sh
BASE_DIR=$(pwd -P)

get_abs_path(){
  echo "$(cd $(dirname "${1}") && pwd -P)/$(basename "${1}")"
}

REPO_DIR="$(get_abs_path "${1}")"
LIB_DIR="${REPO_DIR}/test/lib"
REF_DIR="${REPO_DIR}/test/reference"

# Read layout
layout=$(basename ${0} | sed -e 's:^.*_wf_::' -e 's:_setup.sh$::')

# Get the list of Run IDs
. "${LIB_DIR}/get_id_list" "${REPO_DIR}" "${layout}"

# Get HISAT2 index files
. "${LIB_DIR}/get_hisat2_index_refMrna" "${REPO_DIR}"

# Get UCSC gene annotation
. "${LIB_DIR}/get_UCSC_mrna_fasta" "${REPO_DIR}"
