#!/bin/bash

# Exit immediately if a command fails
set -e

echo "🚀 Starting Codespace setup..."

# Update package lists
echo "🔄 Updating package lists..."
sudo apt update -y

# Install dependencies
echo "📦 Installing dependencies..."
sudo apt install -y \
    build-essential \
    cmake \
    git \
    gfortran

# Install Intel oneAPI Fortran Compiler (if needed)
if ! command -v ifx &> /dev/null; then
    echo "🛠 Installing Intel oneAPI Fortran Compiler..."
    sudo apt install -y intel-oneapi-compiler-fortran
fi

# Ensure Intel oneAPI environment is sourced on startup
echo "🔧 Setting up Intel oneAPI environment..."
echo 'source /opt/intel/oneapi/setvars.sh' >> ~/.bashrc
source /opt/intel/oneapi/setvars.sh

echo "✅ Setup complete! Codespace is ready to use. 🎉"
