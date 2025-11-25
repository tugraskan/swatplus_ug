# Building SWAT+ Without CMake in Visual Studio on Windows

This guide explains how to compile and build SWAT+ in Visual Studio on Windows without using CMake. This is useful if you prefer to work directly with Visual Studio project files or encounter issues with the CMake-based build system.

## Common Compilation Errors and Solutions

If you see errors like:
- `error #7002: Error in opening the compiled module file. Check INCLUDE paths. [UTILS]`
- `error #7002: Error in opening the compiled module file. Check INCLUDE paths. [ISO_FORTRAN_ENV]`
- `error #7002: Error in opening the compiled module file. Check INCLUDE paths. [IFCORE]`
- `error #6580: Name in only-list does not exist or is not accessible. [TRACEBACKQQ]`

**These errors occur because the preprocessor is not enabled or not working properly.** Follow the instructions in this guide carefully, particularly the section on handling `utils.f90`.

## Prerequisites

1. **Visual Studio 2022** (Community, Professional, or Enterprise) with the "Desktop Development with C++" workload installed
2. **Intel Fortran Compiler** - Download and install [Intel oneAPI HPC Toolkit](https://www.intel.com/content/www/us/en/developer/tools/oneapi/fortran-compiler-download.html) or the standalone Intel Fortran compiler

## Understanding the Build Issues

When compiling without CMake, you may encounter these main issues:

### 1. `main.f90.in` Template File

The file `src/main.f90.in` is a CMake template file containing placeholders (e.g., `@TODAY@`, `@YEAR@`, `@SWAT_VERSION@`) that CMake replaces with actual values during the build process. 

**Solution:** A static `src/main.f90` file is provided for manual builds. This file contains hardcoded version information instead of CMake placeholders.

### 2. `utils.f90` Preprocessor Directives

The file `src/utils.f90` uses C-style preprocessor directives (`#ifdef __INTEL_COMPILER`, `#elif defined(__GFORTRAN__)`) that require the Fortran preprocessor to be enabled.

**You have two options to handle this:**

**Option A (Recommended for simplicity):** Use the simplified version:
1. Delete `src/utils.f90` from your project or rename it to `utils.f90.bak`
2. Copy `src/utils_no_preprocessor.f90` to `src/utils.f90`
3. Compile normally - no preprocessor needed

**Option B:** Enable the preprocessor:
- **Intel Fortran**: Add the `/fpp` compiler option in project settings
- **GNU Fortran (gfortran)**: Add the `-cpp` compiler option

**Note:** Option A is simpler and avoids preprocessor-related compilation errors. Option B preserves debugging features like stack traces.

## Option 1a: Creating a Visual Studio Fortran Project (Using utils_no_preprocessor.f90)

1. **Prepare the source files:**
   - In the `src` folder, delete or rename `utils.f90` to `utils.f90.bak`
   - Copy `utils_no_preprocessor.f90` to `utils.f90`

2. **Start Visual Studio properly:**
   - Open the Start Menu and search for "Intel oneAPI command prompt for Intel 64 for Visual Studio" (e.g., "...for Visual Studio 2022" if using VS 2022)
   - In the opened command prompt, type `devenv` and press Enter to launch Visual Studio with Intel compiler support

3. **Create a new project:**
   - File → New → Project
   - Select "Empty Project" under Intel Fortran templates
   - Name your project (e.g., "swatplus") and choose a location

4. **Add source files:**
   - Right-click on "Source Files" in Solution Explorer
   - Select Add → Existing Item
   - Navigate to the `src` folder of SWAT+ and select all `.f90` files
   - **Important:** Do NOT add `main.f90.in` or `utils.f90.bak` - only add files ending in `.f90`

5. **Configure compiler settings (NO preprocessor needed with utils_no_preprocessor.f90):**
   - Right-click on the project → Properties
   - Fortran → General:
      - Set "Source File Format" to "Free Form"
   - Fortran → Floating Point:
      - Set "Floating Point Exception Handling" to "Except Denormal (/fpe:0)"
   - Fortran → Run-time:
      - Set "Generate Traceback Information" to "Yes (/traceback)"

6. **Build the solution:**
   - Build → Build Solution (or press F7)
   - The executable will be created in the output directory

## Option 1b: Creating a Visual Studio Fortran Project (With Preprocessor)

If you want to keep the original `utils.f90` with stack trace functionality:

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
   - **Important:** Do NOT add `main.f90.in` or `utils_no_preprocessor.f90` - only add `main.f90` and the regular `utils.f90`

4. **Configure preprocessor settings (REQUIRED):**
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

## Option 2a: Command-Line Compilation with Intel Fortran (Simplified - No Preprocessor)

If you prefer command-line compilation without the preprocessor:

1. **Prepare the source files:**
   - Open a file explorer and navigate to the `src` folder
   - Delete or rename `utils.f90` to `utils.f90.bak`
   - Copy `utils_no_preprocessor.f90` and name it `utils.f90`

2. **Open the Intel oneAPI command prompt:**
   - Start Menu → Search for "Intel oneAPI command prompt for Intel 64"

3. **Navigate to the SWAT+ source directory:**
   ```cmd
   cd C:\path\to\swatplus\src
   ```

4. **Compile all source files (no /fpp needed):**
   ```cmd
   ifx /free /fpe0 /traceback /O2 *.f90 -o swatplus.exe
   ```

   For a debug build:
   ```cmd
   ifx /free /fpe0 /traceback /debug:full /Od /warn:all *.f90 -o swatplus_debug.exe
   ```

## Option 2b: Command-Line Compilation with Intel Fortran (With Preprocessor)

If you want to keep the original utils.f90:

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

### Option 3a: Simplified (No Preprocessor)

1. **Prepare the source files:**
   - Delete or rename `utils.f90` to `utils.f90.bak`
   - Copy `utils_no_preprocessor.f90` and name it `utils.f90`

2. **Open a command prompt with gfortran in PATH**

3. **Navigate to the source directory:**
   ```cmd
   cd C:\path\to\swatplus\src
   ```

4. **Compile (no -cpp needed):**
   ```cmd
   gfortran -ffree-form -fcheck=all -ffpe-trap=invalid,zero,overflow,underflow -fimplicit-none -ffree-line-length-none -fbacktrace -finit-local-zero -O2 *.f90 -o swatplus.exe
   ```

### Option 3b: With Preprocessor

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
