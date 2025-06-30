#!/usr/bin/env bash
set -euo pipefail

# args: scenario-dir-or-file, report-output
SCEN="$1"
REPORT="${2:-crash_report.txt}"

# locate the built SWAT+ exe
EXE=$(ls build/swatplus-*lin_x86_64-Rel)

# if user gave us a directory, cd into it and run with no args
if [ -d "$SCEN" ]; then
  echo "→ Running SWAT+ in directory $SCEN …" | tee "$REPORT"
  (
    cd "$SCEN"
    "$EXE"
  ) 2>&1 | tee -a "$REPORT"

# otherwise treat it as a single-file invocation (if you ever need that)
else
  echo "→ Running SWAT+ on file $SCEN …" | tee "$REPORT"
  "$EXE" -i "$SCEN" 2>&1 | tee -a "$REPORT"
fi

# (optionally) run your Python check here, e.g.:
# python3 test/spcheck.py "$EXE" "data/02080206" "build/02080206" \
#   --abserr 1e-8 --relerr 0.01 \
#   >> "$REPORT" 2>&1

