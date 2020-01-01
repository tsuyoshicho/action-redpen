#!/bin/sh

cd "$GITHUB_WORKSPACE"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

redpen --version

redpen -c config/redpen-conf-ja.xml -L ja -l 9999               \
       -r plain "${INPUT_REDPEN_FLAGS:-'.'}" 2>/dev/null        \
  | reviewdog  -efm="%f:%l: %m" -name="redpen"                  \
               -diff="git diff HEAD^"                           \
               -reporter="${INPUT_REPORTER:-'github-pr-check'}" \
               -level="${INPUT_LEVEL:-'error'}"
