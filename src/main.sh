#!/usr/bin/env bash
set -euo pipefail

# Pipery Helm CD - Main orchestrator
# Orchestrates: read config → deploy to Helm → status check

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_PATH="${INPUT_PROJECT_PATH:-${PIPERY_TEST_PROJECT_PATH:-.}}"
LOG="${INPUT_LOG_FILE:-${PIPERY_LOG_PATH:-pipery.jsonl}}"
export INPUT_LOG_FILE="$LOG"

if [ ! -d "$PROJECT_PATH" ]; then
  echo "[pipery-helm-cd] ERROR: project path does not exist: $PROJECT_PATH" >&2
  exit 1
fi
PROJECT_PATH="$(cd "$PROJECT_PATH" && pwd)"
export INPUT_PROJECT_PATH="$PROJECT_PATH"

if [ -d "${PROJECT_PATH}/bin" ]; then
  export PATH="${PROJECT_PATH}/bin:${PATH}"
fi
if [ -d "${PROJECT_PATH}/mock-bin" ]; then
  export PATH="${PROJECT_PATH}/mock-bin:${PATH}"
fi

mkdir -p "$(dirname "$LOG")"

# Step: read config
bash "$SCRIPT_DIR/read-config.sh"

# Step: deploy
if [ "${INPUT_SKIP_DEPLOY:-false}" != "true" ]; then
  bash "$SCRIPT_DIR/step-deploy.sh"
else
  echo "[pipery-helm-cd] Skipping deploy step."
fi

# Step: status check
if [ "${INPUT_SKIP_STATUS_CHECK:-false}" != "true" ]; then
  bash "$SCRIPT_DIR/step-status.sh"
else
  echo "[pipery-helm-cd] Skipping status check step."
fi

# Final success log entry (always written)
printf '{"event":"deploy","status":"success","target":"helm","mode":"cd"}\n' >> "${LOG}"

echo "[pipery-helm-cd] CD pipeline completed for: ${PROJECT_PATH}"
