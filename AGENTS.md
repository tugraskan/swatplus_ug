# AGENTS.md

## Project Overview
- This repo includes Fortran code built using either GNU (`gfortran`) or Intel oneAPI (`ifx`).
- Build system: **CMake**, plus optional manual compilation.

## Environment Setup
- The setup script installs `gfortran`, `cmake`, and Intel oneAPI (`ifx`).
- `setvars.sh` is sourced so `ifx` is available in the runtime.

## Build Instructions

### Option A: Build via CMake
```bash
mkdir -p build_ifx && cd build_ifx
cmake -DCMAKE_Fortran_COMPILER=ifx ..
cmake --build . -- -j4
cd ..

mkdir -p build_gnu && cd build_gnu
cmake -DCMAKE_Fortran_COMPILER=gfortran ..
cmake --build . -- -j4
cd ..
