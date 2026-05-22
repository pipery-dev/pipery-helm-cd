#!/usr/bin/env bash
# Pipery Helm CD — deploy step
# Structured logging via psh: every command is captured to $INPUT_LOG_FILE

set -euo pipefail

echo "::group::Deploy"
project_path="${INPUT_PROJECT_PATH:-.}"
release="${INPUT_RELEASE_NAME:-}"
chart="${INPUT_CHART:-}"
namespace="${INPUT_NAMESPACE:-default}"
log="${INPUT_LOG_FILE:-pipery.jsonl}"

if [ -z "$release" ] || [ -z "$chart" ]; then
  echo "release_name and chart are required for helm deploy; skipping."
  printf '{"event":"helm_deploy","status":"skipped","reason":"missing_release_or_chart"}\n' >> "$log"
  echo "::endgroup::"
  exit 0
fi

if ! command -v helm >/dev/null 2>&1; then
  echo "helm is not installed; cannot deploy $release." >&2
  exit 1
fi

if [ -n "${INPUT_KUBECONFIG:-}" ]; then
  kubeconfig_file="${RUNNER_TEMP:-/tmp}/pipery-kubeconfig"
  printf '%s' "$INPUT_KUBECONFIG" | base64 --decode > "$kubeconfig_file"
  export KUBECONFIG="$kubeconfig_file"
fi

args=(upgrade --install "$release" "$chart" --namespace "$namespace" --create-namespace --timeout "${INPUT_TIMEOUT:-5m}")
if [ "${INPUT_ATOMIC:-true}" = "true" ]; then
  args+=(--atomic)
fi
if [ -n "${INPUT_VALUES_FILE:-}" ]; then
  args+=(-f "$INPUT_VALUES_FILE")
fi
if [ -n "${INPUT_SET_VALUES:-}" ]; then
  IFS=',' read -r -a set_pairs <<< "$INPUT_SET_VALUES"
  for pair in "${set_pairs[@]}"; do
    args+=(--set "$pair")
  done
fi
if [ -n "${INPUT_IMAGE_TAG:-}" ]; then
  args+=(--set "${INPUT_IMAGE_KEY:-image.tag}=${INPUT_IMAGE_TAG}")
fi

cd "$project_path"
helm "${args[@]}"
printf '{"event":"helm_deploy","status":"success","release":"%s","namespace":"%s"}\n' "$release" "$namespace" >> "$log"
echo "::endgroup::"
