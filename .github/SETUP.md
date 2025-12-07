# GitHub Pages & Actions Setup Checklist

Follow these steps to enable automated chart releases for this repository.

## ✅ Step-by-Step Setup

### 1. Push Initial Code (If Not Already Done)

```bash
# Make sure you're on the main branch
git checkout main

# Add all files
git add .

# Commit
git commit -m "Add ClickHouse Helm chart with automated release workflows"

# Push to GitHub
git push origin main
```

### 2. Enable GitHub Actions Permissions

1. Go to your repository on GitHub
2. Click **Settings** → **Actions** → **General**
3. Scroll down to "Workflow permissions"
4. Select **"Read and write permissions"**
5. Check ✅ **"Allow GitHub Actions to create and approve pull requests"**
6. Click **Save**

### 3. Enable GitHub Pages

1. In your repository, go to **Settings** → **Pages**
2. Under "Build and deployment":
   - **Source**: Deploy from a branch
   - **Branch**: Select `gh-pages` (it will be created automatically on first release)
   - **Folder**: `/ (root)`
3. Click **Save**

> **Note**: The `gh-pages` branch will be created automatically when you push your first chart to `main`.

### 4. Trigger First Release

The easiest way to trigger the first release is to push a commit that modifies a chart:

```bash
# Make a small change to trigger the release
cd charts/clickhouse
# You could update the description or add a comment
echo "# Initial release" >> Chart.yaml
git add Chart.yaml
git commit -m "Trigger initial chart release"
git push origin main
```

### 5. Monitor the Release Process

1. Go to your repository's **Actions** tab
2. You should see two workflows running:
   - ✅ **Lint and Test Charts** - validates the chart
   - ✅ **Release Charts** - packages and publishes the chart

3. Wait for both to complete (usually 2-3 minutes)

### 6. Verify GitHub Pages Is Active

1. After the release workflow completes, check **Settings** → **Pages**
2. You should see: **"Your site is live at https://<username>.github.io/helm-charts"**
3. Click the URL to verify (you should see a blank page or 404 - this is normal)

### 7. Verify the gh-pages Branch

1. Go to your repository and switch to the `gh-pages` branch
2. You should see:
   - `index.yaml` (the Helm repository index)
   - `.cr-release-packages/` directory with your chart `.tgz` files
   - `.cr-index/` directory

### 8. Test Your Helm Repository

```bash
# Add your repository
helm repo add flamarion-charts https://<your-username>.github.io/helm-charts

# Update repositories
helm repo update

# Search for your chart
helm search repo flamarion-charts

# You should see:
# NAME                          CHART VERSION   APP VERSION   DESCRIPTION
# flamarion-charts/clickhouse   0.2.0           25.3.2        A Helm chart for a ClickHouse cluster...

# Test installation (dry-run)
helm install test flamarion-charts/clickhouse --dry-run --debug
```

## 🎉 Success!

If all steps completed successfully, your Helm chart repository is now live!

## 🔄 Making Future Releases

To release a new version of a chart:

1. **Update the version** in `charts/clickhouse/Chart.yaml`:
   ```yaml
   version: 0.3.0  # Bump from 0.2.0
   ```

2. **Make your changes** to the chart

3. **Create a PR**:
   ```bash
   git checkout -b feature/my-improvement
   git add charts/clickhouse/
   git commit -m "Improve ClickHouse chart: add new feature"
   git push origin feature/my-improvement
   ```

4. **Wait for tests** to pass on the PR

5. **Merge to main** - the release happens automatically!

## 🐛 Troubleshooting

### Workflow fails with "Resource not accessible by integration"

**Solution**: You need to enable write permissions for GitHub Actions (see Step 2 above)

### Charts are not being released

**Check**:
- Workflows are enabled: **Settings** → **Actions** → **General** → "Actions permissions"
- Changes were made to files in `charts/` directory
- Version in `Chart.yaml` was incremented
- Check the Actions tab for error messages

### GitHub Pages shows 404

**Wait**: GitHub Pages can take 5-10 minutes to deploy after the first push
**Check**: 
- Settings → Pages shows "Your site is published at..."
- The `gh-pages` branch exists and has content
- Clear browser cache and try again

### Helm repo add fails

**Check**:
- GitHub Pages is enabled and deployed
- Use the correct URL: `https://<username>.github.io/<repository-name>`
- Wait a few minutes after first release

## 📚 Additional Resources

- [RELEASE.md](../../RELEASE.md) - Detailed release process documentation
- [Helm Chart Releaser Action](https://github.com/helm/chart-releaser-action)
- [GitHub Pages Documentation](https://docs.github.com/en/pages)

