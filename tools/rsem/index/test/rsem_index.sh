#!/bin/bash
# rsem_index.sh <path to fasta dir> <path to gtf file> <index name> <path to rsem_index.cwl> <path to rsem_index.yml.sample>
#
set -e

get_abs_path(){
  echo "$(cd $(dirname "${1}") && pwd -P)/$(basename "${1}")"
}

BASE_DIR="$(pwd -P)"
FASTA_DIR_PATH="$(get_abs_path ${1})"
ANNOTATION_GTF_PATH="$(get_abs_path ${2})"
INDEX_NAME="${3}"
CWL_PATH="$(get_abs_path ${4})"
YAML_TMP_PATH="$(get_abs_path ${5})"

result_dir="${BASE_DIR}/result"
mkdir -p "${result_dir}" && cd "${result_dir}"

yaml_path="${result_dir}/rsem_index.yml"
cp "${YAML_TMP_PATH}" "${yaml_path}"

sed -i.buk \
  -e "s:_PATH_TO_GTF_:${ANNOTATION_GTF_PATH}:" \
  -e "s:_PATH_TO_FASTA_DIR_:${FASTA_DIR_PATH}:" \
  -e "s:_REFERENCE_NAME_:${INDEX_NAME}:" \
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
