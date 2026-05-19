---
title: "README"
output: html_document
---

# installPackagesAnywhere

🚀 Install R packages from **CRAN**, **Bioconductor**, or **GitHub** automatically.

This package provides a convenient function that attempts to install R packages from multiple sources in a smart order:

1. CRAN  
2. Bioconductor  
3. GitHub (auto-search or user-defined mapping)

If a package cannot be found, it is returned so you can investigate manually.

---

## ✨ Features

- ✅ Automatically detects package availability
- ✅ Supports CRAN and Bioconductor seamlessly
- ✅ Searches GitHub repositories automatically
- ✅ Allows manual GitHub repository overrides
- ✅ Skips already installed packages
- ✅ Returns a list of missing packages

---

## 📥 Installation

You can install this package directly from GitHub:

```r
install.packages("remotes")
remotes::install_github("MiguelJulia/installPackagesAnywhere")
```

---

## 🚀 Usage

Basic example

```r
library(installPackagesAnywhere)

packages <- c("ggplot2", "DESeq2", "SeuratDisk", "unknownPackage")

missing <- install.packages.from.anywhere(packages)

print(missing)
```

With GitHub repository mapping (recommended)
Some packages are not easily discoverable automatically on GitHub. You can specify them explicitly:

```r

github_map <- c(
  "SeuratDisk" = "mojaveazure/seurat-disk"
)

missing <- install.packages.from.anywhere(
  packages = c("SeuratDisk", "SomeRarePackage"),
  github_map = github_map
)

```

---

## ⚙️ Function Overview

### `install.packages.from.anywhere()`

Arguments:

- `packages`
    Character vector of package names to install

- `github_map` (optional)
    Named character vector mapping package names to GitHub repositories ("owner/repo")

- `update` (default = FALSE)
    Whether to update dependencies when installing from Bioconductor

- `verbose` (default = TRUE)
    Whether to print progress messages

---

## 📤 Output

The function returns a list of packages that could not be installed from any source.

---

## ⚠️ Notes

GitHub auto-search uses heuristics and may not always find the correct repository
For reproducibility, it is recommended to define github_map for critical packages
GitHub API requests are subject to rate limits (60 requests/hour without authentication)

---

## 🔮 Future Improvements

GitHub token support to avoid API limits
Parallel installation
Improved repository validation
CRAN submission

---

## 👤 Author

MiguelJulia

---

## 📄 License

MIT License

