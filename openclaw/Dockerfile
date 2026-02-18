ARG BUILD_FROM
FROM ${BUILD_FROM:-node:20-alpine}

# Install system dependencies including Node.js and CMake
RUN apk update && apk add --no-cache \
    git \
    curl \
    gnupg \
    pass \
    openssh-client \
    python3 \
    make \
    cmake \
    g++ \
    linux-headers \
    nodejs \
    npm

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
