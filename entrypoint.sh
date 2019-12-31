#!/bin/sh

cd "$GITHUB_WORKSPACE"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

redpen --version

if [ "${INPUT_REPORTER}" == 'github-pr-review' ]; then
  find "${INPUT_REDPEN_FLAGS:-'.'}" -type f -print0 \
    | xargs -I{} -0 redpen -c config/redpen-conf-ja.xml -L ja -l 9999 -r plain {} 2>/dev/null \
    | reviewdog  -efm="%f:%l: %m" -name="redpen" -diff="git diff HEAD^" -reporter=github-pr-review -level="${INPUT_LEVEL}"
else
  # github-pr-check (GitHub Check API) doesn't support markdown annotation.
  find "${INPUT_REDPEN_FLAGS:-'.'}" -type f -print0 \
    | xargs -I{} -0 redpen -c config/redpen-conf-ja.xml -L ja -l 9999 -r plain {} 2>/dev/null \
    | reviewdog  -efm="%f:%l: %m" -name="redpen" -diff="git diff HEAD^" -reporter=github-pr-check -level="${INPUT_LEVEL}"
fi
