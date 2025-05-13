# 🧭 Helm Charts by flamarion

Welcome! This repository contains a collection of Helm charts that I've created primarily for my own Kubernetes projects. While these charts are built for personal use, I'm happy to share them in case they help others as well.

## 📦 Available Charts

Charts are stored in the `charts/` directory. Each chart includes its own documentation and default `values.yaml`.

| Chart Name   | Description                          | Status   |
|--------------|--------------------------------------|----------|

More charts will be added over time.

## 🚀 How to Use

Once GitHub Pages is enabled on this repository, you can use it as a Helm chart repository:

```bash
helm repo add flamarion-charts https://flamarion.github.io/helm-charts
helm repo update
helm install my-release flamarion-charts/clickhouse
```

## 🤝 Contributions

These charts are built with my own workflows in mind, but suggestions and improvements are always welcome.  
Feel free to open an issue or submit a pull request.

## 📜 License

This repository is licensed under the **Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)** license.

You are free to:
- **Share** — copy and redistribute the material
- **Adapt** — remix, transform, and build upon the material

**As long as you:**
- **Give appropriate credit**
- **Do not use the material for commercial purposes**

See the [LICENSE](LICENSE) file for the full license text.

## 🙏 Thanks

Thanks for visiting! I hope these charts make your Kubernetes experience smoother.
