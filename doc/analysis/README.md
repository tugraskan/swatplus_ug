# arnoldjjms/swatplus_dev Integration Analysis

This directory contains a comprehensive analysis of the differences between `tugraskan/swatplus_ug` and `arnoldjjms/swatplus_dev` focusing on .f90 source files.

## Quick Start

**Read these files in order:**

1. **SUMMARY.md** - Start here for executive summary and key findings
2. **conflict_analysis.md** - File-by-file conflict assessment
3. **commit_reorganization_recommendations.md** - How to reorganize commits logically
4. **arnoldjjms_f90_analysis.md** - Functional grouping of changes

## Analysis Files

### Main Documents
- `SUMMARY.md` - Comprehensive executive summary
- `conflict_analysis.md` - Detailed conflict risk assessment for each file
- `commit_reorganization_recommendations.md` - Suggestions for logical commit structure
- `arnoldjjms_f90_analysis.md` - Changes grouped by functionality

### Data Files
- `commits_ahead.txt` - 7 commits in arnoldjjms/main (with details)
- `commits_behind.txt` - 37 commits in current branch
- `ahead_commits_simple.txt` - Simple list of ahead commits
- `ahead_commits_files.txt` - Files changed per commit
- `f90_files_changed.txt` - List of 22 .f90 files with differences
- `diff_stat.txt` - Overall diff statistics
- `f90_diff_stat.txt` - .f90 specific diff statistics

### Patch Files
- `diff_cbn_rsd_decomp.patch` - Detailed diff for carbon decomposition fix
- `diff_pl_rootfr.patch` - Detailed diff for root fraction calculations
- `diff_utils.patch` - Detailed diff for utility functions

## Key Findings

- **7 commits ahead** in arnoldjjms/main (1 merge, 6 functional)
- **37 commits behind** (current branch has newer work)
- **4 new .f90 files** to add from arnoldjjms
- **22 .f90 files** with differences
- **Previous integration**: Jan 16, 2026 (PR #145)
- **New commits since**: 4 commits (Jan 21 - Feb 12, 2026)

## Major Changes

### 1. Water Allocation with Canals
- New files: wallo_canal.f90, water_canal_read.f90, water_orcv_read.f90
- Multiple channels per allocation object
- Recall support

### 2. Residue by Plant Type
- Store residue separately by plant type
- Better tracking and management
- ~10 files modified

### 3. Carbon Decomposition Fix
- **Critical**: Fixed NO3/NH4 blowup
- Better guard placement
- cbn_rsd_decomp.f90

### 4. Root Distribution
- Improved calculations
- Better HRU integration
- pl_rootfr.f90

## Conflict Risk Summary

- **HIGH**: cbn_rsd_decomp.f90
- **MEDIUM**: hru_control.f90, pl_rootfr.f90, utils.f90
- **LOW**: Most other files

## Next Steps

1. Review SUMMARY.md for complete picture
2. Review conflict_analysis.md for detailed conflict assessment
3. Decide on integration strategy (see commit_reorganization_recommendations.md)
4. Test critical changes (carbon decomposition fix) first
5. Integrate by functional groups

## Notes

- No "merge_213" branch/PR found (user may have been referring to commit bf213cf)
- Previous arnoldjjms integration was PR #145 (Jan 16, 2026)
- Some older commits (Jan 6, Nov 19) in arnoldjjms/main may have been missed in that integration
