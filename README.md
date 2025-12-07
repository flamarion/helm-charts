# 🧭 Helm Charts by flamarion

[![Release Charts](https://github.com/flamarion/helm-charts/actions/workflows/release.yml/badge.svg)](https://github.com/flamarion/helm-charts/actions/workflows/release.yml)
[![Lint and Test Charts](https://github.com/flamarion/helm-charts/actions/workflows/lint-test.yml/badge.svg)](https://github.com/flamarion/helm-charts/actions/workflows/lint-test.yml)
[![License: CC BY-ND 4.0](https://img.shields.io/badge/License-CC%20BY--ND%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nd/4.0/)
![Helm: v3](https://img.shields.io/badge/Helm-v3-informational?logo=helm)

**Production-ready Helm charts for self-hosted Kubernetes deployments**

A curated collection of Helm charts featuring automated CI/CD, comprehensive testing, and extensive documentation. Built for production use with best practices and real-world experience.

## ⭐ Features

- 🚀 **Production Ready** - Battle-tested configurations used in real deployments
- 🔄 **Automated Releases** - Full CI/CD pipeline with GitHub Actions
- ✅ **Quality Assured** - Automatic linting and testing before every release
- 📚 **Well Documented** - Comprehensive guides, examples, and troubleshooting
- 🛠️ **Best Practices** - Follows Helm and Kubernetes community standards
- 🔒 **Secure by Default** - Security contexts, RBAC, and principle of least privilege

## 📦 Available Charts

Each chart includes comprehensive documentation, production-ready defaults, and extensive configuration options.

| Chart | Description | Version | App Version | Category |
|-------|-------------|---------|-------------|----------|
| [clickhouse](charts/clickhouse/) | Distributed OLAP database with integrated Keeper | 0.2.0 | 25.3.2 | Database |

> 💡 **More charts coming soon!** Watch this repository to get notified of new releases.

### Chart Categories

- **🗄️ Databases** - ClickHouse (more coming)
- **📊 Monitoring** - Coming soon
- **🔧 Infrastructure** - Coming soon
- **💾 Storage** - Coming soon

## 🚀 Quick Start

### Add the Helm Repository

```bash
helm repo add flamarion-charts https://flamarion.github.io/helm-charts
helm repo update
```

### Search Available Charts

```bash
helm search repo flamarion-charts
```

### Install a Chart

```bash
# Install ClickHouse
helm install my-clickhouse flamarion-charts/clickhouse

# Install with custom values
helm install my-clickhouse flamarion-charts/clickhouse -f my-values.yaml

# Install specific version
helm install my-clickhouse flamarion-charts/clickhouse --version 0.2.0
```

### Chart Documentation

Each chart has detailed documentation in its directory:
- **ClickHouse**: [charts/clickhouse/README.md](charts/clickhouse/README.md)

## 🔄 Automated Releases

This repository uses GitHub Actions to automatically test, package, and release charts:

- **Lint & Test**: Every pull request is automatically tested
- **Release**: Charts are automatically packaged and published when merged to `main`
- **Versioning**: Follow [Semantic Versioning](https://semver.org/) in `Chart.yaml`

See [RELEASE.md](RELEASE.md) for detailed release instructions.

## 💬 Getting Help

- 📖 **Documentation**: Check individual chart READMEs
- 🐛 **Bug Reports**: [Open an issue](https://github.com/flamarion/helm-charts/issues/new)
- 💡 **Feature Requests**: [Start a discussion](https://github.com/flamarion/helm-charts/discussions)
- ❓ **Questions**: [GitHub Discussions](https://github.com/flamarion/helm-charts/discussions)

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! 

- Found a bug? [Open an issue](https://github.com/flamarion/helm-charts/issues)
- Have an idea? [Start a discussion](https://github.com/flamarion/helm-charts/discussions)
- Want to contribute? Check out the chart source code

## 🗺️ Roadmap

Planned charts and features:

- [ ] PostgreSQL with automated backups
- [ ] Redis cluster with Sentinel
- [ ] Prometheus stack
- [ ] Grafana with dashboards
- [ ] MinIO distributed storage
- [ ] GitLab Runner

Vote for charts you'd like to see in [Discussions](https://github.com/flamarion/helm-charts/discussions)!

## 📜 License

Shield: [![CC BY-ND 4.0][cc-by-nd-shield]][cc-by-nd]

This work is licensed under a
[Creative Commons Attribution-NoDerivs 4.0 International License][cc-by-nd].

[![CC BY-ND 4.0][cc-by-nd-image]][cc-by-nd]

[cc-by-nd]: https://creativecommons.org/licenses/by-nd/4.0/
[cc-by-nd-image]: https://licensebuttons.net/l/by-nd/4.0/88x31.png
[cc-by-nd-shield]: https://img.shields.io/badge/License-CC%20BY--ND%204.0-lightgrey.svg


## ⭐ Show Your Support

If you find these charts useful, please consider:
- ⭐ Starring this repository
- 🐛 Reporting bugs or issues you encounter
- 💡 Suggesting new features or charts
- 📢 Sharing with others who might benefit

## 🙏 Acknowledgments

- Built with inspiration from the Helm community
- Thanks to all chart maintainers for their examples and best practices
- Special thanks to the ClickHouse team for their excellent documentation

---

**Made with ❤️ for the Kubernetes community**
