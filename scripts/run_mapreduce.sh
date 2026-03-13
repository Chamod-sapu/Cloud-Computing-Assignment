#!/bin/bash
# run_mapreduce.sh - Executes the job on Hadoop cluster
set -e

# Load environment
[ -f "$HOME/hadoop_env.sh" ] && . "$HOME/hadoop_env.sh"

if [ -z "$HADOOP_HOME" ]; then
    echo "❌ HADOOP_HOME is not set. Run: . ~/hadoop_env.sh"
    exit 1
fi

# Get project root
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"

# Hadoop does NOT like spaces in file paths (URISyntaxException). 
# We copy scripts to /tmp (no spaces) to stay safe.
echo "📦 Preparing scripts in /tmp to bypass path spaces..."
cp code/mapper.py /tmp/mapper.py
cp code/reducer.py /tmp/reducer.py
chmod +x /tmp/mapper.py /tmp/reducer.py

HDFS_INPUT="/ecommerce/input"
HDFS_OUTPUT="/ecommerce/output"

echo "📂 Preparing HDFS folders..."
hdfs dfs -mkdir -p "$HDFS_INPUT"
hdfs dfs -rm -r -f "$HDFS_OUTPUT" || true

echo "📤 Uploading dataset to HDFS..."
(cd data && hdfs dfs -put -f sales_data.csv "$HDFS_INPUT/")

echo "⚙️ Running MapReduce Job..."
STREAM_JAR=$(find "$HADOOP_HOME/share/hadoop/tools/lib/" -name "hadoop-streaming-*.jar" | head -n 1)

# Use the scripts from /tmp where the path is definitely space-free
hadoop jar "$STREAM_JAR" \
    -files "/tmp/mapper.py,/tmp/reducer.py" \
    -mapper "python3 mapper.py" \
    -reducer "python3 reducer.py" \
    -input "$HDFS_INPUT/sales_data.csv" \
    -output "$HDFS_OUTPUT"

echo "📥 Downloading results..."
mkdir -p output
hdfs dfs -getmerge "$HDFS_OUTPUT" "output/final_results.txt"

echo "✅ MapReduce Success! Results saved to output/final_results.txt"
echo "📊 Run 'python3 code/analyze_results.py output/final_results.txt' for the summary."
