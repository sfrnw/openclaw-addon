# 🦞 OpenClaw AI Assistant - Home Assistant Add-on

AI personal assistant with Telegram, Email, and Home Assistant integration.

## ⚡ Quick Setup

### 1. Install the Add-on

1. Go to **Supervisor** → **Add-on Store**
2. Find **OpenClaw AI Assistant**
3. Click **Install**
4. Wait for installation to complete

### 2. Configure

Go to **Configuration** tab and fill in:

| Field | Description | Example |
|-------|-------------|---------|
| `telegram_token` | Bot token from @BotFather | `8382047308:AA...` |
| `gateway_token` | Any secure string for Gateway auth | `my-secret-token-123` |
| `gmail_email` | Your Gmail address (optional) | `you@gmail.com` |
| `gmail_app_password` | Gmail app password (optional) | `xxxx xxxx xxxx xxxx` |
| `timezone` | Your timezone (optional) | `Europe/Lisbon` |

### 3. Start

1. Go to **Info** tab
2. Click **Start**
3. Wait ~30 seconds for startup

### 4. Verify

**Option A: Check Logs**
- Go to **Log** tab
- Should see: `🦞 Starting OpenClaw...` and `✅ Configuration loaded successfully`

**Option B: Test Telegram**
- Open your bot in Telegram
- Send: `/start` or `hello`
- Bot should respond!

**Option C: Open Web UI**
- Click **Open Web UI**
- Or go to: `http://homeassistant.local:18789`

---

## 🔐 Getting Your Telegram Token

1. Open @BotFather in Telegram
2. Send `/newbot`
3. Follow prompts to name your bot
4. Copy the token (looks like: `123456789:ABCdefGHIjklMNOpqrsTUVwxyz`)

**To find your Telegram ID:**
- Message @userinfobot
- It will reply with your ID (e.g., `885810`)

---

## 🔐 Gmail App Password

1. Go to https://myaccount.google.com/apppasswords
2. Select app → "Other (Custom name)"
3. Enter name: "OpenClaw"
4. Copy the 16-character password

---

## 🏠 Home Assistant Integration (Optional)

To let OpenClaw control your Home Assistant devices:

1. In HA: **Profile** → **Long-Lived Access Token** → **Create Token**
2. Copy the token
3. Add to OpenClaw configuration (advanced - requires config edit)

---

## 🛠 Management

**Via Home Assistant UI:**
- **Start/Stop/Restart**: Info tab
- **Logs**: Log tab
- **Configuration**: Configuration tab

**Via SSH (if you have access):**
```bash
# View logs
ha addons logs openclaw

# Restart
ha addons restart openclaw

# Stop
ha addons stop openclaw
```

---

## 📁 Data Storage

All data is stored in:
- `/addon_configs/openclaw/` - Configuration
- `/data/addons/data/openclaw/` - Persistent data (memory, sessions, credentials)

**Backup:**
```bash
tar -czf openclaw-backup.tar.gz /data/addons/data/openclaw/
```

---

## 🐛 Troubleshooting

### Bot doesn't respond

1. Check logs for errors
2. Verify `telegram_token` is correct
3. Make sure bot is not blocked
4. Send `/start` to the bot in Telegram

### Configuration not loading

1. Check **Log** tab for "Configuration loaded successfully"
2. Verify both `telegram_token` and `gateway_token` are set
3. Click **Save** after changing configuration
4. **Restart** the add-on after saving

### Gateway UI not accessible

1. Try: `http://homeassistant.local:18789`
2. Or by IP: `http://192.168.1.XXX:18789`
3. Check firewall settings
4. Verify add-on is running (Info tab → should show "running")

### Email not working

1. Verify Gmail app password is correct
2. Check logs for authentication errors
3. Ensure 2FA is enabled on your Google account
4. Generate a new app password if needed

---

## 📚 Resources

- [OpenClaw Documentation](https://docs.openclaw.ai)
- [Home Assistant Add-ons](https://developers.home-assistant.io/docs/add-ons/)
- [Telegram Bot API](https://core.telegram.org/bots/api)

---

**Questions?** Message the bot in Telegram! 🦞
