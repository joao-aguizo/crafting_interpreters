#!/usr/bin/env bash

# Defensive programming if any command fails, the script fails
set -euo pipefail

check_installed()
{
    echo "Checking for Singularity / Apptainer..."

    # Check if Singularity or Apptainer is already installed
    if command -v apptainer >/dev/null 2>&1; then
        echo "Apptainer is already installed:"
        apptainer --version
        return 0
    fi

    if command -v singularity >/dev/null 2>&1; then
        echo "Singularity is already installed:"
        singularity --version
        return 0
    fi

    echo "Neither Singularity nor Apptainer found."
    return 1
}

install()
{
    # Must be root
    if [[ "$EUID" -ne 0 ]]; then
        echo "ERROR: This script must be run as root (or via sudo)."
        return 1
    fi

    # Detect package manager and install
    if command -v apt-get >/dev/null 2>&1; then
        echo "Detected APT-based system"
        apt-get update
        apt-get install -y apptainer

    elif command -v dnf >/dev/null 2>&1; then
        echo "Detected DNF-based system"
        dnf install -y apptainer

    elif command -v yum >/dev/null 2>&1; then
        echo "Detected YUM-based system"
        yum install -y epel-release
        yum install -y apptainer

    elif command -v zypper >/dev/null 2>&1; then
        echo "Detected Zypper-based system"
        zypper refresh
        zypper install -y apptainer

    else
        echo "ERROR: Unsupported Linux distribution."
        echo "Please install Apptainer/Singularity manually."
        return 1
    fi

    # Final verification
    if command -v apptainer >/dev/null 2>&1; then
        echo "Apptainer installed successfully:"
        apptainer --version
        return 0
    fi

    if command -v singularity >/dev/null 2>&1; then
        echo "Singularity installed successfully:"
        singularity --version
        return 0
    fi

    echo "ERROR: Installation attempted but binary not found."
    return 1
}


if [[ "${1:-}" == "--check" ]]; then
    check_installed
elif [[ "${1:-}" == "--install" ]]; then
    install
else
    check_installed || install
fi