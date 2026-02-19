#!/bin/sh
set -e

# npm global bin is in /usr/local/bin on Alpine
# No need to modify PATH

echo "🦞 Starting OpenClaw..."

# Check if openclaw exists
if ! command -v openclaw >/dev/null 2>&1; then
    echo "ERROR: openclaw not installed!"
    echo "PATH: $PATH"
    which node || echo "node not found"
    which npm || echo "npm not found"
    ls -la /usr/local/bin/ | grep openclaw || echo "openclaw not in /usr/local/bin"
    exit 1
fi

TELEGRAM_TOKEN="${TELEGRAM_TOKEN}"
GATEWAY_TOKEN="${GATEWAY_TOKEN}"

if [ -z "$TELEGRAM_TOKEN" ]; then
    echo "ERROR: telegram_token required"
    exit 1
fi

if [ -z "$GATEWAY_TOKEN" ]; then
    echo "ERROR: gateway_token required"
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
