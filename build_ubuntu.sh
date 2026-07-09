#!/bin/bash
set -euo pipefail

# Upstream Linux architectures for ollama (https://github.com/ollama/ollama):
#   amd64  -> ollama-linux-amd64.tar.zst
#   arm64  -> ollama-linux-arm64.tar.zst
#
# amd64 and arm64 only (upstream also ships rocm/mlx/jetpack variants for amd64/arm64, not general-purpose builds).
# TODO: implement ollama build

ollama_VERSION=$1
BUILD_VERSION=$2
ARCH=${3:-amd64}  # Default to amd64 if no architecture specified

if [ -z "$ollama_VERSION" ] || [ -z "$BUILD_VERSION" ]; then
    echo "Usage: $0 <ollama_version> <build_version> [architecture]"
    echo "Example: $0 1.2.3 1 arm64"
    echo "Example: $0 1.2.3 1 all    # Build for all architectures"
    echo "Supported architectures: amd64, arm64, all"
    exit 1
fi

echo "build_ubuntu.sh for ollama is not implemented yet."
exit 1
