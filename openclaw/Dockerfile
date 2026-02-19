FROM node:22-bookworm

# Install dependencies (from official docker-setup.sh)
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    gnupg \
    pass \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Install OpenClaw globally
RUN npm install -g openclaw@latest

# Create home directory structure
RUN mkdir -p /home/node/.openclaw && chown -R node:node /home/node

WORKDIR /home/node

# Copy startup script
COPY run.sh /run.sh
RUN chmod +x /run.sh && chown node:node /run.sh

# Run as root (HA add-on container, security handled by HA)
# USER node

EXPOSE 18789

CMD ["/run.sh"]
