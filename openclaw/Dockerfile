FROM ollama/ollama:latest

# Install Node.js
RUN apk add --no-cache nodejs npm git curl jq

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
