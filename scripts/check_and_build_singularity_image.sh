#!/usr/bin/env bash

set -eu

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

IMAGE="$ROOT_DIR/env.sif"
DEF="$ROOT_DIR/env.def"

check_built()
{
    echo "Checking for existing SIF image: $IMAGE"

    # Check if image already exists
    if [ -f "$IMAGE" ]; then
        echo "SIF image already exists: $IMAGE"
        echo "Nothing to do."
        return 0
    fi

    echo "SIF image not found."
    return 1
}

build()
{
    # Detect Singularity / Apptainer
    if command -v apptainer >/dev/null 2>&1; then
        RUNTIME="apptainer"
    elif command -v singularity >/dev/null 2>&1; then
        RUNTIME="singularity"
    else
        echo "ERROR: Neither apptainer nor singularity is installed."
        return 1
    fi

    # Build requires root in most setups
    if [ "$(id -u)" -ne 0 ]; then
        echo "ERROR: Building a SIF image requires root privileges."
        echo "Run this script as root or via sudo."
        return 1
    fi

    "$RUNTIME" build "$IMAGE" "$DEF"

    echo "Build completed successfully: $IMAGE"
    return 0
}


if [[ "${1:-}" == "--check" ]]; then
    check_built
elif [[ "${1:-}" == "--build" ]]; then
    build
else
    check_built || build
fi