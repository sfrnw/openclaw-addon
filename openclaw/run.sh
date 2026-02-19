#!/bin/sh
set -e

export PATH="/root/.npm-global/bin:$PATH"

echo "🦞 Starting OpenClaw..."

OPTIONS="/data/options.json"

TELEGRAM_TOKEN=$(jq -r '.telegram_token' "$OPTIONS")
GATEWAY_TOKEN=$(jq -r '.gateway_token' "$OPTIONS")

if [ -z "$TELEGRAM_TOKEN" ] || [ "$TELEGRAM_TOKEN" = "null" ]; then
    echo "ERROR: telegram_token required"
    exit 1
fi

if [ -z "$GATEWAY_TOKEN" ] || [ "$GATEWAY_TOKEN" = "null" ]; then
    echo "ERROR: gateway_token required"
    exit 1
fi

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

exec openclaw gateway start
