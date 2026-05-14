# Pipery Helm CD Component

Reusable GitLab CI/CD component for complete Helm deployment pipeline with structured logging.

## Overview

This component provides a complete CD (deployment) pipeline using Helm:
- Image/artifact pull
- Deployment to target environment
- Health status checks
- Dashboard generation

## Quick Start

In your `.gitlab-ci.yml`:

```yaml
include:
  - component: $CI_SERVER_FQDN/pipery-dev/pipery-helm-cd/catalog-resources/pipery-helm-cd@main

variables:
  PROJECT_PATH: "."
  # Add your configuration variables here
```

## Configuration Variables

## Configuration

### Deployment Variables

| Variable | Default | Description |
| --- | --- | --- |
| PROJECT_PATH | . | Path to project source |
| DEPLOY_TARGET | argocd | Deployment target (argocd, cloudrun, helm, ansible) |
| DEPLOY_STRATEGY | rolling | Deployment strategy |
| IMAGE_NAME | | Docker image name |
| IMAGE_TAG | latest | Docker image tag |
| REGISTRY | ghcr.io | Container registry |

### Target-Specific Variables

#### ArgoCD
- `ARGOCD_SERVER` - ArgoCD server URL
- `ARGOCD_APP` - ArgoCD application name
- `ARGOCD_TOKEN` - ArgoCD authentication token

#### Cloud Run
- `CLOUD_RUN_SERVICE` - Cloud Run service name
- `CLOUD_RUN_REGION` - Deployment region (default: us-central1)
- `CLOUD_RUN_IMAGE` - Full image URI

#### Helm
- `HELM_RELEASE` - Helm release name
- `HELM_CHART` - Helm chart path
- `HELM_NAMESPACE` - Kubernetes namespace (default: default)

#### Ansible
- `ANSIBLE_PLAYBOOK` - Playbook file path
- `ANSIBLE_INVENTORY` - Inventory file path

### Registry Authentication
- `REGISTRY_USERNAME` - Registry username
- `REGISTRY_PASSWORD` - Registry password

### Skip Controls

Disable any pipeline stage by setting to `true`:
- `SKIP_PULL` - Skip pulling image from registry
- `SKIP_DEPLOY` - Skip deployment step
- `SKIP_STATUS_CHECK` - Skip status verification

## Outputs

- `pipery.jsonl` - Structured JSONL log file with all pipeline events
- `artifacts/dashboard_link.env` - Pipery Dashboard link environment file

## Pipeline Stages

The pipeline executes the following stages in order:

- `checkout`
- `setup`
- `pull`
- `deploy`
- `status`
- `logs`


## Advanced Usage

### Custom Configuration File

Override the default configuration file location:

```yaml
variables:
  CONFIG_FILE: "path/to/custom/config.yaml"
```

### Conditional Execution

Use GitLab CI rules to control when this component runs:

```yaml
include:
  - component: $CI_SERVER_FQDN/pipery-dev/pipery-helm-cd/catalog-resources/pipery-helm-cd@main
    rules:
      - if: '$CI_COMMIT_BRANCH == "main"'
```

## Monitoring & Debugging

### View Pipeline Logs

Check the `pipery.jsonl` artifact for detailed event logs:

```bash
cat pipery.jsonl | jq '.'
```

### Dashboard Link

After pipeline completion, the `artifacts/dashboard_link.env` file contains the Pipery Dashboard URL:

```bash
source artifacts/dashboard_link.env
echo $DASHBOARD_URL
```

## About Pipery

Pipery provides unified CI/CD pipelines across multiple languages and deployment targets. For more information, visit [pipery.dev](https://pipery.dev).

## Support

For issues or questions, please refer to the [Pipery documentation](https://docs.pipery.dev) or open an issue on [GitHub](https://github.com/pipery-dev).
