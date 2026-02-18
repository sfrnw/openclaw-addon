#!/usr/bin/with-contenv bash
set -e

echo "🦞 Starting OpenClaw..."

# Create config directory with secure permissions
mkdir -p /root/.openclaw
chmod 700 /root/.openclaw

# Generate minimal openclaw.json with correct v1.x format
cat > /root/.openclaw/openclaw.json << EOF
{
  "gateway": {
    "port": 18789,
    "mode": "local",
    "bind": "loopback",
    "auth": {
      "mode": "token",
      "token": "${GATEWAY_TOKEN:-openclaw-pi-token}"
    }
  },
  "channels": {
    "telegram": {
      "enabled": true,
      "botToken": "${TELEGRAM_TOKEN}",
      "dmPolicy": "pairing"
    }
  }
}
EOF

chmod 600 /root/.openclaw/openclaw.json

echo "✅ Configuration written to /root/.openclaw/openclaw.json"
cat /root/.openclaw/openclaw.json

# Create required directories
mkdir -p /root/.openclaw/agents/main/sessions
mkdir -p /root/.openclaw/credentials
chmod 700 /root/.openclaw/agents/main/sessions
chmod 700 /root/.openclaw/credentials

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

# Start OpenClaw Gateway
exec openclaw gateway start
