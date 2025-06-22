#!/usr/bin/env bash
# Clean up workspace and system to free up space and optimize performance

set -e

# Show RAM and swap usage before cleaning
free -h

# Clean workspace snapshots and caches in parallel
(
  rm -rf ./.snapshots &
  find . -type d -name "__pycache__" -exec rm -rf {} + &
  wait
)

# Prune unused Docker data if docker is installed
if command -v docker &>/dev/null; then
  docker system prune -f
fi

# Update and autoremove unused packages if user is root
if [ "$EUID" -eq 0 ]; then
  apt update && apt autoremove -y
else
  echo "Skipping apt autoremove (not running as root)"
fi

# Show RAM and swap usage after cleaning
free -h | tee /tmp/ram_report.txt

# Festival celebration if installed
if command -v festival &>/dev/null; then
  RAM_SUMMARY=$(grep Mem: /tmp/ram_report.txt | awk '{print "Total RAM: "$2"MB, Used: "$3"MB, Free: "$4"MB"}')
  echo "$RAM_SUMMARY" | festival --tts
  echo "Cleanup complete! Your system is now faster!" | festival --tts
fi

echo "Clean up complete!"
