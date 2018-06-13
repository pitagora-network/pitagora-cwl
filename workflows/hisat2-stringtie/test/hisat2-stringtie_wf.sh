#!/bin/bash
# hisat2-stringtie_wf.sh <path to id list> <path to one of hisat2 index files (e.g. hoge.1.ht2)> <path to annotation gtf file> <path to hisat2-stringtie_wf_(se|pe).cwl> <path to hisat2-stringtie_wf_(se|pe).yaml.sample>
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
ID_LIST_PATH="$(get_abs_path ${1})"
INDEX_FILE_PATH="$(get_abs_path ${2})"
ANNOTATION_FILE_PATH="$(get_abs_path ${3})"
CWL_PATH="$(get_abs_path ${4})"
YAML_TMP_PATH="$(get_abs_path ${5})"

run_workflow(){
  local id="${1}"
  local result_dir="${BASE_DIR}/result/${id:0:6}/${id}"
  local yaml_path="${result_dir}/${id}.yaml"
  mkdir -p "${result_dir}" && cd "${result_dir}"
  config_yaml "${yaml_path}" "${id}"
  run_cwl "${result_dir}" "${yaml_path}"
  cd "${BASE_DIR}"
}

config_yaml(){
  local yaml_path="${1}"
  local id="${2}"
  cp "${YAML_TMP_PATH}" "${yaml_path}"

  local idx_basedir=$(dirname ${INDEX_FILE_PATH})
  local idx_basename=$(basename ${INDEX_FILE_PATH} | sed 's:\..*$::g')

  sed -r \
    -i.buk \
    -e "s:_NTHREADS_:${NCPUS}:" \
    -e "s:_RUN_IDS_:${id}:" \
    -e "s:_INDEX_DIR_PATH_:${idx_basedir}:" \
    -e "s:_INDEX_BASENAME_:${idx_basename}:" \
    -e "s:_ANNOTATION_GTF_:${ANNOTATION_FILE_PATH}:" \
    "${yaml_path}"
}

run_cwl(){
  local result_dir="${1}"
  local yaml_path="${2}"
  cwltool \
    --debug \
    --leave-container \
    --timestamps \
    --compute-checksum \
    --record-container-id \
    --cidfile-dir ${result_dir} \
    --outdir ${result_dir} \
    ${CWL_PATH} \
    "${yaml_path}" \
    2> "${result_dir}/cwltool.log"
}

cat "${ID_LIST_PATH}" | while read run_id; do
  run_workflow "${run_id}"
done
