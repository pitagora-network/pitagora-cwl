#!/bin/sh
# Usage:
#  cd /path/to/pitagora-cwl && sh test/bin/collect-steps.sh
#
CurrentDirName=`pwd -P | awk -F'/' '{ print $NF }'`
if test "${CurrentDirName}" != "pitagora-cwl"; then
  echo "Usage:" >&2
  echo "  cd /path/to/pitagora-cwl && sh test/bin/collect-steps.sh" >&2
  exit 1
fi

echo "Copying CWL tool definitions to each workflow directory.."

find workflows -name '*cwl' | while read wf; do
  wf_dir_path=`echo "${wf}" | sed -e 's:[^/]*.cwl$::g'`
  grep "run:" "${wf}" | awk '$0=$2' | while read step; do
    find tools -name "${step}" | xargs -I{} cp {} "${wf_dir_path}"
  done
done

echo "Done."
