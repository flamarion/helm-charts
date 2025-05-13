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

Shield: [![CC BY-ND 4.0][cc-by-nd-shield]][cc-by-nd]

This work is licensed under a
[Creative Commons Attribution-NoDerivs 4.0 International License][cc-by-nd].

[![CC BY-ND 4.0][cc-by-nd-image]][cc-by-nd]

[cc-by-nd]: https://creativecommons.org/licenses/by-nd/4.0/
[cc-by-nd-image]: https://licensebuttons.net/l/by-nd/4.0/88x31.png
[cc-by-nd-shield]: https://img.shields.io/badge/License-CC%20BY--ND%204.0-lightgrey.svg


## 🙏 Thanks

Thanks for visiting! I hope these charts make your Kubernetes experience smoother.
