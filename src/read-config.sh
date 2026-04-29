#!/usr/bin/env bash
# Load pipery config and export to GITHUB_ENV
set -euo pipefail

CONFIG="${INPUT_CONFIG_FILE:-.github/pipery/config.yaml}"
if [ -f "$CONFIG" ]; then
  while IFS=': ' read -r key val; do
    [[ "$key" =~ ^#|^$ ]] && continue
    echo "${key^^}=${val}" >> "$GITHUB_ENV"
  done < "$CONFIG"
fi
