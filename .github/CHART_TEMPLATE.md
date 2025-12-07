# Chart Template & Checklist

Use this template when creating a new chart for this repository.

## 📁 Directory Structure

```
charts/my-chart/
├── Chart.yaml              # Chart metadata
├── values.yaml             # Default values with comments
├── README.md              # Chart documentation
├── .helmignore            # Files to ignore when packaging
├── templates/
│   ├── NOTES.txt          # Post-install notes
│   ├── _helpers.tpl       # Template helpers
│   ├── deployment.yaml    # Main resources
│   ├── service.yaml
│   ├── configmap.yaml
│   ├── serviceaccount.yaml
│   └── ...
└── ci/
    └── default-values.yaml # CI test values
```

## ✅ Chart Creation Checklist

### 1. Initial Setup
- [ ] Create chart directory in `charts/`
- [ ] Copy `.helmignore` from existing chart
- [ ] Create basic `Chart.yaml`
- [ ] Create `values.yaml` with defaults
- [ ] Create `templates/_helpers.tpl`

### 2. Chart.yaml
- [ ] Set correct `apiVersion: v2`
- [ ] Choose descriptive name (lowercase, hyphens)
- [ ] Write clear description (1-2 sentences)
- [ ] Set `type: application`
- [ ] Set initial version to `0.1.0`
- [ ] Set correct appVersion
- [ ] Add 5-10 relevant keywords
- [ ] Set home URL
- [ ] Add maintainer info
- [ ] Add source URLs

### 3. Templates
- [ ] Create ServiceAccount template
- [ ] Create ConfigMap/Secret templates
- [ ] Create Deployment/StatefulSet template
- [ ] Create Service template
- [ ] Add proper labels using helpers
- [ ] Add resource limits and requests
- [ ] Add security contexts
- [ ] Add liveness/readiness probes
- [ ] Support custom annotations
- [ ] Support nodeSelector, tolerations, affinity
- [ ] Create NOTES.txt with usage instructions

### 4. values.yaml
- [ ] Add header comment explaining the file
- [ ] Comment every value
- [ ] Use production-ready defaults
- [ ] Group related values
- [ ] Include common patterns:
  - [ ] Image repository and tag
  - [ ] Service configuration
  - [ ] Resource limits/requests
  - [ ] Persistence settings
  - [ ] Security contexts
  - [ ] nodeSelector, tolerations, affinity

### 5. README.md
- [ ] Add chart title and description
- [ ] Document prerequisites
- [ ] Add installation instructions
- [ ] Create parameters table
- [ ] Add configuration examples
- [ ] Document upgrading process
- [ ] Add troubleshooting section
- [ ] Include uninstall instructions

### 6. Testing
- [ ] Create `ci/default-values.yaml`
- [ ] Test with `helm lint`
- [ ] Test with `helm template`
- [ ] Test installation in local cluster
- [ ] Test upgrade process
- [ ] Test uninstallation

### 7. Documentation
- [ ] Update main repository README
- [ ] Add chart to the charts table
- [ ] Add badge if applicable

### 8. Quality Checks
- [ ] No hardcoded values in templates
- [ ] All templates use helpers for names/labels
- [ ] Resource names follow conventions
- [ ] No secrets in values.yaml
- [ ] Follows security best practices
- [ ] Uses semantic versioning

## 📋 Chart.yaml Template

```yaml
apiVersion: v2
name: my-chart
description: Brief description of what this chart does
type: application
version: 0.1.0
appVersion: "1.0.0"

keywords:
  - keyword1
  - keyword2
  - keyword3

home: https://flamarion.github.io/helm-charts
icon: https://example.com/icon.svg

maintainers:
  - name: flamarion
    url: https://github.com/flamarion

sources:
  - https://github.com/flamarion/helm-charts
  - https://github.com/upstream/project

annotations:
  artifacthub.io/changes: |
    - kind: added
      description: Initial release
  artifacthub.io/links: |
    - name: Documentation
      url: https://example.com/docs
```

## 📋 values.yaml Template

```yaml
# Default values for my-chart
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

# -- Override the name of the chart
nameOverride: ""
# -- Override the full name of the release
fullnameOverride: ""

# Image configuration
image:
  # -- Image repository
  repository: myapp/myimage
  # -- Image pull policy
  pullPolicy: IfNotPresent
  # -- Image tag (defaults to chart appVersion)
  tag: ""

# -- Image pull secrets
imagePullSecrets: []

# Service account configuration
serviceAccount:
  # -- Create service account
  create: true
  # -- Annotations for service account
  annotations: {}
  # -- Service account name
  name: ""

# Service configuration
service:
  # -- Service type
  type: ClusterIP
  # -- Service port
  port: 80

# Resource limits and requests
resources:
  limits:
    cpu: 100m
    memory: 128Mi
  requests:
    cpu: 100m
    memory: 128Mi

# Pod annotations
podAnnotations: {}

# Pod security context
podSecurityContext: {}

# Container security context
securityContext: {}

# Node selector
nodeSelector: {}

# Tolerations
tolerations: []

# Affinity rules
affinity: {}
```

## 📋 README.md Template

````markdown
# Chart Name

Brief description of what this chart deploys.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- Other requirements

## Installation

### Add Repository

```bash
helm repo add flamarion-charts https://flamarion.github.io/helm-charts
helm repo update
```

### Install Chart

```bash
helm install my-release flamarion-charts/my-chart
```

## Configuration

The following table lists the configurable parameters:

| Parameter          | Description      | Default            |
| ------------------ | ---------------- | ------------------ |
| `image.repository` | Image repository | `myapp/myimage`    |
| `image.tag`        | Image tag        | `chart appVersion` |
| `service.type`     | Service type     | `ClusterIP`        |

## Examples

### Basic Installation

```bash
helm install my-release flamarion-charts/my-chart
```

### Custom Values

```yaml
# values.yaml
resources:
  limits:
    memory: 256Mi
```

```bash
helm install my-release flamarion-charts/my-chart -f values.yaml
```

## Upgrading

```bash
helm upgrade my-release flamarion-charts/my-chart
```

## Uninstalling

```bash
helm uninstall my-release
```

## Troubleshooting

Common issues and solutions.
````

## 🚀 Ready to Create?

1. Copy this checklist
2. Follow each step
3. Test thoroughly
4. Create a pull request

Good luck! 🎉

