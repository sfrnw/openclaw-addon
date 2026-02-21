#!/bin/bash
# 🦞 OpenClaw Backup Script
# Creates backup of all OpenClaw data

set -e

BACKUP_DIR="/addon_configs/openclaw/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/openclaw-backup-$TIMESTAMP.tar.gz"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Create backup
echo "🦞 Creating OpenClaw backup..."
tar -czf "$BACKUP_FILE" -C /addon_configs/openclaw data

echo "✅ Backup created: $BACKUP_FILE"
echo "📦 Size: $(du -h "$BACKUP_FILE" | cut -f1)"

# Keep only last 5 backups
ls -t "$BACKUP_DIR"/openclaw-backup-*.tar.gz | tail -n +6 | xargs -r rm

echo "✅ Old backups cleaned (keeping last 5)"
