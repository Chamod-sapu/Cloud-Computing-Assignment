#!/bin/bash
# local_test.sh - Quick test without Hadoop
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Running MapReduce test on 1000 records..."

# If python3 is not available, try python
if command -v python3 &>/dev/null; then
    PYTHON_CMD="python3"
else
    PYTHON_CMD="python"
fi

head -n 1000 "$PROJECT_DIR/data/sales_data.csv" | $PYTHON_CMD "$PROJECT_DIR/code/mapper.py" | sort | $PYTHON_CMD "$PROJECT_DIR/code/reducer.py"

echo "✅ Test completed!"
