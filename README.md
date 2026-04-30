# Pipery Helm CD

CD pipeline for Helm: update chart values → helm upgrade → wait for Kubernetes rollout

## Status

- Owner: `pipery-dev`
- Repository: `pipery-helm-cd`
- Marketplace category: `continuous-integration`
- Current version: `3.0.0`

## Usage

```yaml
name: Example
on: [push]

jobs:
  run-action:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pipery-dev/pipery-helm-cd@v3
        with:
          project_path: .
          config_file: .github/pipery/config.yaml
          release_name: 
          chart: 
          namespace: default
          values_file: 
          set_values: 
          image_tag: ${{ github.sha }}
          image_key: image.tag
          kubeconfig: 
          timeout: 5m
          atomic: true
          skip_deploy: false
          skip_status_check: false
          log_file: pipery.jsonl
```

## Inputs

| Name | Required | Default | Description |
| --- | --- | --- | --- |
| `project_path` | no | `.` | Path to the project source tree. |
| `config_file` | no | `.github/pipery/config.yaml` | Path to the pipery config file. |
| `release_name` | no | `` | Helm release name. |
| `chart` | no | `` | Helm chart path or OCI reference. |
| `namespace` | no | `default` | Kubernetes namespace for the release. |
| `values_file` | no | `` | Path to a values.yaml override file. |
| `set_values` | no | `` | Comma-separated set values (key=val). |
| `image_tag` | no | `${{ github.sha }}` | Image tag to set via --set (leave empty to skip). |
| `image_key` | no | `image.tag` | Helm values key for the image tag (e.g. image.tag). |
| `kubeconfig` | no | `` | Base64-encoded kubeconfig for cluster access. |
| `timeout` | no | `5m` | Timeout for helm upgrade. |
| `atomic` | no | `true` | Roll back on failure. |
| `skip_deploy` | no | `false` | Skip helm upgrade step. |
| `skip_status_check` | no | `false` | Skip rollout status check. |
| `log_file` | no | `pipery.jsonl` | Path to write the JSONL log file. |

## Outputs

No outputs.

## Development

This repository is managed with `pipery-tooling`.

```bash
pipery-actions test --repo .
pipery-actions docs --repo .
pipery-actions release --repo . --dry-run
```

By default, `pipery-actions test --repo .` executes the action against `test-project` and validates `pipery.jsonl`.

## Marketplace Release Flow

1. Update the implementation and changelog.
2. Run `pipery-actions release --repo .`.
3. Push the created git tag and major tag alias.
4. Publish the GitHub release.
