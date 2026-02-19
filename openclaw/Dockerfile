FROM node:20-alpine

# Install dependencies
RUN apk add --no-cache git curl gnupg pass jq

# Install OpenClaw
RUN npm install -g openclaw

# Copy startup script
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Expose port
EXPOSE 18789

# Run
CMD ["/run.sh"]
