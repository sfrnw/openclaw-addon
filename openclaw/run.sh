#!/usr/bin/with-contenv bash
set -e

echo "🦞 Starting OpenClaw..."

# Create workspace directory
mkdir -p /workspace

# Generate openclaw.json from options
cat > /workspace/openclaw.json << EOF
{
  "gateway": {
    "host": "0.0.0.0",
    "port": 18789,
    "token": "${GATEWAY_TOKEN}"
  },
  "channels": {
    "telegram": {
      "botToken": "${TELEGRAM_TOKEN}",
      "allowedUsers": [${TELEGRAM_ALLOWED_USERS}]
    }
  },
  "defaults": {
    "thinking": "off",
    "timezone": "${TIMEZONE:-Europe/Lisbon}"
  }
}
EOF

# Setup email if credentials provided
if [ -n "$GMAIL_EMAIL" ] && [ -n "$GMAIL_APP_PASSWORD" ]; then
    echo "📧 Setting up email..."
    
    # Create himalaya config
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

    # Store password in pass
    echo "${GMAIL_APP_PASSWORD}" | pass insert -m "himalaya/gmail" 2>/dev/null || true
fi

# Setup Home Assistant integration if provided
if [ -n "$HOMEASSISTANT_URL" ] && [ -n "$HOMEASSISTANT_TOKEN" ]; then
    echo "🏠 Setting up Home Assistant integration..."
    
    # Add HA config to openclaw.json
    cat > /workspace/ha-integration.json << EOF
{
  "integrations": {
    "homeassistant": {
      "url": "${HOMEASSISTANT_URL}",
      "token": "${HOMEASSISTANT_TOKEN}"
    }
  }
}
EOF
fi

# Setup Notion if provided
if [ -n "$NOTION_API_KEY" ]; then
    echo "📝 Setting up Notion integration..."
    export NOTION_API_KEY="${NOTION_API_KEY}"
fi

echo "✅ Configuration complete"
echo "🌐 Gateway UI: http://$(hostname -i):18789"
echo ""

# Start OpenClaw Gateway
exec openclaw gateway start --config /workspace/openclaw.json
