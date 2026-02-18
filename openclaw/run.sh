#!/usr/bin/with-contenv bash
set -e

echo "🦞 Starting OpenClaw..."

# Create config directory
mkdir -p /root/.openclaw

# Generate openclaw.json with correct format
cat > /root/.openclaw/openclaw.json << EOF
{
  "gateway": {
    "port": 18789,
    "auth": {
      "token": "${GATEWAY_TOKEN}"
    }
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

echo "✅ Configuration written to /root/.openclaw/openclaw.json"
cat /root/.openclaw/openclaw.json

# Setup email if credentials provided
if [ -n "$GMAIL_EMAIL" ] && [ -n "$GMAIL_APP_PASSWORD" ]; then
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

# Run doctor to fix any legacy config issues
openclaw doctor --fix 2>/dev/null || true

# Start OpenClaw Gateway
exec openclaw gateway start
