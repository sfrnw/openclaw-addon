#!/bin/bash
set -e

echo "🦞 Starting OpenClaw v3.1.0 with Ollama (phi3:mini)..."

CONFIG_DIR="/data"
CONFIG_FILE="$CONFIG_DIR/openclaw.json"
OPTIONS_FILE="/data/options.json"

# Create directories
mkdir -p "$CONFIG_DIR"
mkdir -p "$CONFIG_DIR/credentials"
mkdir -p "$CONFIG_DIR/workspace/memory"

# Read options
TELEGRAM_TOKEN=""
MODEL="phi3:mini"
if [ -f "$OPTIONS_FILE" ]; then
    TELEGRAM_TOKEN=$(jq -r '.telegram_token // empty' "$OPTIONS_FILE" 2>/dev/null || echo "")
    MODEL=$(jq -r '.model // "phi3:mini"' "$OPTIONS_FILE" 2>/dev/null || echo "phi3:mini")
fi

echo "📦 Model: $MODEL"

# Generate gateway token
GATEWAY_TOKEN_FILE="$CONFIG_DIR/gateway_token.txt"
if [ -f "$GATEWAY_TOKEN_FILE" ]; then
    GATEWAY_TOKEN=$(cat "$GATEWAY_TOKEN_FILE")
else
    GATEWAY_TOKEN="$(openssl rand -hex 32)"
    echo "$GATEWAY_TOKEN" > "$GATEWAY_TOKEN_FILE"
fi

# Start Ollama in background
echo "🚀 Starting Ollama server..."
ollama serve > /var/log/ollama.log 2>&1 &
OLLAMA_PID=$!
echo "Ollama PID: $OLLAMA_PID"

# Wait for Ollama to be ready
echo "⏳ Waiting for Ollama to be ready..."
for i in {1..30}; do
    if curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
        echo "✅ Ollama is ready!"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "❌ Ollama failed to start"
        exit 1
    fi
    sleep 2
done

# Pull model if not exists
echo "📥 Checking model: $MODEL..."
if ! curl -s http://localhost:11434/api/tags | jq -e ".models[] | select(.name | startswith(\"$MODEL\"))" > /dev/null 2>&1; then
    echo "⬇️  Pulling model $MODEL (this may take 5-10 minutes)..."
    ollama pull $MODEL
    echo "✅ Model pulled!"
else
    echo "✅ Model already exists"
fi

# Generate OpenClaw config
echo "📝 Generating OpenClaw config..."
cat > "$CONFIG_FILE" << EOF
{
  "meta": {
    "deployment": "home-assistant-addon-ollama",
    "version": "3.1.0"
  },
  "models": {
    "providers": {
      "ollama": {
        "baseUrl": "http://localhost:11434/v1",
        "apiKey": "ollama",
        "api": "openai-completions",
        "models": [
          {
            "id": "$MODEL",
            "name": "Ollama $MODEL",
            "reasoning": false,
            "input": ["text"],
            "cost": { "input": 0, "output": 0 },
            "contextWindow": 128000,
            "maxTokens": 4096
          }
        ]
      }
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "ollama/$MODEL",
        "fallbacks": []
      },
      "models": {
        "ollama/$MODEL": { "alias": "ollama" }
      },
      "workspace": "/data/workspace",
      "heartbeat": { "every": "1h" }
    }
  },
  "gateway": {
    "port": 18789,
    "mode": "local",
    "bind": "0.0.0.0",
    "auth": {
      "mode": "token",
      "token": "$GATEWAY_TOKEN"
    }
  },
  "channels": {
    "telegram": {
      "enabled": PLACEHOLDER_ENABLED,
      "botToken": "PLACEHOLDER_TOKEN",
      "dmPolicy": "pairing",
      "groupPolicy": "allowlist"
    }
  },
  "plugins": {
    "entries": {
      "telegram": { "enabled": true }
    }
  }
}
EOF

echo "✅ OpenClaw config generated"

# Update Telegram if token provided
if [ -n "$TELEGRAM_TOKEN" ] && [ "$TELEGRAM_TOKEN" != "null" ] && [ "$TELEGRAM_TOKEN" != "" ]; then
    echo "📱 Configuring Telegram..."
    jq --arg token "$TELEGRAM_TOKEN" '
        .channels.telegram.enabled = true |
        .channels.telegram.botToken = $token
    ' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
    echo "✅ Telegram configured"
else
    echo "⚠️  No Telegram token (set telegram_token in addon config)"
fi

# Setup Telegram allowlist
echo '{"version": 1, "allowFrom": []}' > "$CONFIG_DIR/credentials/telegram-allowFrom.json"

echo ""
echo "🦞 OpenClaw is ready!"
echo "🔑 Gateway Token: $GATEWAY_TOKEN"
echo "🌐 Web UI: http://$(hostname -i):18789"
echo "🤖 Ollama: http://localhost:11434"
echo "📦 Model: $MODEL"
echo ""
echo "⚠️  IMPORTANT: Copy Gateway Token for Web UI!"
echo ""

# Start OpenClaw
exec openclaw gateway --port 18789 --bind 0.0.0.0
