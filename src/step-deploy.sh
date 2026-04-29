#!/usr/bin/env psh
# Pipery Helm CD — deploy step
# Structured logging via psh: every command is captured to $INPUT_LOG_FILE

set -euo pipefail

echo "::group::Deploy"
echo "project_path=$INPUT_PROJECT_PATH"
echo "::endgroup::"
