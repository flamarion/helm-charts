# Quick Reference Guide

## 📋 Common Commands

### For Chart Developers

```bash
# Lint a chart locally
helm lint charts/clickhouse

# Test template rendering
helm template my-release charts/clickhouse

# Package a chart
helm package charts/clickhouse

# Test installation (dry-run)
helm install test charts/clickhouse --dry-run --debug

# Install locally for testing
helm install test charts/clickhouse -n test-namespace --create-namespace
```

### For Chart Users

```bash
# Add the repository
helm repo add flamarion-charts https://flamarion.github.io/helm-charts

# Update repositories
helm repo update

# Search for charts
helm search repo flamarion-charts

# Show chart information
helm show chart flamarion-charts/clickhouse
helm show values flamarion-charts/clickhouse
helm show readme flamarion-charts/clickhouse

# Install a chart
helm install my-release flamarion-charts/clickhouse

# Install with custom values
helm install my-release flamarion-charts/clickhouse -f my-values.yaml

# Upgrade a release
helm upgrade my-release flamarion-charts/clickhouse

# Uninstall a release
helm uninstall my-release
```

## 🔄 Release Workflow

### Quick Release Process

1. **Bump version** in `charts/*/Chart.yaml`
2. **Commit and push** to a branch
3. **Create PR** → wait for ✅ tests
4. **Merge to main** → automatic release!

### Version Numbers

- `0.2.1` → Bug fix (PATCH)
- `0.3.0` → New feature (MINOR)
- `1.0.0` → Breaking change (MAJOR)

## 📁 Repository Structure

```
helm-charts/
├── .github/
│   ├── workflows/
│   │   ├── lint-test.yml      # Tests charts on PR
│   │   └── release.yml         # Releases charts to gh-pages
│   ├── ct.yaml                 # Chart testing config
│   ├── SETUP.md                # Initial setup guide
│   └── QUICK_REFERENCE.md      # This file
├── charts/
│   └── clickhouse/
│       ├── Chart.yaml          # Chart metadata & version
│       ├── values.yaml         # Default values
│       ├── README.md           # Chart documentation
│       ├── ci/                 # CI test values
│       └── templates/          # Kubernetes templates
├── README.md                   # Repository README
├── RELEASE.md                  # Detailed release guide
└── LICENSE                     # License file
```

## 🌐 Important URLs

| Resource | URL |
|----------|-----|
| GitHub Repository | `https://github.com/<username>/helm-charts` |
| Helm Repository | `https://<username>.github.io/helm-charts` |
| Repository Index | `https://<username>.github.io/helm-charts/index.yaml` |
| GitHub Releases | `https://github.com/<username>/helm-charts/releases` |
| GitHub Pages Settings | `https://github.com/<username>/helm-charts/settings/pages` |
| Actions Workflows | `https://github.com/<username>/helm-charts/actions` |

## 🔍 Workflow Status Badges

Add these to your README.md:

```markdown
[![Release Charts](https://github.com/<username>/helm-charts/actions/workflows/release.yml/badge.svg)](https://github.com/<username>/helm-charts/actions/workflows/release.yml)

[![Lint and Test Charts](https://github.com/<username>/helm-charts/actions/workflows/lint-test.yml/badge.svg)](https://github.com/<username>/helm-charts/actions/workflows/lint-test.yml)
```

## 🐛 Quick Troubleshooting

| Problem | Solution |
|---------|----------|
| Workflow fails with permission error | Enable write permissions in Settings → Actions |
| GitHub Pages shows 404 | Wait 5-10 minutes, check gh-pages branch exists |
| Chart not releasing | Ensure version was bumped in Chart.yaml |
| Tests failing | Check Actions tab for detailed logs |
| Helm repo add fails | Verify GitHub Pages is enabled and deployed |

## 📖 Documentation Files

- **[SETUP.md](.github/SETUP.md)** - First-time setup instructions
- **[RELEASE.md](../RELEASE.md)** - Comprehensive release guide
- **[Chart README](../charts/clickhouse/README.md)** - ClickHouse chart documentation

## 💡 Pro Tips

1. **Always bump the version** in Chart.yaml when making changes
2. **Use semantic versioning** (MAJOR.MINOR.PATCH)
3. **Test locally first** with `helm lint` and `helm template`
4. **Wait for CI checks** to pass before merging PRs
5. **Document changes** in chart README or CHANGELOG
6. **Use meaningful commit messages** for better release notes

## 🎯 Next Steps

1. ✅ Complete initial setup (see SETUP.md)
2. ✅ Push your first release
3. ✅ Test the Helm repository
4. 🚀 Share your charts with others!

