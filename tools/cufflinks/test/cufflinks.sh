#!/bin/bash
# cufflinks.sh --annotation <path to reference annotation gtf file> [--data <path to data dir>] [--cwl <path to cufflinks.cwl>] [--yml <path to cufflinks.yml.sample>]
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

PFX="cufflinks"

BASE_DIR="$(pwd -P)"
DATA_DIR_PATH="${BASE_DIR}"
CWL_PATH="${BASE_DIR}/${PFX}.cwl"
YAML_TMP_PATH="${BASE_DIR}/${PFX}.yml.sample"

while test $# -gt 0; do
  key=${1}
  case ${key} in
    --cwl) CWL_PATH="$(get_abs_path ${2})"; shift ;;
    --yml) YAML_TMP_PATH="$(get_abs_path ${2})"; shift ;;
    --data) DATA_DIR_PATH="$(get_abs_path ${2})"; shift ;;
    --annotation) ANNOTATION_FILE_PATH="$(get_abs_path ${2})"; shift ;;
  esac
  shift
done

find "${DATA_DIR_PATH}" -name '*.bam' | while read fpath; do
  id="$(basename "${fpath}" | sed -e 's:.bam$::g')"
  result_dir="${BASE_DIR}/result/${id:0:6}/${id}"
  mkdir -p "${result_dir}" && cd "${result_dir}"

  yaml_path="${result_dir}/${id}.yml"
  cp "${YAML_TMP_PATH}" "${yaml_path}"

  sed -i.buk \
    -e "s:_PATH_TO_GTF_:${ANNOTATION_FILE_PATH}:" \
    -e "s:_NTHREADS_:${NCPUS}:" \
    -e "s:_INPUT_BAM_:${fpath}:" \
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

  cd "${BASE_DIR}"
done
