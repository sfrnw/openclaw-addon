ARG BUILD_FROM
FROM ${BUILD_FROM:-node:20-alpine}

# Install system dependencies needed for OpenClaw
RUN apk add --no-cache \
    git \
    curl \
    gnupg \
    pass \
    openssh-client \
    python3 \
    make \
    g++ \
    linux-headers

# Install OpenClaw globally
RUN npm install -g openclaw

# Create workspace directory
WORKDIR /workspace

# Copy entrypoint script
COPY run.sh /run.sh
RUN chmod a+x /run.sh

# Expose Gateway port
EXPOSE 18789

# Run OpenClaw
CMD ["/run.sh"]
