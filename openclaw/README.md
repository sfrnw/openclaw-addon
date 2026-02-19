# 🦞 OpenClaw AI Assistant - Home Assistant Add-on (v3.0.0)

Based on official OpenClaw Docker setup (`docker-setup.sh`).

## ⚡ Quick Setup

### 1. Install

1. **Supervisor** → **Add-on Store**
2. Find **OpenClaw AI Assistant**
3. **Install**

### 2. Configure (Optional)

**Configuration** tab:
- `telegram_token`: Your Telegram bot token (optional, can configure later via CLI)

### 3. Start

1. **Info** tab → **Start**
2. Wait ~60 seconds (first startup downloads OpenClaw)

### 4. Access Web UI

- Click **Open Web UI**
- Or: `http://homeassistant.local:18789`
- Copy the gateway token from logs

### 5. Configure Channels

**Via Web UI:**
1. Open Web UI
2. Paste gateway token (from logs)
3. Go to **Channels** → Add Telegram/WhatsApp/etc.

**Via CLI (in web terminal):**
```bash
# Telegram
ha addons exec f5eab416_openclaw --command "openclaw channels add --channel telegram --token YOUR_TOKEN"

# Check status
ha addons exec f5eab416_openclaw --command "openclaw channels list"
```

---

## 🔐 Getting Telegram Token

1. Message @BotFather in Telegram
2. `/newbot` → follow prompts
3. Copy token: `123456789:ABCdefGHIjklMNOpqrsTUVwxyz`

---

## 📁 Data Storage

- Config: `/home/node/.openclaw/` (persisted in add-on data)
- Workspace: Not mounted (stateless, config is source of truth)

---

## 🛠 Management

```bash
# View logs
ha addons logs openclaw

# Restart
ha addons restart openclaw

# Execute commands
ha addons exec openclaw --command "openclaw --help"
```

---

## 📚 Resources

- [Official Docker Docs](https://docs.openclaw.ai/install/docker)
- [OpenClaw Documentation](https://docs.openclaw.ai)
- [Channel Setup](https://docs.openclaw.ai/channels)

---

**Built from official OpenClaw Docker flow** 🦞
