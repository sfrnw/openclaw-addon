#!/bin/bash
set -e

echo "🦞 Starting OpenClaw (v3.0.0 - Official Docker Flow)..."

CONFIG_DIR="/home/node/.openclaw"
CONFIG_FILE="$CONFIG_DIR/openclaw.json"

# Create config directory
mkdir -p "$CONFIG_DIR"

# Check if config exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "📝 No config found, generating minimal config..."
    
    # Generate gateway token if not provided
    GATEWAY_TOKEN="${GATEWAY_TOKEN:-$(openssl rand -hex 32)}"
    
    cat > "$CONFIG_FILE" << EOF
{
  "gateway": {
    "port": 18789,
    "mode": "local",
    "bind": "0.0.0.0",
    "auth": {
      "mode": "token",
      "token": "$GATEWAY_TOKEN"
    }
  }
}
EOF
    echo "✅ Config generated at $CONFIG_FILE"
    echo "🔑 Gateway Token: $GATEWAY_TOKEN"
else
    echo "✅ Config found at $CONFIG_FILE"
fi

# Configure Telegram if token provided
if [ -n "$TELEGRAM_TOKEN" ]; then
    echo "📱 Configuring Telegram..."
    openclaw channels add --channel telegram --token "$TELEGRAM_TOKEN" 2>/dev/null || echo "⚠️ Telegram config skipped (may already exist)"
fi

echo ""
echo "🌐 Web UI: http://$(hostname -i):18789"
echo "🚀 Starting Gateway..."
echo ""

# Start gateway
exec openclaw gateway --port 18789 --allow-unconfigured
