#!/bin/sh
set -e

export PATH="/root/.npm-global/bin:$PATH"

echo "🦞 Starting OpenClaw..."

# HA passes config as env vars
TELEGRAM_TOKEN="${TELEGRAM_TOKEN}"
GATEWAY_TOKEN="${GATEWAY_TOKEN}"

if [ -z "$TELEGRAM_TOKEN" ]; then
    echo "ERROR: telegram_token required in Configuration"
    exit 1
fi

if [ -z "$GATEWAY_TOKEN" ]; then
    echo "ERROR: gateway_token required in Configuration"
    exit 1
fi

echo "✅ Tokens loaded"

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

exec openclaw gateway start
