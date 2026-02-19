#!/bin/bash
set -e

echo "🦞 Starting OpenClaw (v3.0.1 - Official Docker Flow)..."

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

# Debug: show all env vars (first 3 lines)
echo "🔍 Env vars:" | head -3
env | grep -i telegram || echo "No TELEGRAM env vars found"
env | grep -i token || echo "No TOKEN env vars found"

# Configure Telegram if token provided (try multiple variable names)
if [ -n "$TELEGRAM_TOKEN" ] || [ -n "$telegram_token" ]; then
    TBOT="${TELEGRAM_TOKEN:-$telegram_token}"
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
      "botToken": "$TBOT",
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
