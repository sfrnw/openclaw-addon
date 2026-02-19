FROM node:20-alpine

# Install dependencies
RUN apk add --no-cache git curl gnupg pass jq

# Install OpenClaw globally
RUN npm install -g openclaw && \
    # Verify installation
    which openclaw && \
    openclaw --version

# Add npm global bin to PATH
ENV PATH="/root/.npm-global/bin:$PATH"

# Copy startup script
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Expose port
EXPOSE 18789

# Run
CMD ["/run.sh"]
