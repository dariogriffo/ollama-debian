![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/dariogriffo/ollama-debian/total)
![GitHub Downloads (all assets, latest release)](https://img.shields.io/github/downloads/dariogriffo/ollama-debian/latest/total)
![GitHub Release](https://img.shields.io/github/v/release/dariogriffo/ollama-debian)
![GitHub Release Date](https://img.shields.io/github/release-date/dariogriffo/ollama-debian?display_date=published_at)

# ollama for Debian

This repository contains build scripts to produce the _unofficial_ Debian packages
(.deb) for [ollama](https://github.com/ollama/ollama) hosted at [deb.griffo.io](https://deb.griffo.io)

<p align="center">
⭐⭐⭐ Love using ollama on Debian? Show your support by starring this repo or [subscribing](https://buy.stripe.com/aFa28q8hr0lRdlm4a2enS01) — access to this repository requires a yearly subscription. ⭐⭐⭐
</p>

Currently supported Debian distros are:
- Bookworm (v12)
- Trixie (v13)
- Forky (v14)
- Sid (testing)

**Upstream architectures:** amd64 and arm64 only (upstream also ships rocm/mlx/jetpack variants for amd64/arm64, not general-purpose builds).

This is an unofficial community project to provide a package that's easy to
install on Debian. If you're looking for the ollama source code, see
[ollama](https://github.com/ollama/ollama).

## Install/Update

### The Debian way

```sh
sudo install -d -m 0755 /etc/apt/keyrings
curl -fsSL https://deb.griffo.io/EA0F721D231FDD3A0A17B9AC7808B4DD62C41256.asc | sudo gpg --dearmor --yes -o /etc/apt/keyrings/deb.griffo.io.gpg
echo "deb [signed-by=/etc/apt/keyrings/deb.griffo.io.gpg] https://deb.griffo.io/apt $(lsb_release -sc 2>/dev/null) main" | sudo tee /etc/apt/sources.list.d/deb.griffo.io.list
sudo apt update
sudo apt install -y ollama
```

### Manual Installation

1. Download the .deb package for your Debian version available on
   the [Releases](https://github.com/dariogriffo/ollama-debian/releases) page.
2. Install the downloaded .deb package.

```sh
sudo dpkg -i <filename>.deb
```
## Updating

To update to a new version, just follow any of the installation methods above. There's no need to uninstall the old version; it will be updated correctly.

## Building

### Build for single architecture
```sh
./build.sh <ollama_version> <build_version> <architecture>
# Example: ./build.sh 0.31.2 1 arm64
```

### Build for all architectures
```sh
./build.sh <ollama_version> <build_version> all
# Example: ./build.sh 0.31.2 1 all
```

## Roadmap

- [x] Produce a .deb package on GitHub Releases
- [x] Set up a debian mirror for easier updates
- [x] Multi-architecture support (amd64, arm64)

## Disclaimer

- This repo is not open for issues related to ollama. This repo is only for _unofficial_ Debian packaging.
