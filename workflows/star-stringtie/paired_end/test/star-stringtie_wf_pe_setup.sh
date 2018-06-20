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

# Get STAR index files
. "${LIB_DIR}/get_star_index_GRCh38" "${REPO_DIR}"

# Get Gencode annotation GTF
. "${LIB_DIR}/get_gencode_gene_annotation" "${REPO_DIR}"
