#!/bin/sh
set -e

if [ -n "${GITHUB_WORKSPACE}" ] ; then
  cd "${GITHUB_WORKSPACE}" || exit
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

redpen --version

REDPEN_CONFIG=${INPUT_CONFIG+-c ${INPUT_CONFIG}}

# shellcheck disable=SC2086
find "${INPUT_BASEDIR}" -type f -name "${INPUT_TARGETS}" -print0            \
  | xargs -I {} -0 redpen ${REDPEN_CONFIG} -l 9999 -r plain {} 2>/dev/null  \
  | reviewdog -efm="%f:%l: Validation%t%*[a-z][%*[a-zA-Z]], %m at line:%r"  \
      -name="${INPUT_TOOL_NAME}"                                            \
      -reporter="${INPUT_REPORTER:-github-pr-review}"                       \
      -filter-mode="${INPUT_FILTER_MODE}"                                   \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}"                               \
      -level="${INPUT_LEVEL}"                                               \
      ${INPUT_REVIEWDOG_FLAGS}
