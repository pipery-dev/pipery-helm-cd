# Pipery Helm CD

Reusable GitHub Action for Helm CD with structured logging via [Pipery](https://pipery.dev).

[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-Pipery%20Helm%20CD-blue?logo=github)](https://github.com/marketplace/actions/pipery-helm-cd)
[![Version](https://img.shields.io/badge/version-1.0.0-blue)](CHANGELOG.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Usage

```yaml
name: CD
on:
  push:
    branches: [main]

jobs:
  cd:
    uses: pipery-dev/pipery-helm-cd@v1
    with:
      project_path: .
    secrets: inherit
```

## Pipeline steps

update chart values → helm upgrade → rollout status check

Every step is logged to `pipery.jsonl` via psh and uploaded as a GitHub Actions artifact.

## Inputs

| Input | Description | Default |
|---|---|---|
| `project_path` | Path to the project source tree. | `.` |
| `config_file` | Path to the pipery config file. | `.github/pipery/config.yaml` |
| `release_name` | Helm release name. | `` |
| `chart` | Helm chart path or OCI reference. | `` |
| `namespace` | Kubernetes namespace for the release. | `default` |
| `values_file` | Path to a values.yaml override file. | `` |
| `set_values` | Comma-separated set values (key=val). | `` |
| `image_tag` | Image tag to set via --set (leave empty to skip). | `${{ github.sha }}` |
| `image_key` | Helm values key for the image tag (e.g. image.tag). | `image.tag` |
| `kubeconfig` | Base64-encoded kubeconfig for cluster access. | `` |
| `timeout` | Timeout for helm upgrade. | `5m` |
| `atomic` | Roll back on failure. | `true` |
| `skip_deploy` | Skip helm upgrade step. | `false` |
| `skip_status_check` | Skip rollout status check. | `false` |
| `log_file` | Path to write the JSONL log file. | `pipery.jsonl` |

## Observability

Each run produces a `pipery.jsonl` file. Upload it as an artifact and inspect it with the [Pipery Dashboard](https://dash.pipery.dev).

## License

MIT — see [LICENSE](LICENSE).
