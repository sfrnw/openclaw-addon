# 🦞 OpenClaw Home Assistant Add-on Repository

Home Assistant add-on for OpenClaw AI Assistant.

## 📁 Structure

```
homeassistant-addon/
├── repository.json        # Repository metadata for HA
├── README.md              # This file
└── openclaw/
    ├── config.json        # Add-on configuration
    ├── Dockerfile         # Docker build instructions
    ├── run.sh             # Startup script
    ├── README.md          # User documentation
    └── CHANGELOG.md       # Version history
```

## 🚀 Installation

### Option 1: Add Repository to Home Assistant (Recommended)

1. **Add Repository:**
   - In Home Assistant: **Supervisor** → **Add-on Store**
   - Click **⋮** (three dots) → **Repositories**
   - Add: `https://github.com/sfrnw/openclaw-addon`
   - Click **Add**

2. **Install:**
   - Find **OpenClaw AI Assistant** in the store
   - Click **Install**
   - Wait for installation

3. **Configure:**
   - Go to **Configuration** tab
   - Set `telegram_token` and `gateway_token`
   - Click **Save**

4. **Start:**
   - Go to **Info** tab
   - Click **Start**

### Option 2: Local Installation (For Testing)

```bash
# Copy to Home Assistant
scp -r openclaw/ root@homeassistant.local:/addon_configs/openclaw/

# Reload supervisor
ha supervisor reload

# Install
ha addons install local_openclaw
```

---

## 🔧 Development

### Building Locally

```bash
cd openclaw

# Build for aarch64 (Raspberry Pi)
docker build -t openclaw-addon-aarch64 --build-arg BUILD_FROM=node:20-alpine .

# Test
docker run -p 18789:18789 -v ./test-options.json:/data/options.json openclaw-addon-aarch64
```

### Version Management

1. Update `config.json` → `version` field
2. Update `CHANGELOG.md` with changes
3. Commit and push:
   ```bash
   git add .
   git commit -m "vX.Y.Z: Description of changes"
   git push
   ```

4. In Home Assistant: **⋮** → **Check for updates**

---

## 📝 Configuration Schema

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `telegram_token` | string | ✅ | Telegram bot token from @BotFather |
| `gateway_token` | string | ✅ | Security token for Gateway authentication |
| `gmail_email` | string | ❌ | Gmail address for email integration |
| `gmail_app_password` | string | ❌ | Gmail app password (16 characters) |
| `timezone` | string | ❌ | Timezone (default: Europe/Lisbon) |

---

## 🐛 Troubleshooting

### Add-on doesn't show up

1. Make sure repository is added correctly
2. Click **⋮** → **Check for updates**
3. Try: `ha supervisor reload` via SSH

### Configuration not saving

1. Make sure you click **Save** after editing
2. Check for validation errors
3. Try clearing browser cache

### Build fails

1. Check `ha addons logs openclaw` for errors
2. Verify all required fields are set
3. Try uninstalling and reinstalling

---

## 📚 Resources

- [Home Assistant Add-on Documentation](https://developers.home-assistant.io/docs/add-ons/)
- [OpenClaw Documentation](https://docs.openclaw.ai)
- [Home Assistant Community](https://community.home-assistant.io/)

---

**License:** MIT  
**Maintainer:** Aleksandr Safronov (@sfrnw)
