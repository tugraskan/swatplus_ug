# AGENTS.md

## Overview
Fortran project built using Intel oneAPI (`ifx`) or GNU (`gfortran`) via CMake.

## Build Instructions (use CMake only)
1. Build with `ifx`:
   ```bash
   mkdir -p build_ifx && cd build_ifx
   cmake -DCMAKE_Fortran_COMPILER=ifx ..
   cmake --build . -- -j4
