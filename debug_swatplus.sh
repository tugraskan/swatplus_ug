cat > debug_swatplus.sh << 'EOF'
#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Usage: $0 <TxtInOut.txt> <report.txt>" >&2
  exit 1
fi

INPUT="$1"
REPORT="$2"
LOG="swat_error.log"
BUILD_DIR="build"

# 1) Configure & build
mkdir -p "$BUILD_DIR"
cmake -S . -B "$BUILD_DIR" -DCMAKE_BUILD_TYPE=Release
cmake --build "$BUILD_DIR" -- -j

# 2) Locate the executable
SWAT_EXE=$(find "$BUILD_DIR" -maxdepth 1 -type f -executable -name "swatplus-*" | head -n1)
if [ -z "$SWAT_EXE" ]; then
  echo "❌ Cannot find built SWAT+ exe in $BUILD_DIR" >&2
  exit 1
fi

# 3) Run SWAT+ and capture errors
"$SWAT_EXE" -i "$INPUT" 2> "$LOG" || true

# 4) Build prompt for Codex
INPUT_SNIPPET=$(head -n 200 "$INPUT" | sed 's/^/    /')
ERROR_LOG=$(sed 's/^/    /' "$LOG")
read -r -d '' PROMPT <<EOF2
I ran SWAT+ with this TxtInOut (first 200 lines):
\`\`\`
$INPUT_SNIPPET
\`\`\`

It crashed with:
\`\`\`
$ERROR_LOG
\`\`\`

Please:
1. Explain each error.
2. Spot formatting or parameter mistakes.
3. Suggest concrete fixes so it runs.
EOF2

# 5) Invoke Codex
openai api completions.create \
  --model codex-001 \
  --prompt "$PROMPT" \
  --max-tokens 800 \
  --temperature 0 \
  > "$REPORT"

echo "✅ Analysis written to $REPORT"
EOF
