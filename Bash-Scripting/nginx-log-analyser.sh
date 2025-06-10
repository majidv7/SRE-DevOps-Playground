#!/usr/bin/env bash

DEFAULT_LOG="./nginx-access.log"
LOG_FILE="${1:-$DEFAULT_LOG}"

# Verify file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Log file not found: $LOG_FILE" >&2
    exit 1
fi

echo "Top 5 IP addresses with the most requests:"
results=( $(awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5 | awk '{count=$1; $1=""; sub(/^ +/, ""); print count " " $0}') )
if [ ${#results[@]} -eq 0 ]; then
    echo "No IP addresses found in $LOG_FILE"
else
    for ((i=0; i<${#results[@]}; i+=2)); do
        echo "$((i/2+1)). ${results[i+1]} - ${results[i]} requests"
    done
fi

echo
echo "Top 5 paths with the most requests:"
results=( $(awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5 | awk '{count=$1; $1=""; sub(/^ +/, ""); print count " " $0}') )
if [ ${#results[@]} -eq 0 ]; then
    echo "No paths found in $LOG_FILE"
else
    for ((i=0; i<${#results[@]}; i+=2)); do
        echo "$((i/2+1)). ${results[i+1]} - ${results[i]} requests"
    done
fi

echo
echo "Top 5 status codes with the most requests:"
results=( $(awk '$9 ~ /^[1-5][0-9][0-9]$/ {print $9}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5 | awk '{count=$1; $1=""; sub(/^ +/, ""); print count " " $0}') )
if [ ${#results[@]} -eq 0 ]; then
    echo "No valid status codes found in $LOG_FILE"
else
    count=$(( ${#results[@]} / 2 ))
    if [ $count -lt 5 ]; then
        echo "Note: Only $count valid status codes found"
    fi
    for ((i=0; i<${#results[@]}; i+=2)); do
        echo "$((i/2+1)). ${results[i+1]} - ${results[i]} requests"
    done
fi

echo
echo "Top 5 user agents with the most requests:"
user_agent_results=$(awk -F'"' '{if ($6 != "" && $6 != "-") print $6}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5)

if [ -z "$user_agent_results" ]; then
    echo "No valid user agents found in $LOG_FILE"
else
    echo "$user_agent_results" | while read count ua_string; do
        current_rank=$((current_rank + 1))
        echo "$current_rank. $ua_string - $count requests"
    done
fi

