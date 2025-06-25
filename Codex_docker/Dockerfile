# Custom Fortran Development Image
# Place this file at: swatplus_ug/Codex_docker/Dockerfile
# Base on Ubuntu Jammy via Microsoft's Dev Container image for local builds
FROM mcr.microsoft.com/devcontainers/base:jammy

# Install essential build tools, compilers, Python, and documentation generator
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential     # includes make, gcc, etc. \
        gfortran            # GNU Fortran compiler \
        cmake               # build system generator \
        gdb                 # debugger \
        git                 # version control (optional if needed in-container) \
        python3             # Python runtime \
        python3-pip         # pip for Python 3 \
        wget gpg lsb-release apt-transport-https ca-certificates && \
    # Install FORD (Fortran documentation generator)
    pip3 install --no-cache-dir ford && \
    # Add Intel oneAPI APT key and repository
    wget -qO- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
        | gpg --dearmor > /usr/share/keyrings/oneapi-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" \
        > /etc/apt/sources.list.d/oneAPI.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends intel-oneapi-compiler-fortran && \
    # Clean up APT and pip caches
    rm -rf /var/lib/apt/lists/*

# Ensure every shell sources Intel's setvars so 'ifx' is on PATH
RUN echo "source /opt/intel/oneapi/setvars.sh" >> /etc/bash.bashrc

# Expose Intel compiler binaries and libraries
ENV PATH=/opt/intel/oneapi/compiler/2025.0/bin:$PATH \
    LD_LIBRARY_PATH=/opt/intel/oneapi/compiler/2025.0/lib:$LD_LIBRARY_PATH
