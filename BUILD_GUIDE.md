# 🏗️ BUILD GUIDE

This guide provides step-by-step instructions to build the project using CMake with either the Intel or GNU Fortran compiler, clean builds, and troubleshoot common issues.

---

## 🧱 CMake-Based Build & Clean Instructions

```bash
# Build with Intel ifx (preferred)
mkdir -p build_ifx && cd build_ifx
cmake -DCMAKE_Fortran_COMPILER=ifx ..
cmake --build . -- -j4
cd ..

# Build with GNU gfortran
mkdir -p build_gnu && cd build_gnu
cmake -DCMAKE_Fortran_COMPILER=gfortran ..
cmake --build . -- -j4
cd ..

# Clean all build directories
rm -rf build_ifx build_gnu
