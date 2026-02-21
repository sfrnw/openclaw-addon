#!/bin/bash
set -e

echo "🦞 Starting OpenClaw (v3.0.7 - Home Assistant Add-on)..."

CONFIG_DIR="/data"
CONFIG_FILE="$CONFIG_DIR/openclaw.json"
OPTIONS_FILE="/data/options.json"

# Create config directory
mkdir -p "$CONFIG_DIR"
mkdir -p "$CONFIG_DIR/credentials"
mkdir -p "$CONFIG_DIR/workspace/memory"

# Read options from HA
TELEGRAM_TOKEN=""
OLLAMA_URL=""
if [ -f "$OPTIONS_FILE" ]; then
    TELEGRAM_TOKEN=$(jq -r '.telegram_token // empty' "$OPTIONS_FILE" 2>/dev/null || echo "")
    OLLAMA_URL=$(jq -r '.ollama_url // empty' "$OPTIONS_FILE" 2>/dev/null || echo "")
fi

# Generate gateway token (store in config for persistence)
GATEWAY_TOKEN_FILE="$CONFIG_DIR/gateway_token.txt"
if [ -f "$GATEWAY_TOKEN_FILE" ]; then
    GATEWAY_TOKEN=$(cat "$GATEWAY_TOKEN_FILE")
else
    GATEWAY_TOKEN="$(openssl rand -hex 32)"
    echo "$GATEWAY_TOKEN" > "$GATEWAY_TOKEN_FILE"
fi

# Check if config exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "📝 No config found, generating config..."
    
    # Determine model to use
    if [ -n "$OLLAMA_URL" ] && [ "$OLLAMA_URL" != "null" ]; then
        echo "🤖 Ollama URL detected, configuring local model..."
        MODEL_CONFIG=$(cat << EOF
{
  "models": {
    "providers": {
      "ollama": {
        "baseUrl": "$OLLAMA_URL",
        "apiKey": "ollama",
        "api": "openai-completions",
        "models": [
          {
            "id": "phi3:mini",
            "name": "Phi 3 Mini",
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
        "primary": "ollama/phi3:mini",
        "fallbacks": []
      },
      "models": {
        "ollama/phi3:mini": { "alias": "ollama" }
      }
    }
  }
}
EOF
)
        echo "✅ Configured Ollama local model"
    else
        echo "⚠️ No Ollama URL, using Qwen Portal (requires browser auth)..."
        MODEL_CONFIG=$(cat << EOF
{
  "models": {
    "providers": {
      "qwen-portal": {
        "baseUrl": "https://portal.qwen.ai/v1",
        "apiKey": "qwen-oauth",
        "api": "openai-completions",
        "models": [
          {
            "id": "coder-model",
            "name": "Qwen Coder",
            "reasoning": false,
            "input": ["text"],
            "cost": { "input": 0, "output": 0 },
            "contextWindow": 128000,
            "maxTokens": 8192
          }
        ]
      }
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "qwen-portal/coder-model",
        "fallbacks": []
      },
      "models": {
        "qwen-portal/coder-model": { "alias": "qwen" }
      }
    }
  }
}
EOF
)
        echo "✅ Configured Qwen Portal (OAuth required)"
    fi
    
    cat > "$CONFIG_FILE" << EOF
{
  "meta": {
    "deployment": "home-assistant-addon",
    "version": "3.0.7"
  },
  $MODEL_CONFIG
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
    
    echo "✅ Config generated"
fi

# Update Telegram config if token provided
if [ -n "$TELEGRAM_TOKEN" ] && [ "$TELEGRAM_TOKEN" != "null" ] && [ "$TELEGRAM_TOKEN" != "" ]; then
    echo "📱 Updating Telegram configuration..."
    
    # Use jq to update config safely
    if command -v jq &> /dev/null; then
        # Create temp file with updated config
        jq --arg token "$TELEGRAM_TOKEN" '
            .channels.telegram.enabled = true |
            .channels.telegram.botToken = $token
        ' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
        echo "✅ Telegram configured"
    else
        echo "⚠️ jq not found, skipping Telegram update"
    fi
else
    echo "⚠️ No Telegram token (set telegram_token in Add-on Configuration)"
fi

# Setup Telegram allowlist (allow all by default for first setup)
echo '{"version": 1, "allowFrom": []}' > "$CONFIG_DIR/credentials/telegram-allowFrom.json"

# Create workspace directory
mkdir -p "$CONFIG_DIR/workspace/memory"

echo ""
echo "🦞 OpenClaw is ready!"
echo "🔑 Gateway Token: $GATEWAY_TOKEN"
echo "🌐 Web UI: http://$(hostname -i):18789"
echo "📡 Port: 18789"
echo ""
echo "⚠️ IMPORTANT: Copy the Gateway Token and use it in Web UI to configure channels!"
echo ""

# Start gateway
exec openclaw gateway --port 18789 --bind 0.0.0.0
