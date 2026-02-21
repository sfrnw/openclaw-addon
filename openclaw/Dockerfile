FROM node:22-bookworm

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    gnupg \
    jq \
    ca-certificates \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install Ollama (direct binary download for ARM64)
RUN curl -fsSL https://ollama.com/download/Ollama-linux-arm64.tgz -o /tmp/ollama.tgz \
    && tar -C /usr -xzf /tmp/ollama.tgz \
    && rm /tmp/ollama.tgz \
    && ln -s /usr/bin/ollama /usr/local/bin/ollama

# Install OpenClaw globally
RUN npm install -g openclaw@latest

# Create directories
WORKDIR /data
RUN mkdir -p /data/workspace/memory /data/backups

# Copy scripts
COPY run.sh /run.sh
COPY backup.sh /backup.sh
COPY restore.sh /restore.sh
RUN chmod +x /run.sh /backup.sh /restore.sh

EXPOSE 18789 11434

CMD ["/run.sh"]
