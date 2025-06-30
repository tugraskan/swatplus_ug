#!/usr/bin/env bash
set -euo pipefail

# Install GNU Fortran + CMake
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y \
  build-essential \
  gfortran \
  cmake \
  wget

# (Optional) Intel oneAPI Fortran if you’ve vendored the tarball
if [ -f oneapi-fortran.tgz ]; then
  echo "Installing Intel oneAPI Fortran compiler…"
  tar xzf oneapi-fortran.tgz -C /opt
  bash /opt/oneapi/install.sh --silent --eula accept
  source /opt/intel/oneapi/setvars.sh
fi
