#!/usr/bin/env bash

DEFAULT_LOG="./nginx-access.log"
LOG_FILE="${1:-$DEFAULT_LOG}"

# Verify file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Log file not found: $LOG_FILE" >&2
    exit 1
fi

echo "Top 10 IP addresses with the most requests:"
results=( $(awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 10) )
for ((i=0; i<${#results[@]}; i+=2)); do
    echo "$((i/2+1)). ${results[i+1]} - ${results[i]} requests"
done

echo
echo "Top 10 paths with the most requests:"
results=( $(awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 10 | awk '{count=$1; $1=""; sub(/^ +/, ""); print count " " $0}') )
for ((i=0; i<${#results[@]}; i+=2)); do
    echo "$((i/2+1)). ${results[i+1]} - ${results[i]} requests"
done

