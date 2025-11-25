# Building SWAT+ Without CMake in Visual Studio on Windows

This guide explains how to compile and build SWAT+ in Visual Studio on Windows without using CMake. This is useful if you prefer to work directly with Visual Studio project files or encounter issues with the CMake-based build system.

## Prerequisites

1. **Visual Studio 2022** (Community, Professional, or Enterprise) with the "Desktop Development with C++" workload installed
2. **Intel Fortran Compiler** - Download and install [Intel oneAPI HPC Toolkit](https://www.intel.com/content/www/us/en/developer/tools/oneapi/fortran-compiler-download.html) or the standalone Intel Fortran compiler

## Understanding the Build Issues

When compiling without CMake, you may encounter two main issues:

### 1. `main.f90.in` Template File

The file `src/main.f90.in` is a CMake template file containing placeholders (e.g., `@TODAY@`, `@YEAR@`, `@SWAT_VERSION@`) that CMake replaces with actual values during the build process. 

**Solution:** A static `src/main.f90` file is provided for manual builds. This file contains hardcoded version information instead of CMake placeholders.

### 2. `utils.f90` Preprocessor Directives

The file `src/utils.f90` uses C-style preprocessor directives (`#ifdef __INTEL_COMPILER`, `#elif defined(__GFORTRAN__)`) that require the Fortran preprocessor to be enabled.

**Solution:** Enable the Fortran preprocessor in your compiler settings:
- **Intel Fortran**: Use the `/fpp` compiler option
- **GNU Fortran (gfortran)**: Use the `-cpp` compiler option

## Option 1: Creating a Visual Studio Fortran Project

1. **Start Visual Studio properly:**
   - Open the Start Menu and search for "Intel oneAPI command prompt for Intel 64 for Visual Studio" (e.g., "...for Visual Studio 2022" if using VS 2022)
   - In the opened command prompt, type `devenv` and press Enter to launch Visual Studio with Intel compiler support

2. **Create a new project:**
   - File → New → Project
   - Select "Empty Project" under Intel Fortran templates
   - Name your project (e.g., "swatplus") and choose a location

3. **Add source files:**
   - Right-click on "Source Files" in Solution Explorer
   - Select Add → Existing Item
   - Navigate to the `src` folder of SWAT+ and select all `.f90` files
   - **Important:** Do NOT add `main.f90.in` - only add `main.f90`

4. **Configure preprocessor settings:**
   - Right-click on the project → Properties
   - Navigate to Fortran → Preprocessor
   - Set "Preprocess Source File" to "Yes (/fpp)"

5. **Configure additional compiler settings:**
   - Fortran → General:
     - Set "Source File Format" to "Free Form"
   - Fortran → Floating Point:
     - Set "Floating Point Exception Handling" to "Except Denormal (/fpe:0)"
   - Fortran → Run-time:
     - Set "Generate Traceback Information" to "Yes (/traceback)"

6. **Build the solution:**
   - Build → Build Solution (or press F7)
   - The executable will be created in the output directory

## Option 2: Command-Line Compilation with Intel Fortran

If you prefer command-line compilation:

1. **Open the Intel oneAPI command prompt:**
   - Start Menu → Search for "Intel oneAPI command prompt for Intel 64"

2. **Navigate to the SWAT+ source directory:**
   ```cmd
   cd C:\path\to\swatplus\src
   ```

3. **Compile all source files:**
   ```cmd
   ifx /fpp /free /fpe0 /traceback /O2 *.f90 -o swatplus.exe
   ```

   For a debug build:
   ```cmd
   ifx /fpp /free /fpe0 /traceback /debug:full /Od /warn:all *.f90 -o swatplus_debug.exe
   ```

## Option 3: Using gfortran on Windows

If you're using gfortran (e.g., via MinGW or MSYS2):

1. **Open a command prompt with gfortran in PATH**

2. **Navigate to the source directory:**
   ```cmd
   cd C:\path\to\swatplus\src
   ```

3. **Compile:**
   ```cmd
   gfortran -cpp -ffree-form -fcheck=all -ffpe-trap=invalid,zero,overflow,underflow -fimplicit-none -ffree-line-length-none -fbacktrace -finit-local-zero -O2 *.f90 -o swatplus.exe
   ```

## Compiler Flags Explained

### Intel Fortran (`ifx` or `ifort`)

| Flag | Description |
|------|-------------|
| `/fpp` | Enable Fortran preprocessor (required for `utils.f90`) |
| `/free` | Free-form source code format |
| `/fpe0` | Generate floating-point exceptions |
| `/traceback` | Generate traceback information for runtime errors |
| `/O2` | Optimization level 2 |
| `/debug:full` | Full debug information (for debugging) |
| `/warn:all` | Enable all warnings |

### GNU Fortran (`gfortran`)

| Flag | Description |
|------|-------------|
| `-cpp` | Enable C preprocessor (required for `utils.f90`) |
| `-ffree-form` | Free-form source code format |
| `-fcheck=all` | Enable all runtime checks |
| `-ffpe-trap=invalid,zero,overflow,underflow` | Trap floating-point exceptions |
| `-fimplicit-none` | Require explicit variable declarations |
| `-ffree-line-length-none` | No limit on line length |
| `-fbacktrace` | Generate backtrace on errors |
| `-finit-local-zero` | Initialize local variables to zero |
| `-O2` | Optimization level 2 |

## Running SWAT+

After compilation:

1. Place the executable in a folder containing valid SWAT+ input files
2. Open a command prompt in that folder
3. Run the executable:
   ```cmd
   swatplus.exe
   ```

## Troubleshooting

### Error: "use ifcore, only: tracebackqq" not found
- Ensure you're using the Intel Fortran compiler
- Enable the preprocessor with `/fpp`
- The preprocessor directive `#ifdef __INTEL_COMPILER` will conditionally include Intel-specific code

### Error: Unrecognized preprocessor directives
- Make sure the preprocessor is enabled (`/fpp` for Intel, `-cpp` for gfortran)

### Error: main.f90.in placeholders not replaced
- Use the provided `main.f90` file instead of `main.f90.in`
- The static `main.f90` file has hardcoded version information

### Linker errors about missing modules
- Ensure all `.f90` files from the `src` directory are included in your project
- Verify that modules are compiled before files that depend on them (the build system usually handles this automatically)

## Notes

- The CMake build system is the recommended approach as it handles version tagging, cross-platform compatibility, and proper configuration automatically
- When using the manual build, version information in the output will show "dev" instead of the actual git tag
- For production builds, consider using CMake as described in the main documentation
