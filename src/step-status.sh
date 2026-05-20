#!/usr/bin/env bash
# Pipery Helm CD — status step
# Structured logging via psh: every command is captured to $INPUT_LOG_FILE

set -euo pipefail

echo "::group::Status"
release="${INPUT_RELEASE_NAME:-}"
namespace="${INPUT_NAMESPACE:-default}"
log="${INPUT_LOG_FILE:-pipery.jsonl}"

if [ -z "$release" ]; then
  echo "release_name is required for helm status; skipping."
  printf '{"event":"helm_status","status":"skipped","reason":"missing_release"}\n' >> "$log"
  echo "::endgroup::"
  exit 0
fi

if ! command -v helm >/dev/null 2>&1; then
  echo "helm is not installed; cannot check $release." >&2
  exit 1
fi

if [ -n "${INPUT_KUBECONFIG:-}" ]; then
  kubeconfig_file="${RUNNER_TEMP:-/tmp}/pipery-kubeconfig"
  printf '%s' "$INPUT_KUBECONFIG" | base64 --decode > "$kubeconfig_file"
  export KUBECONFIG="$kubeconfig_file"
fi

helm status "$release" --namespace "$namespace"
printf '{"event":"helm_status","status":"success","release":"%s","namespace":"%s"}\n' "$release" "$namespace" >> "$log"
echo "::endgroup::"
