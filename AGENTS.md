# AGENTS.md

## Overview
Fortran project built with Intel oneAPI (`ifx`) or GNU (`gfortran`) via CMake.

## Build & Test (via CMake)
1. Preferred: Build using `ifx` (see BUILD_GUIDE.md).  
2. Fallback: Build using `gfortran` if `ifx` fails.  
3. Run tests: `./build_ifx/your_binary --test || ./build_gnu/your_binary --test`.  
4. Cleanup: Revert `time.sim`, remove `build_ifx/`, `build_gnu/`.  

_For full details, see [BUILD_GUIDE.md](./BUILD_GUIDE.md)._
