#!/usr/bin/with-contenv bash
set -e

echo "🦞 Starting OpenClaw..."

# Create config directory with secure permissions
mkdir -p /root/.openclaw
chmod 700 /root/.openclaw

# Read configuration from Home Assistant options.json
OPTIONS_FILE="/data/options.json"

if [ ! -f "$OPTIONS_FILE" ]; then
    echo "❌ ERROR: Options file not found at $OPTIONS_FILE"
    echo "Home Assistant should mount this file automatically."
    exit 1
fi

echo "📋 Reading configuration from $OPTIONS_FILE..."
cat "$OPTIONS_FILE"

# Extract values using jq
TELEGRAM_TOKEN=$(jq -r '.telegram_token // empty' "$OPTIONS_FILE")
GATEWAY_TOKEN=$(jq -r '.gateway_token // empty' "$OPTIONS_FILE")
GMAIL_EMAIL=$(jq -r '.gmail_email // empty' "$OPTIONS_FILE")
GMAIL_APP_PASSWORD=$(jq -r '.gmail_app_password // empty' "$OPTIONS_FILE")
TIMEZONE=$(jq -r '.timezone // "Europe/Lisbon"' "$OPTIONS_FILE")

# Validate required fields
if [ -z "$TELEGRAM_TOKEN" ]; then
    echo "❌ ERROR: telegram_token is required but not set"
    exit 1
fi

if [ -z "$GATEWAY_TOKEN" ]; then
    echo "❌ ERROR: gateway_token is required but not set"
    exit 1
fi

echo ""
echo "✅ Configuration loaded successfully"
echo "   - Telegram token: ${TELEGRAM_TOKEN:0:20}..."
echo "   - Gateway token: ${GATEWAY_TOKEN:0:10}..."
echo "   - Timezone: $TIMEZONE"
if [ -n "$GMAIL_EMAIL" ]; then
    echo "   - Email: $GMAIL_EMAIL"
fi

# Generate openclaw.json with correct v1.x format
cat > /root/.openclaw/openclaw.json << EOF
{
  "gateway": {
    "port": 18789,
    "mode": "local",
    "bind": "loopback",
    "auth": {
      "mode": "token",
      "token": "${GATEWAY_TOKEN}"
    }
  },
  "channels": {
    "telegram": {
      "enabled": true,
      "botToken": "${TELEGRAM_TOKEN}",
      "dmPolicy": "pairing"
    }
  },
  "defaults": {
    "timezone": "${TIMEZONE}"
  }
}
EOF

chmod 600 /root/.openclaw/openclaw.json

echo ""
echo "✅ Configuration written to /root/.openclaw/openclaw.json"

# Create required directories
mkdir -p /root/.openclaw/agents/main/sessions
mkdir -p /root/.openclaw/credentials
chmod 700 /root/.openclaw/agents/main/sessions
chmod 700 /root/.openclaw/credentials

# Setup email if credentials provided
if [ -n "$GMAIL_EMAIL" ] && [ -n "$GMAIL_APP_PASSWORD" ]; then
    echo ""
    echo "📧 Setting up email..."
    
    mkdir -p /root/.config/himalaya
    cat > /root/.config/himalaya/config.toml << EOF
[core]
accounts = ["gmail"]

[accounts.gmail]
backend = "imap"
display-name = "OpenClaw"
email = "${GMAIL_EMAIL}"

[accounts.gmail.smtp]
host = "smtp.gmail.com"
port = 587
credentials = "smtp"

[accounts.gmail.imap]
host = "imap.gmail.com"
port = 993
credentials = "imap"

[credentials]
imap = { type = "password", username = "${GMAIL_EMAIL}", password = "${GMAIL_APP_PASSWORD}" }
smtp = { type = "password", username = "${GMAIL_EMAIL}", password = "${GMAIL_APP_PASSWORD}" }
EOF

    # Setup GPG for pass
    gpg --batch --gen-key << GPGEOF || true
Key-Type: RSA
Key-Length: 2048
Name-Real: OpenClaw
Name-Email: openclaw@localhost
Expire-Date: 0
%no-protection
%commit
GPGEOF

    echo "${GMAIL_APP_PASSWORD}" | pass insert -m "himalaya/gmail" 2>/dev/null || true
    echo "✅ Email configured"
fi

echo ""
echo "🌐 Gateway UI: http://$(hostname -i):18789"
echo ""
echo "🚀 Starting OpenClaw Gateway..."
echo ""

# Start OpenClaw Gateway
exec openclaw gateway start
