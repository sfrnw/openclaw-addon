#!/bin/bash
# 🦞 OpenClaw Restore Script
# Restores OpenClaw from backup

set -e

if [ -z "$1" ]; then
    echo "Usage: restore.sh <backup-file>"
    echo ""
    echo "Available backups:"
    ls -lh /addon_configs/openclaw/backups/*.tar.gz 2>/dev/null || echo "No backups found"
    exit 1
fi

BACKUP_FILE="$1"

if [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ Backup file not found: $BACKUP_FILE"
    exit 1
fi

echo "🦞 Restoring OpenClaw from: $BACKUP_FILE"

# Stop OpenClaw first
echo "⏹️  Stopping OpenClaw..."
ha addons stop openclaw || true
sleep 3

# Restore data
echo "📦 Restoring data..."
tar -xzf "$BACKUP_FILE" -C /addon_configs/openclaw

echo "✅ Restore complete!"
echo "🔄 Starting OpenClaw..."
ha addons start openclaw

echo ""
echo "🦞 OpenClaw restored successfully!"
echo "📝 Check logs: ha addons logs openclaw"
