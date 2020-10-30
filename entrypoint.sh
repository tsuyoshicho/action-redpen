#!/bin/sh

cd "$GITHUB_WORKSPACE"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

redpen --version

find "${INPUT_BASEDIR:-'.'}" -type f -name "${INPUT_TARGETS:-'*'}" -print0  \
  | xargs -I {} -0 redpen -c "${INPUT_CONFIG:-'config/redpen-conf-en.xml'}" \
                          -l 9999 -r plain {} 2>/dev/null                   \
  | reviewdog -efm="%f:%l: Validation%t%*[a-z]%m at line:%.\*"              \
              -name="redpen"                                                \
              -reporter="${INPUT_REPORTER:-'github-pr-check'}"              \
              -level="${INPUT_LEVEL:-'error'}"
