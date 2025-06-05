#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <log-directory>"
  exit 1
fi

if [ ! -d "$1" ]; then
  echo "Error: Directory $1 does not exist, please provide a directory path"
  exit 1
fi

ARCHIVE_DIR="./archives"
mkdir -p "$ARCHIVE_DIR"

ARCHIVE_FILE="$ARCHIVE_DIR/logs_archive_$(date +%Y%m%d_%H%M%S).tar.gz"
LOG_FILE="$ARCHIVE_DIR/archive.log"

{
  echo "$(date +%Y%m%d_%H%M%S): Creating archive $ARCHIVE_FILE"
  tar -cvzf "$ARCHIVE_FILE" -C "$1" .
  TAR_EXIT_CODE=$?
  if [ $TAR_EXIT_CODE -eq 0 ]; then
    echo "$(date +%Y%m%d_%H%M%S): [Successfully created archive] $ARCHIVE_FILE"
  else
    echo "$(date +%Y%m%d_%H%M%S): [Failed to create archive] $ARCHIVE_FILE"
    exit $TAR_EXIT_CODE
  fi
} >> "$LOG_FILE" 2>&1

