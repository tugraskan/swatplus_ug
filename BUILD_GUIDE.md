# BUILD_GUIDE.md

## 🧱 CMake-Based Build & Clean Instructions

### 1. Build with Intel `ifx` (preferred)
```bash
mkdir -p build_ifx && cd build_ifx
cmake -DCMAKE_Fortran_COMPILER=ifx ..
cmake --build . -- -j4
cd ..
mkdir -p build_gnu && cd build_gnu
cmake -DCMAKE_Fortran_COMPILER=gfortran ..
cmake --build . -- -j4
cd ..
