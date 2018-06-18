#!/bin/sh
BASE_DIR=$(pwd -P)
REPO_DIR="${1}"
LIB_DIR="${REPO_DIR}/test/lib"
REF_DIR="${REPO_DIR}/test/reference"

# Read layout
layout=$(echo ${0} | sed -e 's:^.*_wf_::' -e 's:_setup.sh$::')

# Get ID list
id_list_name="id.list"
id_list_path="${REPO_DIR}/test/data/${layout}.test.${id_list_name}"
if test ! -e "${id_list_name}"; then
  ln -s "${id_list_path}" "${id_list_name}"
fi

# Get kallisto index files
. "${LIB_DIR}/get_kallisto_index" "${REPO_DIR}"
