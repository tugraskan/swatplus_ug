# Use the official Ubuntu Jammy-based Dev Container image as a starting point
FROM mcr.microsoft.com/devcontainers/base:jammy

# 0. Pre-set Intel oneAPI environment variables so 'ifx' is available immediately
ENV ONEAPI_ROOT=/opt/intel/oneapi
# Include Intel oneAPI 'latest' symlink for Linux
ENV PATH=$ONEAPI_ROOT/compiler/latest/linux/bin:$PATH
ENV LD_LIBRARY_PATH=$ONEAPI_ROOT/compiler/latest/linux/lib:$LD_LIBRARY_PATH

# 1. Install core build tools, compilers, and debugger
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        gdb \
        gfortran \
        wget \
        gpg \
        lsb-release \
        apt-transport-https \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# 2. Add Intel’s GPG key and oneAPI repository
RUN wget -qO- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
    | gpg --dearmor > /usr/share/keyrings/oneapi-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" \
    > /etc/apt/sources.list.d/oneapi.list

# 3. Install Intel oneAPI Fortran Compiler
RUN apt-get update && \
    apt-get install -y --no-install-recommends intel-oneapi-compiler-fortran && \
    rm -rf /var/lib/apt/lists/*

# 4. Install Python and FORD (Fortran documentation generator)
RUN apt-get update && \
    apt-get install -y --no-install-recommends python3 python3-pip && \
    pip3 install --no-cache-dir ford && \
    rm -rf /var/lib/apt/lists/*

# 5. Source Intel’s setvars script for bash shells
RUN echo "source $ONEAPI_ROOT/setvars.sh" >> /etc/bash.bashrc
