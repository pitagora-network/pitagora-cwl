#!/bin/bash
# sailfish_index.sh <path to fasta file> <index_name> <path to sailfish_index.cwl> <path to sailfish_index.yml.sample>
#
set -e

get_abs_path(){
  echo "$(cd $(dirname "${1}") && pwd -P)/$(basename "${1}")"
}

BASE_DIR="$(pwd -P)"
FASTA_FILE_PATH="$(get_abs_path ${1})"
INDEX_NAME="${2}"
CWL_PATH="$(get_abs_path ${3})"
YAML_TMP_PATH="$(get_abs_path ${4})"

result_dir="${BASE_DIR}/result"
mkdir -p "${result_dir}" && cd "${result_dir}"

yaml_path="${result_dir}/sailfish_index.yml"
cp "${YAML_TMP_PATH}" "${yaml_path}"

sed -i.buk \
  -e "s:_PATH_TO_FASTA_:${FASTA_FILE_PATH}:" \
  -e "s:_SAILFISH_INDEX_NAME_:${INDEX_NAME}:" \
  "${yaml_path}"

cwltool \
  --debug \
  --leave-container \
  --timestamps \
  --compute-checksum \
  --record-container-id \
  --cidfile-dir ${result_dir} \
  --outdir ${result_dir} \
  "${CWL_PATH}" \
  "${yaml_path}" \
  2> "${result_dir}/cwltool.log"
