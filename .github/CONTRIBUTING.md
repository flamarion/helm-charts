# Contributing to Flamarion Helm Charts

Thank you for your interest in contributing! This document provides guidelines and information for contributors.

## 🎯 Ways to Contribute

- 🐛 Report bugs and issues
- 💡 Suggest new features or charts
- 📖 Improve documentation
- 🔧 Submit bug fixes
- ⭐ Add new charts
- ✅ Help test and review pull requests

## 📋 Before You Start

1. Check [existing issues](https://github.com/flamarion/helm-charts/issues) to avoid duplicates
2. For major changes, open an issue first to discuss your proposal
3. Read through the chart guidelines below

## 🛠️ Development Setup

### Prerequisites

- Kubernetes cluster (kind, minikube, or similar)
- Helm 3.x
- Git

### Local Development

```bash
# Clone the repository
git clone https://github.com/flamarion/helm-charts.git
cd helm-charts

# Create a branch for your changes
git checkout -b feature/my-improvement

# Make your changes
# Test locally (see testing section)

# Commit your changes
git add .
git commit -m "feat: add new feature"
git push origin feature/my-improvement
```

## ✅ Chart Guidelines

All charts should follow these guidelines:

### Required Files

- `Chart.yaml` - Chart metadata
- `values.yaml` - Default configuration with comments
- `README.md` - Comprehensive documentation
- `templates/` - Kubernetes manifests
- `templates/NOTES.txt` - Post-install instructions
- `ci/` - Test values for CI/CD

### Chart.yaml Requirements

```yaml
apiVersion: v2
name: chart-name
description: Clear, concise description
type: application
version: 0.1.0  # Chart version (semver)
appVersion: "x.y.z"  # Application version
keywords:
  - relevant
  - keywords
home: https://flamarion.github.io/helm-charts
maintainers:
  - name: flamarion
    url: https://github.com/flamarion
sources:
  - https://github.com/flamarion/helm-charts
  - https://upstream-project.url
```

### values.yaml Requirements

- All values must have comments explaining their purpose
- Use sensible production-ready defaults
- Group related values together
- Document required vs optional values

### README.md Requirements

Each chart README should include:

1. **Overview** - What the chart does
2. **Prerequisites** - Requirements before installation
3. **Installation** - Quick start guide
4. **Configuration** - Table of all values
5. **Examples** - Common use cases
6. **Upgrading** - Version-specific notes
7. **Uninstalling** - How to remove
8. **Troubleshooting** - Common issues

### Testing Requirements

- Chart must pass `helm lint`
- Chart must render with `helm template`
- Chart must install successfully in CI
- Include test values in `ci/` directory

## 🧪 Testing Your Changes

### Local Testing

```bash
# Lint the chart
helm lint charts/my-chart

# Test template rendering
helm template test charts/my-chart

# Dry-run installation
helm install test charts/my-chart --dry-run --debug

# Actual installation (in test cluster)
helm install test charts/my-chart -n test --create-namespace

# Test upgrade
helm upgrade test charts/my-chart

# Cleanup
helm uninstall test -n test
```

### CI Testing

CI automatically runs when you create a pull request:
- Lints all changed charts
- Tests installation in a kind cluster
- Validates versioning

## 📝 Commit Message Guidelines

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add new PostgreSQL chart
fix: correct ClickHouse backup schedule
docs: improve README for ClickHouse chart
chore: update dependencies
test: add CI test for Redis chart
```

**Types:**
- `feat:` - New feature or chart
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `chore:` - Maintenance tasks
- `test:` - Test changes
- `refactor:` - Code refactoring
- `perf:` - Performance improvements

## 🔄 Pull Request Process

1. **Create a branch** from `main`
2. **Make your changes** following the guidelines
3. **Test locally** to ensure everything works
4. **Update documentation** if needed
5. **Create a pull request** with a clear description
6. **Wait for CI** to pass
7. **Address review feedback** if any
8. **Merge** once approved

### PR Description Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] New chart
- [ ] Bug fix
- [ ] Feature enhancement
- [ ] Documentation update
- [ ] Breaking change

## Testing
- [ ] Tested locally
- [ ] Passes helm lint
- [ ] Installs successfully
- [ ] Updated tests

## Checklist
- [ ] Updated Chart.yaml version
- [ ] Updated README.md
- [ ] Added/updated values.yaml comments
- [ ] Added CI test values
```

## 📈 Versioning

We use [Semantic Versioning](https://semver.org/):

- **MAJOR** (1.0.0): Breaking changes
- **MINOR** (0.1.0): New features, backwards compatible
- **PATCH** (0.0.1): Bug fixes

Always increment the chart version in `Chart.yaml` when making changes.

## 🎨 Code Style

### YAML Style

- Use 2 spaces for indentation
- Use `kebab-case` for keys
- Keep lines under 120 characters
- Add comments for complex logic

### Template Style

- Use meaningful template names
- Add comments explaining complex templates
- Follow Helm best practices
- Use `_helpers.tpl` for reusable templates

## 📜 License

By contributing, you agree that your contributions will be licensed under the same license as the project (CC BY-ND 4.0).

## ❓ Questions?

- Open an [issue](https://github.com/flamarion/helm-charts/issues)
- Start a [discussion](https://github.com/flamarion/helm-charts/discussions)

Thank you for contributing! 🎉

