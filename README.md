# <img src="https://raw.githubusercontent.com/pipery-dev/pipery-helm-cd/main/assets/icon.png" alt="Pipery Helm CD" width="28" align="center" /> Pipery Helm CD

Reusable GitHub Action for Helm-based Kubernetes deployment with structured logging via [Pipery](https://pipery.dev).

[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-Pipery%20Helm%20CD-blue?logo=github)](https://github.com/marketplace/actions/pipery-helm-cd)
[![Version](https://img.shields.io/badge/version-1.0.0-blue)](CHANGELOG.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Table of Contents

- [Quick Start](#quick-start)
- [Pipeline Overview](#pipeline-overview)
- [Configuration Options](#configuration-options)
- [Usage Examples](#usage-examples)
- [GitLab CI](#gitlab-ci)
- [Bitbucket Pipelines](#bitbucket-pipelines)
- [About Pipery](#about-pipery)
- [Development](#development)

## Quick Start

```yaml
name: Deploy
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pipery-dev/pipery-helm-cd@v1
        with:
          release_name: my-release
          chart: ./helm/my-chart
          namespace: production
          image_tag: ${{ github.sha }}
```

## Pipeline Overview

| Step | Description | Skip Input |
| --- | --- | --- |
| Deploy | Helm upgrade or install release | `skip_deploy` |
| Status check | Verify Kubernetes rollout | `skip_status_check` |

## Configuration Options

| Name | Default | Description |
| --- | --- | --- |
| `project_path` | `.` | Path to the project source tree. |
| `config_file` | `.pipery/config.yaml` | Path to Pipery config file. |
| `release_name` | `` | Helm release name. |
| `chart` | `` | Helm chart path or OCI reference. |
| `namespace` | `default` | Kubernetes namespace for the release. |
| `values_file` | `` | Path to a values.yaml override file. |
| `set_values` | `` | Comma-separated set values (key=val). |
| `image_tag` | `${{ github.sha }}` | Image tag to set via --set. |
| `image_key` | `image.tag` | Helm values key for the image tag. |
| `kubeconfig` | `` | Base64-encoded kubeconfig for cluster access. |
| `timeout` | `5m` | Timeout for helm upgrade. |
| `atomic` | `true` | Roll back on failure. |
| `log_file` | `pipery.jsonl` | Path to write the JSONL log file. |
| `skip_deploy` | `false` | Skip helm upgrade step. |
| `skip_status_check` | `false` | Skip rollout status check. |

## Usage Examples

### Example 1: Deploy local Helm chart

```yaml
name: Deploy
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pipery-dev/pipery-helm-cd@v1
        with:
          release_name: my-release
          chart: ./helm/my-chart
          namespace: production
          image_tag: ${{ github.sha }}
```

### Example 2: Deploy from Helm repository

```yaml
- uses: pipery-dev/pipery-helm-cd@v1
  with:
    release_name: my-app
    chart: bitnami/my-app
    namespace: production
    values_file: ./values-prod.yaml
    image_tag: ${{ github.sha }}
```

### Example 3: Custom values with set flags

```yaml
- uses: pipery-dev/pipery-helm-cd@v1
  with:
    release_name: my-app
    chart: ./helm/my-app
    namespace: production
    set_values: replicas=3,resources.limits.memory=512Mi
    image_tag: ${{ github.sha }}
```

### Example 4: Long-running deployment with timeout

```yaml
- uses: pipery-dev/pipery-helm-cd@v1
  with:
    release_name: my-app
    chart: ./helm/my-app
    namespace: production
    timeout: 10m
    image_tag: ${{ github.sha }}
```

### Example 5: Disable automatic rollback

```yaml
- uses: pipery-dev/pipery-helm-cd@v1
  with:
    release_name: my-app
    chart: ./helm/my-app
    namespace: production
    atomic: false
    image_tag: ${{ github.sha }}
```

### Example 6: OCI chart from registry

```yaml
- uses: pipery-dev/pipery-helm-cd@v1
  with:
    release_name: my-app
    chart: oci://ghcr.io/my-org/my-chart
    namespace: production
    image_tag: v${{ github.ref_name }}
```

## GitLab CI

This repository includes a GitLab CI equivalent at `.gitlab-ci.yml`. Copy it into a GitLab project or use it as a reference implementation for running the same Pipery pipeline outside GitHub Actions.

The GitLab pipeline maps action inputs to CI/CD variables, publishes `pipery.jsonl` as an artifact, and maintains the same skip controls. Store credentials as protected GitLab CI/CD variables.

```yaml
include:
  - remote: https://raw.githubusercontent.com/pipery-dev/pipery-helm-cd/v1/.gitlab-ci.yml
```

### GitLab CI Variables

Configure these protected variables in **Settings > CI/CD > Variables**:

- `KUBECONFIG_BASE64` - Base64-encoded kubeconfig file
- `HELM_RELEASE` - Helm release name
- `HELM_CHART` - Helm chart path or reference

## Bitbucket Pipelines

Bitbucket Cloud pipelines provide an alternative to GitHub Actions. The equivalent pipeline configuration is in `bitbucket-pipelines.yml`.

### Getting Started

1. Copy `bitbucket-pipelines.yml` to your Bitbucket repository root
2. Configure Protected Variables in **Repository Settings > Pipelines > Repository Variables**:
   - `KUBECONFIG_BASE64` - Base64-encoded kubeconfig
   - `HELM_RELEASE` - Helm release name
   - `HELM_CHART` - Chart path or reference
3. Commit to trigger deployment

### Pipeline Stages

The Bitbucket equivalent follows the same structure:

checkout → setup → deploy → status_check → logs

### Features

- Helm chart deployment from local paths or repositories
- OCI chart support
- Custom values overrides
- Automatic rollback on failure
- Kubernetes rollout monitoring
- Custom timeouts
- JSONL-based pipeline logging
- 90-day log retention

## About Pipery

<img src="https://avatars.githubusercontent.com/u/270923927?s=32" alt="Pipery" width="22" align="center" /> [**Pipery**](https://pipery.dev) is an open-source CI/CD observability platform. Every step script runs under **psh** (Pipery Shell), which intercepts all commands and emits structured JSONL events — giving you full visibility into your pipeline without any manual instrumentation.

- Browse logs in the [Pipery Dashboard](https://github.com/pipery-dev/pipery-dashboard)
- Find all Pipery actions on [GitHub Marketplace](https://github.com/marketplace?q=pipery&type=actions)
- Source code: [pipery-dev](https://github.com/pipery-dev)

## Development

```bash
# Run the action locally against test-project/
pipery-actions test --repo .

# Regenerate docs
pipery-actions docs --repo .

# Dry-run release
pipery-actions release --repo . --dry-run
```
