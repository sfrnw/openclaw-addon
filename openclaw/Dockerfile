FROM node:22-bookworm

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    gnupg \
    pass \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Install OpenClaw globally
RUN npm install -g openclaw@latest

# Install HA CLI (for ha commands inside container)
RUN curl -L https://github.com/home-assistant/cli/releases/latest/download/ha_aarch64 -o /usr/local/bin/ha \
    && chmod +x /usr/local/bin/ha

WORKDIR /data

# Copy startup script
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Run as root (needed for /data access)
# USER node

EXPOSE 18789

CMD ["/run.sh"]
