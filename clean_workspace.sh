#!/usr/bin/env bash
# Clean up workspace and system to free up space and optimize performance

set -e

echo "Cleaning workspace snapshots and caches..."
rm -rf ./.snapshots
find . -type d -name "__pycache__" -exec rm -rf {} +

echo "Pruning unused Docker data..."
docker system prune -f || true

echo "Updating and autoremove unused packages..."
sudo apt update && sudo apt autoremove -y

echo "Clean up complete!"
