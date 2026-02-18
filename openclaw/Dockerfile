ARG BUILD_FROM
FROM $BUILD_FROM

# Install dependencies
RUN apk add --no-cache \
    nodejs \
    npm \
    git \
    curl \
    gnupg \
    pass \
    openssh-client

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
