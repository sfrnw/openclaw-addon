# 🦞 OpenClaw Home Assistant Add-on Repository

Репозиторий для публикации OpenClaw как Home Assistant Add-on.

## 📁 Структура

```
homeassistant-addon/
└── openclaw/
    ├── config.json      # Конфигурация add-on
    ├── Dockerfile       # Сборка образа
    ├── run.sh           # Скрипт запуска
    └── README.md        # Инструкция для пользователя
```

## 🚀 Публикация Add-on

### Вариант 1: GitHub Repository (рекомендуется)

1. **Создай репозиторий** на GitHub:
   ```bash
   cd ~/.openclaw/workspace/pi-deploy/homeassistant-addon
   git init
   git add .
   git commit -m "Initial OpenClaw add-on"
   git remote add origin https://github.com/YOUR_USERNAME/openclaw-addon.git
   git push -u origin main
   ```

2. **Добавь в HA Supervisor**:
   - Supervisor → Add-on Store
   - ⋮ → Repositories
   - Добавь: `https://github.com/YOUR_USERNAME/openclaw-addon`
   - **Add**

3. **Установи**:
   - Найди "OpenClaw AI Assistant"
   - Install → Start

### Вариант 2: Локальная установка (для тестов)

1. **Скопируй в HA**:
   ```bash
   # Через SSH на Pi
   scp -r openclaw/ root@homeassistant.local:/addons/
   ```

2. **Перезагрузи Supervisor**:
   - Developer Tools → YAML → Check Configuration
   - Или: `ha supervisor reload`

3. **Установи**:
   - Supervisor → Add-on Store → OpenClaw

---

## 🔧 Сборка образа (опционально)

Если хочешь опубликовать образ в GHCR:

```bash
# Локальная сборка
docker build -t openclaw-addon-aarch64 .

# Тест
docker run -p 18789:18789 openclaw-addon-aarch64
```

---

## 📝 Конфигурация

### config.json

| Поле | Значение |
|------|----------|
| `name` | OpenClaw AI Assistant |
| `version` | 1.0.0 |
| `arch` | aarch64, armv7 (Pi совместимо) |
| `ports` | 18789/tcp |
| `startup` | application |

### Переменные (schema)

| Переменная | Required | Описание |
|------------|----------|----------|
| `telegram_token` | ✅ | Токен бота |
| `telegram_allowed_users` | ✅ | Список ID |
| `gateway_token` | ✅ | Токен безопасности |
| `timezone` | ❌ | Europe/Lisbon |
| `gmail_email` | ❌ | Email |
| `gmail_app_password` | ❌ | App password |
| `notion_api_key` | ❌ | Notion API |
| `homeassistant_url` | ❌ | HA URL |
| `homeassistant_token` | ❌ | HA Token |

---

## 🎯 Следующие шаги

1. **Создать GitHub репозиторий** для add-on
2. **Запушить файлы**
3. **Добавить в HA Supervisor**
4. **Установить и настроить**

---

## 📚 Ресурсы

- [HA Add-on Documentation](https://developers.home-assistant.io/docs/add-ons/)
- [HA Add-on Examples](https://github.com/home-assistant/addons)
- [OpenClaw Docs](https://docs.openclaw.ai)

---

🦞
