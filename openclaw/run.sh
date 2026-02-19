#!/bin/sh
set -e

# Ensure npm global bin is in PATH
export PATH="/root/.npm-global/bin:$PATH"

echo "🦞 Starting OpenClaw..."

# Read config from HA options.json
OPTIONS="/data/options.json"

if [ ! -f "$OPTIONS" ]; then
    echo "ERROR: $OPTIONS not found"
    exit 1
fi

# Extract tokens
TELEGRAM_TOKEN=$(jq -r '.telegram_token' "$OPTIONS")
GATEWAY_TOKEN=$(jq -r '.gateway_token' "$OPTIONS")

# Validate
if [ -z "$TELEGRAM_TOKEN" ] || [ "$TELEGRAM_TOKEN" = "null" ]; then
    echo "ERROR: telegram_token is required"
    exit 1
fi

if [ -z "$GATEWAY_TOKEN" ] || [ "$GATEWAY_TOKEN" = "null" ]; then
    echo "ERROR: gateway_token is required"
    exit 1
fi

echo "✅ Tokens loaded:"
echo "   Telegram: ${TELEGRAM_TOKEN:0:25}..."
echo "   Gateway: ${GATEWAY_TOKEN:0:10}..."

# Create config
mkdir -p /root/.openclaw
cat > /root/.openclaw/openclaw.json << EOF
{
  "gateway": {
    "port": 18789,
    "mode": "local",
    "bind": "loopback",
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

echo "✅ Config written"
echo "🌐 Web UI: http://$(hostname -i):18789"
echo "🚀 Starting gateway..."

# Start OpenClaw
exec openclaw gateway start
