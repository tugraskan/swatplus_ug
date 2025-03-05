#!/bin/bash

# Install necessary dependencies
apt-get update && apt-get install -y \
    curl \
    lsb-release \
    gnupg \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Add Intel oneAPI repository
curl -fsSL https://repositories.intel.com/oneapi/gpgkey | apt-key add - 
echo "deb [arch=amd64] https://repositories.intel.com/oneapi/apt oneapi main" > /etc/apt/sources.list.d/intel-oneapi.list

# Install Intel oneAPI Base Toolkit
apt-get update && apt-get install -y \
    intel-oneapi-basekit \
    intel-oneapi-develkit \
    intel-oneapi-dpcpp-cppjit \
    intel-oneapi-mkl \
    intel-oneapi-tbb

# Clean up
rm -rf /var/lib/apt/lists/*

# Set environment variables for oneAPI
echo "export PATH=/opt/intel/oneapi/compiler/2025.0/bin:$PATH" >> ~/.bashrc
source ~/.bashrc

echo "Intel oneAPI installed successfully."
