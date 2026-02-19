#!/bin/sh
set -e

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

echo "✅ Config loaded"
echo "🌐 Web UI: http://$(hostname -i):18789"

# Start
exec openclaw gateway start
