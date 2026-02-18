# 🦞 OpenClaw AI Assistant - Home Assistant Add-on

AI personal assistant с интеграцией Telegram, Email и Home Assistant.

## ⚡ Быстрая установка

### 1. Добавь репозиторий

В Home Assistant:
1. **Supervisor** → **Add-on Store**
2. **⋮** (три точки) → **Repositories**
3. Добавь URL: `https://github.com/openclaw/openclaw-addon`
4. **Add**

### 2. Установи Add-on

1. Найди **OpenClaw AI Assistant** в магазине
2. **Install**
3. Дождись установки

### 3. Настрой

**Configuration** → Заполни:

| Поле | Описание | Пример |
|------|----------|--------|
| `telegram_token` | Токен бота от @BotFather | `8382047308:AA...` |
| `telegram_allowed_users` | Твой Telegram ID | `885810` |
| `gateway_token` | Любая строка (безопасность) | `my-secret-token-123` |
| `timezone` | Часовой пояс | `Europe/Lisbon` |
| `gmail_email` | Email для почты (опционально) | `a.d.safronov@gmail.com` |
| `gmail_app_password` | App password от Google | `xxxx xxxx xxxx xxxx` |
| `homeassistant_url` | URL HA (опционально) | `http://homeassistant.local:8123` |
| `homeassistant_token` | Long-lived token HA | `eyJhbG...` |

### 4. Запусти

1. **Start** (если не включено Auto-start)
2. Открой **Open Web UI** или перейди на `http://homeassistant.local:18789`

---

## 🔐 Получение Telegram токена

1. Открой @BotFather в Telegram
2. `/newbot` → придумай имя
3. Скопируй токен
4. Для своего ID: напиши @userinfobot → получишь ID

## 🔐 Gmail App Password

1. https://myaccount.google.com/apppasswords
2. Выбери приложение → "Other"
3. Скопируй 16-значный пароль

## 🔐 Home Assistant Long-lived Token

1. Профиль → **Long-Lived Access Token**
2. **Create Token**
3. Скопируй

---

## 📊 Интеграции

### Telegram
- Отвечает на сообщения
- Уведомления от HA
- Команды через бота

### Email
- Проверка почты (Himalaya CLI)
- Daily digest (cron)

### Home Assistant
- Чтение состояния устройств
- Отправка команд
- Автоматизации через API

### Notion
- Синхронизация задач
- Базы данных

---

## 🛠 Управление

```bash
# Логи
docker logs addon_openclaw

# Перезапуск
docker restart addon_openclaw

# Консоль
docker exec -it addon_openclaw bash
```

---

## 📁 Хранение данных

Данные сохраняются в:
- `/ssl/openclaw/` — credentials, memory
- `/workspace/` — конфиги, скрипты

**Бэкап:**
```bash
tar -czf openclaw-backup.tar.gz /ssl/openclaw/
```

---

## 🐛 Troubleshooting

### Бот не отвечает
1. Проверь токен в настройках
2. Проверь `telegram_allowed_users`
3. Напиши `/start` в Telegram

### Email не работает
1. Проверь app password
2. Проверь логи: `docker logs addon_openclaw | grep himalaya`

### Gateway не открывается
1. Проверь порт 18789
2. Попробуй по IP: `http://192.168.1.XXX:18789`

---

## 📚 Документация

- [OpenClaw Docs](https://docs.openclaw.ai)
- [Home Assistant Add-ons](https://developers.home-assistant.io/docs/add-ons/)

---

**Вопросы?** Пиши в Telegram боту 🦞
