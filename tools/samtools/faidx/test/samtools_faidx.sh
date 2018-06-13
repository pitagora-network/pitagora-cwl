#!/bin/bash
# samtools_faidx.sh <path to data dir> <path to samtools_faidx.cwl> <path to samtools_faidx.yml.sample>
#
set -e

get_abs_path(){
  echo "$(cd $(dirname "${1}") && pwd -P)/$(basename "${1}")"
}

BASE_DIR="$(pwd -P)"
DATA_PATH="$(get_abs_path ${1})"
CWL_PATH="$(get_abs_path ${2})"
YAML_TMP_PATH="$(get_abs_path ${3})"

result_dir="${BASE_DIR}/result"
mkdir -p "${result_dir}" && cd "${result_dir}"

yaml_path="${result_dir}/${id}.yml"
cp "${YAML_TMP_PATH}" "${yaml_path}"

sed -i.buk \
  -e "s:_INPUT_FASTA_:${DATA_PATH}:" \
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
