## Use an official Ubuntu base image as the starting point
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies and curl
RUN apt-get update && apt-get install -y \
    curl \
    lsb-release \
    gnupg \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Add the Intel oneAPI repository to the system
RUN curl -fsSL https://repositories.intel.com/oneapi/gpgkey | apt-key add - \
    && echo "deb [arch=amd64] https://repositories.intel.com/oneapi/apt oneapi main" > /etc/apt/sources.list.d/intel-oneapi.list

# Install Intel oneAPI Base Toolkit
RUN apt-get update && apt-get install -y \
    intel-oneapi-basekit \
    intel-oneapi-develkit

# Install additional Intel oneAPI toolkits as needed
RUN apt-get install -y \
    intel-oneapi-dpcpp-cppjit \
    intel-oneapi-mkl \
    intel-oneapi-tbb

# Clean up to reduce image size
RUN rm -rf /var/lib/apt/lists/*

# Optional: Set up environment variables to use oneAPI
ENV PATH="/opt/intel/oneapi/bin:$PATH"
