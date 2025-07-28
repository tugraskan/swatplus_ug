#!/usr/bin/env bash
set -euo pipefail

# Install GNU Fortran, CMake, build tools
sudo apt-get update
sudo apt-get install -y build-essential gfortran cmake

# Add Intel oneAPI repository and key
curl -fLo key.gpg https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
sudo gpg --dearmor -o /usr/share/keyrings/oneapi-archive-keyring.gpg key.gpg
echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" \
  | sudo tee /etc/apt/sources.list.d/oneapi.list

# Install Intel oneAPI Fortran compiler
sudo apt-get update
sudo apt-get install -y intel-oneapi-compiler-fortran

# Source Intel environment so `ifx` is available
source /opt/intel/oneapi/setvars.sh --force > /dev/null

# Optional: verify availability
echo "gfortran version:"
gfortran --version
echo "ifx version:"
ifx -v
