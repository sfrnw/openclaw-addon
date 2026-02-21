FROM node:22-bookworm

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    gnupg \
    jq \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Install OpenClaw globally
RUN npm install -g openclaw@latest

# Create directories
WORKDIR /data
RUN mkdir -p /data/workspace/memory

# Copy startup script
COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 18789 11434

CMD ["/run.sh"]
