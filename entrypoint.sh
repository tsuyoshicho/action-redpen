#!/bin/sh
set -e

if [ -n "${GITHUB_WORKSPACE}" ] ; then
  cd "${GITHUB_WORKSPACE}" || exit 1
  git config --global --add safe.directory "${GITHUB_WORKSPACE}" || exit 1
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

redpen --version

REDPEN_CONFIG=${INPUT_CONFIG+-c ${INPUT_CONFIG}}

# setup compatibility
fail_level="${INPUT_FAIL_LEVEL}"
if [ "${INPUT_FAIL_LEVEL}" = "none" ] && [ "${INPUT_FAIL_ON_ERROR}" = "true" ]; then
  fail_level="error"
fi

# shellcheck disable=SC2086
find "${INPUT_BASEDIR}" -type f -name "${INPUT_TARGETS}" -print0            \
  | xargs -I {} -0 redpen ${REDPEN_CONFIG} -l 9999 -r plain {} 2>/dev/null  \
  | reviewdog -efm="%f:%l: Validation%t%*[a-z][%*[a-zA-Z]], %m at line:%r"  \
      -name="${INPUT_TOOL_NAME}"                                            \
      -reporter="${INPUT_REPORTER:-github-pr-review}"                       \
      -filter-mode="${INPUT_FILTER_MODE}"                                   \
      -fail-level="${fail_level}"                                           \
      -level="${INPUT_LEVEL}"                                               \
      ${INPUT_REVIEWDOG_FLAGS}
