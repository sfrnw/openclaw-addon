#!/bin/bash
set -e

echo "🦞 Starting OpenClaw (v3.0.5 - Official Docker Flow)..."

CONFIG_DIR="/data"
CONFIG_FILE="$CONFIG_DIR/openclaw.json"
OPTIONS_FILE="/data/options.json"

# Create config directory
mkdir -p "$CONFIG_DIR"

# Read Telegram token from HA options.json
TELEGRAM_TOKEN=""
if [ -f "$OPTIONS_FILE" ]; then
    TELEGRAM_TOKEN=$(jq -r '.telegram_token // empty' "$OPTIONS_FILE" 2>/dev/null || echo "")
fi

# Check if config exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "📝 No config found, generating minimal config..."
    
    # Generate gateway token
    GATEWAY_TOKEN="$(openssl rand -hex 32)"
    
    cat > "$CONFIG_FILE" << EOF
{
  "gateway": {
    "port": 18789,
    "mode": "local",
    "bind": "lan",
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
if [ -n "$TELEGRAM_TOKEN" ] && [ "$TELEGRAM_TOKEN" != "null" ]; then
    echo "📱 Configuring Telegram..."
    # Update config file with telegram token
    cat > "$CONFIG_FILE" << EOF
{
  "gateway": {
    "port": 18789,
    "mode": "local",
    "bind": "lan",
    "auth": {
      "mode": "token",
      "token": "$GATEWAY_TOKEN"
    }
  },
  "channels": {
    "telegram": {
      "enabled": true,
      "botToken": "$TELEGRAM_TOKEN",
      "dmPolicy": "pairing"
    }
  }
}
EOF
    echo "✅ Telegram configured"
else
    echo "⚠️ No Telegram token found (set telegram_token in HA config)"
fi

echo ""
echo "🌐 Web UI: http://$(hostname -i):18789"
echo "🚀 Starting Gateway..."
echo ""

# Start gateway
exec openclaw gateway --port 18789 --allow-unconfigured
