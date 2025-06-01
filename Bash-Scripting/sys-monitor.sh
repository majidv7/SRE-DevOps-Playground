#!/bin/bash

echo "===== SYSTEM MONITORING REPORT ====="
echo

# OS Version
echo ">> OS Version <<"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "$PRETTY_NAME"
else
    echo "Unknown OS"
fi
echo

# Uptime and Load Average
echo ">> Uptime and Load Average <<"
uptime -p
echo "Load Average: $(uptime | awk -F'load average:' '{print $2}')"
echo

# Logged-in Users
echo ">> Currently Logged-in Users <<"
who | awk '{print $1}' | sort | uniq -c
echo

# CPU Info
echo ">> CPU Info <<"
cpu_usage=$(top -bn1 | awk '/^%Cpu\(s\)/ {print $2}')
echo "CPU Total Usage: ${cpu_usage}%"
echo

# Memory Info
echo ">> Memory Info <<"
mem_used=$(top -bn1 | awk '/^MiB Mem/ {printf "%.0f", $6}')
mem_free=$(top -bn1 | awk '/^MiB Mem/ {printf "%.0f", $8}')
echo "Total Memory Used: ${mem_used} MiB"
echo "Total Memory Free: ${mem_free} MiB"
echo

# Disk Info
echo ">> Disk Info <<"
disk_total=$(df -m / | awk 'NR==2 {print $2}')
disk_used=$(df -m / | awk 'NR==2 {print $3}')
disk_free=$(df -m / | awk 'NR==2 {print $4}')
disk_usage_perc=$(df -m / | awk 'NR==2 {print $5}')

echo "Total Disk: ${disk_total} MiB"
echo "Disk Used: ${disk_used} MiB"
echo "Disk Free: ${disk_free} MiB (${disk_usage_perc})"
echo

# Top 5 Processes by CPU Usage
echo ">> Top 5 Processes by CPU Usage <<"
top_cpu=$(top -bn1 | awk '/^[[:space:]]*[0-9]+/ {print $12; if (++count >= 5) exit}')
printf "%s\n" $top_cpu
echo

# Top 5 Processes by Memory Usage
echo ">> Top 5 Processes by Memory Usage <<"
top_mem=$(top -bn1 -o %MEM | awk 'NR>7 {cmd=""; for(i=12;i<=NF;i++) cmd=cmd $i " "; sub(/[[:space:]]+$/, "", cmd); print cmd; if (++count >= 5) exit}')
printf "%s\n" $top_mem
echo

