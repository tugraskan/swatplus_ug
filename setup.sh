!/usr/bin/env bash
set -euo pipefail

# Install GNU Fortran + CMake
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y \
  build-essential \
  gfortran \
  cmake
