# AGENTS.md

## Setup Instructions

Set up Intel oneAPI toolchain including the ifx Fortran compiler:

```bash
# Add Intel apt key and repository
curl -Lo- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
  | sudo gpg --dearmor -o /usr/share/keyrings/oneapi-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" \
  | sudo tee /etc/apt/sources.list.d/oneapi.list

sudo apt update

# Install the Intel Fortran compiler package (includes ifx)
sudo apt install -y intel-oneapi-compiler-fortran
```

```bash
# Load environment variables to make ifx and ifort available
source /opt/intel/oneapi/setvars.sh --force > /dev/null

# (Optional) For mixed-language support:
# source /opt/intel/oneapi/compiler/202*/env/vars.sh intel64
```

## Build & Test Instructions

Run your project's build and test commands using `ifx`:

```bash
# Compile Fortran source files
ifx -std2023 -O2 your_module.f90 -o your_program

# Or use Makefile/CMake invocation
make all

# Run unit tests or example binary
./your_program --test
```

## Notes & Tips

- Ensure **Intel Fortran compiler** (`intel-oneapi-compiler-fortran`) comes from **HPC Toolkit**, not Base Toolkit :contentReference[oaicite:1]{index=1}.
- Always **source `setvars.sh`**, which initializes environment variables and exposes `ifx` executable :contentReference[oaicite:2]{index=2}.
- For mixed compilers (C, C++, Fortran), use the **same version** (e.g. 2024.0 or 2025.0) to avoid conflicts :contentReference[oaicite:3]{index=3}.
- To verify installation, run:
  ```bash
  ifx -v
  icx -v
  ```
  This confirms compiler versions (e.g. `2025.0.1`) are installed correctly :contentReference[oaicite:4]{index=4}.

