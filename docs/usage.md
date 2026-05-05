# Using Pipery Helm CD

CD pipeline for Helm: update chart values → helm upgrade → wait for Kubernetes rollout

## Recommended workflow

1. Pin the action to a major tag in production workflows.
2. Keep a representative test project in the repository and point `test_project_path` at it.
3. Emit a `pipery.jsonl` build log during the action run and keep `test_log_path` pointed at it.
4. Make the action consume that path via the configured test input.
5. Keep changelog entries under `## [Unreleased]` until you cut a release.
6. Regenerate docs before publishing a new version.

## Example

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
          config_file: .pipery/config.yaml
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
