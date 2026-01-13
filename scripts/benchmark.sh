#!/bin/bash
set -e

# scripts/benchmark.sh
# Bash startup time benchmark tool

COUNT=5
PROFILE_MODE=false
PROFILE_LOG="profile.log"

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --profile) PROFILE_MODE=true ;;
        --count) COUNT=$2; shift ;;
        -h|--help)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  --count N    Number of runs for average calculation (default: 5)"
            echo "  --profile    Run bash with -x and analyze performance bottleneck"
            exit 0
            ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

SCRIPT_DIR=$(dirname "$(realpath "$0")")

if [ "$PROFILE_MODE" = true ]; then
    echo "Running in PROFILE mode..."
    rm -f "$PROFILE_LOG"
    
    echo "Starting bash with tracing enabled..."
    # Use EPOCHREALTIME for high-precision timestamp
    # Note: Bash 5.0+ required for EPOCHREALTIME
    env PS4='+${EPOCHREALTIME} ' bash -i -x -c exit 2> "$PROFILE_LOG"
    
    echo "Analyzing profile log..."
    if [ -f "$SCRIPT_DIR/analyze_bash_profile.py" ]; then
        python3 "$SCRIPT_DIR/analyze_bash_profile.py" "$PROFILE_LOG"
    else
        echo "Error: analyze_bash_profile.py not found in $SCRIPT_DIR"
        exit 1
    fi
    echo "Log saved to $PROFILE_LOG"
    exit 0
fi

echo "Benchmarking bash startup time ($COUNT runs)..."
total=0

# Ensure bc is installed or use awk
if ! command -v bc >/dev/null 2>&1; then
    echo "Error: 'bc' command not found. Please install it."
    exit 1
fi

for i in $(seq 1 $COUNT); do
    # Use bash built-in time with TIMEFORMAT to get real time in seconds
    TIMEFORMAT=%R
    # Run interactive bash and exit immediately
    # Capture stderr because time outputs to stderr
    val=$( { time bash -i -c exit >/dev/null 2>&1; } 2>&1 )
    echo "Run $i: ${val}s"
    total=$(echo "$total + $val" | bc)
done

avg=$(echo "scale=3; $total / $COUNT" | bc)
echo "----------------"
echo "Average: ${avg}s"
