# 🦞 OpenClaw + Ollama на Raspberry Pi 5 (8GB)

**Полностью локальная установка — без API ключей**

---

## 📋 Требования

- Raspberry Pi 5 с 8GB RAM
- Home Assistant OS
- SSH доступ включён
- Минимум 4GB свободной RAM

---

## ⚠️ Проверка перед установкой

### 1. Проверь свободную память

```bash
ssh root@homeassistant.local
free -h
```

**Нужно:** минимум 4GB свободно.

### 2. Проверь Home Assistant OS

Ollama требует доступа к Docker. На HA OS это может быть ограничено.

```bash
# Проверь, есть ли docker
docker --version

# Проверь, есть ли доступ к запуску контейнеров
docker ps
```

**Если `docker` не найден** — HA OS не даёт прямого доступа. Нужно:

1. **Вариант A:** Установить Ollama как аддон (если есть)
2. **Вариант B:** Использовать отдельный контейнер
3. **Вариант C:** Перейти на HA Container/Supervised (сложнее)

---

## 🚀 Установка Ollama (если Docker доступен)

### Вариант 1: Docker контейнер (рекомендуется)

```bash
# Создай docker-compose для Ollama
mkdir -p /opt/ollama
cd /opt/ollama

cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  ollama:
    image: ollama/ollama:latest
    container_name: ollama
    restart: unless-stopped
    ports:
      - "11434:11434"
    volumes:
      - ollama_data:/root/.ollama
    deploy:
      resources:
        limits:
          memory: 4G

volumes:
  ollama_data:
EOF

# Запусти
docker compose up -d

# Проверь
docker ps
```

### Вариант 2: Прямая установка (если не HA OS)

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

---

## 📥 Установка модели

```bash
# Подожди пока Ollama запустится
sleep 10

# Выбери модель (начни с маленькой!)
# phi3:mini — 3.8B, хорошее качество, ~2.5GB RAM
docker exec ollama ollama pull phi3:mini

# ИЛИ qwen2.5-coder:3b — 3B, ~2GB RAM
# docker exec ollama ollama pull qwen2.5-coder:3b

# ИЛИ qwen2.5-coder:1.5b — 1.5B, ~1GB RAM (быстро!)
# docker exec ollama ollama pull qwen2.5-coder:1.5b
```

**Проверка:**
```bash
docker exec ollama ollama list
```

---

## 🔧 Настройка OpenClaw аддона

### 1. Обнови `config.json` аддона

Добавь сеть для связи с Ollama:

```json
{
  "name": "OpenClaw AI Assistant",
  "version": "3.0.7",
  ...
  "host_network": true,
  ...
}
```

### 2. Обнови `run.sh`

Добавь настройку Ollama провайдера:

```bash
# В секции генерации конфига добавь:
"models": {
  "providers": {
    "ollama": {
      "baseUrl": "http://host.docker.internal:11434/v1",
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
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "ollama/phi3:mini",
        "fallbacks": []
      }
    }
  }
}
```

### 3. Пересоздай аддон

```bash
# В Home Assistant
ha addons reload
ha addons update openclaw
ha addons restart openclaw
```

---

## 📊 Мониторинг ресурсов

### Проверка памяти

```bash
# Общая память
free -h

# Потребление Docker
docker stats --no-stream
```

### Целевое потребление:

| Компонент | Цель |
|-----------|------|
| Home Assistant | < 1GB |
| Ollama + модель | < 3GB |
| OpenClaw | < 500MB |
| **Всего** | **< 4.5GB** |
| **Свободно** | **> 3.5GB** ✅ |

---

## 🐛 Troubleshooting

### Ollama не запускается

```bash
docker logs ollama
```

**Частые ошибки:**
- `permission denied` → проверь права Docker
- `out of memory` → модель слишком большая, возьми 1.5B

### Модель слишком медленная

- Уменьши модель: `ollama pull qwen2.5-coder:1.5b`
- Останови лишние аддоны HA
- Добавь swap (см. ниже)

### Home Assistant тормозит

**Проблема:** Нехватка RAM.

**Решения:**
1. Уменьши модель Ollama
2. Ограничь память Ollama в `docker-compose.yml`:
   ```yaml
   deploy:
     resources:
       limits:
         memory: 2G  # вместо 4G
   ```
3. Отключи лишние аддоны HA

---

## 🔄 Swap файл (если не хватает RAM)

```bash
# Создай swap 4GB
sudo fallocate -l 4G /var/lib/swapfile
sudo chmod 600 /var/lib/swapfile
sudo mkswap /var/lib/swapfile
sudo swapon /var/lib/swapfile

# Сделай постоянным
echo '/var/lib/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Проверь
free -h
```

⚠️ **Внимание:** Swap медленнее RAM, но спасёт от OOM.

---

## ✅ Чеклист

- [ ] Docker доступен на HA OS
- [ ] Минимум 4GB свободной RAM
- [ ] Ollama запущен (`docker ps`)
- [ ] Модель скачана (`ollama list`)
- [ ] OpenClaw настроен на Ollama
- [ ] Потребление памяти < 5GB
- [ ] Home Assistant работает нормально
- [ ] Telegram бот отвечает

---

## 📈 Оптимизация

### Если память на пределе:

1. **Модель поменьше:**
   ```bash
   docker exec ollama ollama pull qwen2.5-coder:1.5b
   ```

2. **Ограничь память Ollama:**
   ```yaml
   deploy:
     resources:
       limits:
         memory: 2G
   ```

3. **Отключи лишние аддоны HA:**
   ```bash
   ha addons stop <addon>
   ```

4. **Добавь swap** (см. выше)

---

## 🎯 Рекомендуемая конфигурация (8GB RAM)

```yaml
# Ollama docker-compose
services:
  ollama:
    image: ollama/ollama:latest
    deploy:
      resources:
        limits:
          memory: 3G  # Не больше!
    
# Модель
ollama pull phi3:mini  # 3.8B, ~2.5GB RAM
```

**Итоговое потребление:**
- HA OS: ~800MB
- Ollama + phi3:mini: ~2.5GB
- OpenClaw: ~400MB
- **Всего: ~3.7GB**
- **Свободно: ~4.3GB** ✅

---

**Готово!** 🦞 Полностью локальный AI без API ключей!
