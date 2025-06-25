# Custom Fortran Development Image with gfortran & Intel ifx
# Place this file at: swatplus_ug/Codex_docker/Dockerfile
# Base on Ubuntu Jammy via Microsoft's Dev Container for local builds
FROM mcr.microsoft.com/devcontainers/base:jammy

# Install core build tools, gfortran, Python, FORD, and Intel oneAPI repo
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        gfortran \
        cmake \
        gdb \
        git \
        python3 python3-pip \
        wget gpg lsb-release apt-transport-https ca-certificates && \
    pip3 install --no-cache-dir ford && \
    # Add Intel oneAPI repository
    wget -qO- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
        | gpg --dearmor > /usr/share/keyrings/oneapi-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" \
        > /etc/apt/sources.list.d/oneapi.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends intel-oneapi-compiler-fortran && \
    rm -rf /var/lib/apt/lists/*

# Set environment so both gfortran and ifx are on the PATH
ENV PATH=/opt/intel/oneapi/compiler/2025.0/bin:$PATH \
    LD_LIBRARY_PATH=/opt/intel/oneapi/compiler/2025.0/lib:$LD_LIBRARY_PATH
