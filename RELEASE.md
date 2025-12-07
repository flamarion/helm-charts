# Helm Chart Release Process

This document explains how to release Helm charts from this repository using GitHub Actions and GitHub Pages.

## Overview

This repository uses GitHub Actions to automatically:
1. **Lint and test** charts on every pull request
2. **Package and release** charts when changes are merged to `main`
3. **Update the Helm repository index** (`index.yaml`) on GitHub Pages
4. **Create GitHub releases** with chart packages as assets

## Initial Setup

### 1. Enable GitHub Pages

1. Go to your repository settings on GitHub
2. Navigate to **Settings** → **Pages**
3. Under "Source", select **Deploy from a branch**
4. Select the **gh-pages** branch and **/ (root)** folder
5. Click **Save**

The `gh-pages` branch will be created automatically by the workflow on the first release.

### 2. Verify Permissions

The workflows require the following permissions (already configured in the workflow files):
- `contents: write` - to create releases and push to gh-pages
- `pages: write` - to deploy to GitHub Pages

These are automatically available via the `GITHUB_TOKEN` secret.

### 3. Repository Settings (Optional but Recommended)

For better security, you can configure branch protection:
1. Go to **Settings** → **Branches**
2. Add a rule for `main`:
   - Require pull request reviews before merging
   - Require status checks to pass (select "lint-test")

## How It Works

### Workflow 1: Lint and Test (`lint-test.yml`)

**Triggers:** Pull requests and pushes to `main` that modify files in `charts/`

**What it does:**
1. Detects which charts have changed
2. Runs `helm lint` to validate chart syntax
3. Creates a temporary Kubernetes cluster (using kind)
4. Installs the chart to verify it works

**Status:** You'll see a ✅ or ❌ on your PRs

### Workflow 2: Release (`release.yml`)

**Triggers:** Pushes to `main` branch that modify files in `charts/`

**What it does:**
1. Packages each changed chart using `helm package`
2. Creates a GitHub Release with the chart `.tgz` file
3. Updates `index.yaml` with the new chart version
4. Commits `index.yaml` to the `gh-pages` branch
5. GitHub Pages automatically serves the updated repository

**Result:** Your chart becomes available at:
```
https://<username>.github.io/helm-charts
```

## Releasing a New Version

### Step 1: Update Chart Version

Edit `charts/<chart-name>/Chart.yaml` and bump the version:

```yaml
version: 0.3.0  # Increment from 0.2.0
```

Follow [Semantic Versioning](https://semver.org/):
- **MAJOR** (1.0.0): Breaking changes
- **MINOR** (0.2.0): New features, backwards compatible
- **PATCH** (0.2.1): Bug fixes

### Step 2: Update Changelog (Recommended)

Document changes in `charts/<chart-name>/README.md` or a `CHANGELOG.md`:

```markdown
## [0.3.0] - 2024-12-07
### Added
- New S3 backup encryption support
### Fixed
- Fixed keeper DNS resolution issue
```

### Step 3: Create a Pull Request

```bash
git checkout -b release/clickhouse-0.3.0
git add charts/clickhouse/Chart.yaml
git commit -m "Release clickhouse chart v0.3.0"
git push origin release/clickhouse-0.3.0
```

Create a PR and wait for the lint/test workflow to pass ✅

### Step 4: Merge to Main

Once the PR is approved and merged:
1. The **release workflow** automatically triggers
2. A new GitHub Release is created (e.g., `clickhouse-0.3.0`)
3. The chart is packaged and attached to the release
4. `index.yaml` is updated on `gh-pages` branch
5. Your chart is now available to install!

### Step 5: Verify Release

Check that everything worked:

1. **GitHub Releases**: Go to your repository's Releases page
   - You should see a new release `clickhouse-0.3.0`
   - The `.tgz` file should be attached

2. **gh-pages Branch**: Check the `gh-pages` branch
   - Should contain `index.yaml`
   - Should contain the chart package in `.cr-release-packages/`

3. **Test Installation**:
```bash
helm repo add flamarion-charts https://<username>.github.io/helm-charts
helm repo update
helm search repo flamarion-charts/clickhouse
# Should show version 0.3.0

helm install test flamarion-charts/clickhouse --version 0.3.0
```

## Chart Versioning Best Practices

### When to Bump MAJOR Version (1.0.0, 2.0.0)
- Breaking changes to values.yaml structure
- Removing configuration options
- Changing default behavior that could break existing deployments
- Upgrading to a new major version of the application

### When to Bump MINOR Version (0.2.0, 0.3.0)
- Adding new features
- Adding new configuration options
- Non-breaking enhancements
- Adding new optional components

### When to Bump PATCH Version (0.2.1, 0.2.2)
- Bug fixes
- Documentation updates
- Minor template improvements
- Updating default values (non-breaking)

## Troubleshooting

### Workflow Fails with "Permission Denied"

**Solution:** Check that GitHub Actions has write permissions:
1. Go to **Settings** → **Actions** → **General**
2. Under "Workflow permissions", select **Read and write permissions**
3. Click **Save**

### Chart Not Appearing After Release

**Check:**
1. Workflow completed successfully (check Actions tab)
2. `gh-pages` branch exists and contains `index.yaml`
3. GitHub Pages is enabled and pointing to `gh-pages` branch
4. Wait a few minutes for GitHub Pages to deploy

### "No chart changes detected"

The workflow only processes charts that have changed since the last commit. If you want to force a release:
1. Make a small change to the chart (e.g., update Chart.yaml description)
2. Commit and push to main

### Chart Installation Fails in Testing

The `lint-test.yml` workflow creates a minimal kind cluster. If your chart requires:
- Specific storage classes
- External services (S3, databases)
- Special node features

You may need to:
1. Add test values in `charts/<chart>/ci/` directory
2. Or skip the install test by adding `# ct-skip-install` in Chart.yaml annotations

## Manual Release (Alternative)

If you prefer to release manually without GitHub Actions:

```bash
# Package the chart
helm package charts/clickhouse

# Create/update the index
helm repo index . --url https://<username>.github.io/helm-charts

# Commit to gh-pages
git checkout gh-pages
git add index.yaml clickhouse-*.tgz
git commit -m "Release clickhouse-0.3.0"
git push origin gh-pages
```

## Resources

- [Helm Chart Releaser Action](https://github.com/helm/chart-releaser-action)
- [Helm Chart Testing](https://github.com/helm/chart-testing)
- [Semantic Versioning](https://semver.org/)
- [GitHub Pages Documentation](https://docs.github.com/en/pages)

