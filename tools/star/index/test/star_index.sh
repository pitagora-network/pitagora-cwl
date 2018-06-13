#!/bin/bash
# star_index.sh <path to fasta file> <path to annotation file> <path to star_index.cwl> <path to star_index.yml.sample>
#
set -e

get_abs_path(){
  echo "$(cd $(dirname "${1}") && pwd -P)/$(basename "${1}")"
}

set_ncpus(){
  NCPUS=1
  if [[ "$(uname)" == 'Darwin' ]]; then
    NCPUS=$(sysctl -n hw.ncpu)
  elif [[ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]]; then
    NCPUS=$(nproc)
  else
    echo "Your platform ($(uname -a)) is not supported." 2>dev/null
    exit 1
  fi
}
set_ncpus

BASE_DIR="$(pwd -P)"
FASTA_FILE_PATH="$(get_abs_path ${1})"
ANNOTATION_GTF_PATH="$(get_abs_path ${2})"
CWL_PATH="$(get_abs_path ${3})"
YAML_TMP_PATH="$(get_abs_path ${4})"

result_dir="${BASE_DIR}/result"
mkdir -p "${result_dir}" && cd "${result_dir}"

yaml_path="${result_dir}/${id}.yml"
cp "${YAML_TMP_PATH}" "${yaml_path}"

sed -i.buk \
  -e "s:_NTHREADS_:${NCPUS}:" \
  -e "s:_PATH_TO_FASTA_:${FASTA_FILE_PATH}:" \
  -e "s:_ANNOTATION_GTF_:${ANNOTATION_GTF_PATH}:" \
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
