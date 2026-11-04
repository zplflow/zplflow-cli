# zplflow CLI

[![Release](https://img.shields.io/github/v/release/zplflow/zplflow-cli?style=flat-square)](https://github.com/zplflow/zplflow-cli/releases)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg?style=flat-square)](https://opensource.org/licenses/Apache-2.0)
[![Documentation](https://img.shields.io/badge/docs-zplflow.io-orange?style=flat-square)](https://zplflow.io/docs/cli)

The **zplflow** command-line tool provides enterprise-grade thermal label conversion infrastructure directly in your terminal. Convert between ZPL, PDF, and EPL, run GS1/WMS pipeline transformations, manage asynchronous jobs, and administer API keys — with zero runtime dependencies.

Pre-built binaries are statically compiled for **Linux**, **macOS**, and **Windows** on both **amd64** and **arm64** architectures.

---

## Installation

### macOS / Linux (Homebrew)

```bash
brew install zplflow/tap/zplflow
```

Or tap first:

```bash
brew tap zplflow/tap
brew install zplflow
```

### Windows (Scoop)

```powershell
scoop bucket add zplflow https://github.com/zplflow/scoop-bucket
scoop install zplflow
```

### Windows (winget)

```powershell
winget install zplflow.zplflow
```

### Automated Script (macOS & Linux)

Install the latest standalone static binary into `/usr/local/bin` (or `~/.local/bin`):

```bash
curl -fsSL https://raw.githubusercontent.com/zplflow/zplflow-cli/main/scripts/install-cli.sh | bash
```

### Manual Download

Standalone binaries (`.tar.gz` and `.zip`), Debian (`.deb`), and Red Hat (`.rpm`) packages are available on the [GitHub Releases](https://github.com/zplflow/zplflow-cli/releases) page.

---

## Quick Start

1. **Set your API Key** (obtain from [zplflow.io](https://zplflow.io)):

   ```bash
   export ZPLFLOW_API_KEY="lb_your_api_key_here"
   ```

2. **Convert a PDF to ZPL**:

   ```bash
   zplflow convert shipping_label.pdf --to zpl --save label.zpl
   ```

3. **Convert ZPL to PDF**:

   ```bash
   zplflow convert label.zpl --to pdf --save preview.pdf
   ```

4. **Verify installation**:

   ```bash
   zplflow version
   ```

---

## Documentation

Full command-line reference, options, pipeline manipulation, and CI/CD automation guides are available at:

📚 **[https://zplflow.io/docs/cli](https://zplflow.io/docs/cli)**

---

## License

This project is licensed under the [Apache License 2.0](LICENSE).
