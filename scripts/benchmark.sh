#!/bin/bash
# Script: benchmark.sh
# Purpose: Simple performance benchmarking
# Usage: ./scripts/benchmark.sh
# Example: ./scripts/benchmark.sh

set -e

echo "Simple Performance Benchmark"
echo "============================="
echo "Timestamp: $(date)"
echo "Git: $(git rev-parse --short HEAD 2>/dev/null || echo "unknown")"
echo ""

# Check if binary exists
BINARY="./gz-__PROJECT_NAME__"
if [ ! -f "$BINARY" ]; then
    echo "Error: Binary not found at $BINARY"
    echo "Please run 'make build' first"
    exit 1
fi

# Binary size
echo "Binary Size:"
binary_size=$(ls -lh "$BINARY" | awk '{print $5}')
echo "  Current: $binary_size"

# Simple startup time test (3 iterations)
echo ""
echo "Startup Performance (3 iterations):"
total_time=0
for i in {1..3}; do
    start_time=$(date +%s.%N)
    $BINARY --help >/dev/null 2>&1
    end_time=$(date +%s.%N)
    iteration_time=$(echo "$end_time - $start_time" | bc -l)
    printf "  Iteration %d: %.3fs\n" $i $iteration_time
    total_time=$(echo "$total_time + $iteration_time" | bc -l)
done

avg_time=$(echo "scale=3; $total_time / 3" | bc -l)
echo "  Average: ${avg_time}s"

# Performance threshold check
threshold="0.100"
if (( $(echo "$avg_time > $threshold" | bc -l) )); then
    echo "  WARNING: Average startup time ${avg_time}s exceeds threshold ${threshold}s"
else
    echo "  Startup time within acceptable range (< ${threshold}s)"
fi

# Test key commands
echo ""
echo "Command Response Test:"
commands=("--help" "version" "--version")

for cmd in "${commands[@]}"; do
    start_time=$(date +%s.%N)
    $BINARY $cmd >/dev/null 2>&1 || true
    end_time=$(date +%s.%N)
    cmd_time=$(echo "$end_time - $start_time" | bc -l)
    printf "  %-15s: %.3fs\n" "$cmd" $cmd_time
done

echo ""
echo "Benchmark completed successfully!"
