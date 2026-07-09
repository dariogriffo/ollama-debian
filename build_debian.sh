#!/bin/bash
set -euo pipefail

ollama_VERSION=$1
BUILD_VERSION=$2
ARCH=${3:-amd64}  # Default to amd64 if no architecture specified

if [ -z "$ollama_VERSION" ] || [ -z "$BUILD_VERSION" ]; then
    echo "Usage: $0 <ollama_version> <build_version> [architecture]"
    echo "Example: $0 0.31.2 1 arm64"
    echo "Example: $0 0.31.2 1 all    # Build for all architectures"
    echo "Supported architectures: amd64, arm64, all"
    exit 1
fi

# Function to map Debian architecture to ollama release name
get_ollama_release() {
    local arch=$1
    case "$arch" in
        "amd64")
            echo "ollama-linux-amd64"
            ;;
        "arm64")
            echo "ollama-linux-arm64"
            ;;
        *)
            echo ""
            ;;
    esac
}

# Function to build for a specific architecture
build_architecture() {
    local build_arch=$1
    local ollama_release

    ollama_release=$(get_ollama_release "$build_arch")
    if [ -z "$ollama_release" ]; then
        echo "❌ Unsupported architecture: $build_arch"
        echo "Supported architectures: amd64, arm64"
        return 1
    fi

    echo "Building for architecture: $build_arch using $ollama_release"

    # Clean up any previous builds for this architecture
    rm -rf "$ollama_release" || true
    rm -f "${ollama_release}.tar.zst" || true

    # Download and extract ollama binary for this architecture
    if ! wget "https://github.com/ollama/ollama/releases/download/v${ollama_VERSION}/${ollama_release}.tar.zst"; then
        echo "❌ Failed to download ollama binary for $build_arch"
        return 1
    fi

    mkdir -p "$ollama_release"
    if ! tar --zstd -xf "${ollama_release}.tar.zst" -C "$ollama_release"; then
        echo "❌ Failed to extract ollama binary for $build_arch"
        return 1
    fi

    rm -f "${ollama_release}.tar.zst"

    # Build packages for appropriate Debian distributions
    declare -a arr=("bookworm" "trixie" "forky" "sid")

    for dist in "${arr[@]}"; do
        FULL_VERSION="$ollama_VERSION-${BUILD_VERSION}+${dist}_${build_arch}"
        echo "  Building $FULL_VERSION"

        if ! docker build . -t "ollama-$dist-$build_arch" \
            --build-arg DEBIAN_DIST="$dist" \
            --build-arg ollama_VERSION="$ollama_VERSION" \
            --build-arg BUILD_VERSION="$BUILD_VERSION" \
            --build-arg FULL_VERSION="$FULL_VERSION" \
            --build-arg ARCH="$build_arch" \
            --build-arg OLLAMA_RELEASE="$ollama_release"; then
            echo "❌ Failed to build Docker image for $dist on $build_arch"
            return 1
        fi

        id="$(docker create "ollama-$dist-$build_arch")"
        if ! docker cp "$id:/ollama_$FULL_VERSION.deb" - > "./ollama_$FULL_VERSION.deb"; then
            echo "❌ Failed to extract .deb package for $dist on $build_arch"
            return 1
        fi

        if ! tar -xf "./ollama_$FULL_VERSION.deb"; then
            echo "❌ Failed to extract .deb contents for $dist on $build_arch"
            return 1
        fi

        # ollama bundles CUDA runtime libraries, so images are multiple GB each.
        # Remove the container and image right away to keep CI runner disk usage bounded.
        docker rm "$id" > /dev/null || true
        docker rmi "ollama-$dist-$build_arch" > /dev/null || true
    done

    # Clean up extracted directory
    rm -rf "$ollama_release" || true

    echo "✅ Successfully built for $build_arch"
    return 0
}

# Main build logic
if [ "$ARCH" = "all" ]; then
    echo "🚀 Building ollama $ollama_VERSION-$BUILD_VERSION for all supported architectures..."
    echo ""

    # All supported architectures
    ARCHITECTURES=("amd64" "arm64")

    for build_arch in "${ARCHITECTURES[@]}"; do
        echo "==========================================="
        echo "Building for architecture: $build_arch"
        echo "==========================================="

        if ! build_architecture "$build_arch"; then
            echo "❌ Failed to build for $build_arch"
            exit 1
        fi

        echo ""
    done

    echo "🎉 All architectures built successfully!"
    echo "Generated packages:"
    ls -la ollama_*.deb
else
    # Build for single architecture
    if ! build_architecture "$ARCH"; then
        exit 1
    fi
fi
