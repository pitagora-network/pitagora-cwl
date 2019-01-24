#!/bin/bash
# hisat2-cufflinks_wf.sh --id <path to id list> --index <path to one of hisat2 index files (e.g. hoge.1.ht2)> --annotation <path to annotation gtf file> [--cwl <path to hisat2-cufflinks_wf_(se|pe).cwl>] --yml [<path to hisat2-cufflinks_wf_(se|pe).yaml.sample>]
#
set -e

get_abs_path(){
  echo "$(cd $(dirname "${1}") && pwd -P)/$(basename "${1}")"
}

case "$(uname -s)" in
  Darwin) NCPUS=$(sysctl -n hw.ncpu) ;;
  Linux ) NCPUS=$(nproc) ;;
  * ) NCPUS=1 ;;
esac

PFX=$(basename ${0} | sed 's:\.sh$::')

BASE_DIR="$(pwd -P)"
DATA_DIR_PATH="${BASE_DIR}"
CWL_PATH="${BASE_DIR}/${PFX}.cwl"
YAML_TMP_PATH="${BASE_DIR}/${PFX}.yml.sample"
ID_LIST_PATH="${BASE_DIR}/id.list"
HISAT2_INDEX_FILE_PATH="${BASE_DIR}/hisat2_GRCh38/genome.1.ht2"
CUFFLINKS_ANNOTATION_FILE_PATH="${BASE_DIR}/genes.gtf"

while test $# -gt 0; do
  key=${1}
  case ${key} in
    --cwl) CWL_PATH="$(get_abs_path ${2})"; shift ;;
    --yml) YAML_TMP_PATH="$(get_abs_path ${2})"; shift ;;
    --id) ID_LIST_PATH="$(get_abs_path ${2})"; shift ;;
    --index) HISAT2_INDEX_FILE_PATH="$(get_abs_path ${2})"; shift ;;
    --annotation) CUFFLINKS_ANNOTATION_FILE_PATH="$(get_abs_path ${2})"; shift ;;
  esac
  shift
done

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

  local idx_basedir=$(dirname ${HISAT2_INDEX_FILE_PATH})
  local idx_basename=$(basename ${HISAT2_INDEX_FILE_PATH} | sed 's:\..*$::g')

  sed -E \
    -i.buk \
    -e "s:_NTHREADS_:${NCPUS}:" \
    -e "s:_RUN_IDS_:${id}:" \
    -e "s:_INDEX_DIR_PATH_:${idx_basedir}:" \
    -e "s:_INDEX_BASENAME_:${idx_basename}:" \
    -e "s:_ANNOTATION_GTF_:${CUFFLINKS_ANNOTATION_FILE_PATH}:" \
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
  run_workflow "${run_id}" ||:
done
