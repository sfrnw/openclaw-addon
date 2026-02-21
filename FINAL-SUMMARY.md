# 🦞 OpenClaw v3.1.0 — ГОТОВО!

## ✅ ЧТО СДЕЛАНО

### Код
- [x] **Ollama интегрирована** в аддон (локальная модель)
- [x] **phi3:mini** выбрана как основная (3.8B, ~2.5GB RAM)
- [x] **Автоматическая загрузка** модели при первом запуске
- [x] **Backup/Restore** скрипты
- [x] **Конфигурация** через UI Home Assistant
- [x] **Залито в GitHub**: https://github.com/sfrnw/openclaw-addon

### Документы
- [x] `START-HERE.md` — пошаговый запуск
- [x] `TESTING.md` — проверка работы
- [x] `README.md` — полная документация
- [x] `CHANGELOG.md` — история изменений

---

## 🚀 КАК ЗАПУСТИТЬ (кратко)

### 1. Обнови репозиторий в HA
```
Настройки → Дополнения → ⋮ → Проверить обновления
```

### 2. Обнови аддон
```
Настройки → Дополнения → OpenClaw → Обновить
```

### 3. Настрой
**Конфигурация:**
```
telegram_token: 123456789:ABCdef...  (получи в @BotFather)
model: phi3:mini
```

### 4. Запусти
**Информация → Запустить**

### 5. Жди 5-10 минут
Первый запуск — скачивается модель (~2GB)

### 6. Смотри логи
**Журнал** — должно быть: `🦞 OpenClaw is ready!`

### 7. Скопируй Gateway Token
Из логов: `🔑 Gateway Token: abc123...`

### 8. Открой Web UI
**Информация → Открыть веб-интерес**

### 9. Настрой allowlist
Web UI → Credentials → Telegram → добавь свой ID

### 10. ТЕСТ!
В Telegram: `/start` → `привет`

---

## 📊 РЕСУРСЫ

| Компонент | RAM |
|-----------|-----|
| Ollama сервер | ~200MB |
| phi3:mini модель | ~2.5GB |
| OpenClaw | ~400MB |
| **Итого** | **~3.1GB** |

**На Pi 5 с 8GB остаётся ~5GB для HA** ✅

---

## 🔧 КОМАНДЫ ЧЕРЕЗ SSH

```bash
# Логи
ha addons logs openclaw

# Перезапуск
ha addons restart openclaw

# Бэкап
ha addons exec openclaw --command "/backup.sh"

# Статус
ha addons info openclaw

# Проверка Ollama
ha addons exec openclaw --command "curl http://localhost:11434/api/tags"
```

---

## 🐛 ТROUBLESHOOTING

### Аддон не запускается
```bash
ha addons logs openclaw | tail -50
```

### Модель долго скачивается
**Нормально!** 2GB = 5-15 минут в зависимости от интернета.

### Telegram не отвечает
1. Проверь токен в конфигурации
2. Проверь allowlist (Web UI → Credentials)
3. Перезапусти: `ha addons restart openclaw`

### Home Assistant тормозит
```bash
free -h  # проверь память
```
Если >80% использовано — останови лишние аддоны.

---

## 📁 ФАЙЛЫ АДДОНА

```
homeassistant-addon/
├── openclaw/
│   ├── config.json       # Конфиг аддона
│   ├── Dockerfile        # Образ контейнера
│   ├── run.sh            # Скрипт запуска
│   ├── backup.sh         # Бэкап
│   ├── restore.sh        # Восстановление
│   ├── README.md         # Документация
│   └── CHANGELOG.md      # История
├── START-HERE.md         # БЫСТРЫЙ СТАРТ
├── TESTING.md            # Проверка
├── OLLAMA-SETUP.md       # Документация Ollama
├── INSTALL-GUIDE.md      # Подробная установка
├── README-RU.md          # Кратко на русском
└── repository.json       # Мета репозитория
```

---

## 🎯 ССЫЛКИ

- **Репозиторий:** https://github.com/sfrnw/openclaw-addon
- **Добавить в HA:** `https://github.com/sfrnw/openclaw-addon`
- **Документация:** В репозитории и в Web UI

---

## 📞 ЕСЛИ ЧТО-ТО НЕ РАБОТАЕТ

Пришли:
1. `ha addons logs openclaw | tail -100`
2. `ha addons info openclaw`
3. `free -h`

Разберёмся! 🦞

---

**ВСЁ ГОТОВО К ЗАПУСКУ!** 🚀
