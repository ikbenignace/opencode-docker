# Use Microsoft's Universal DevContainer as base
FROM mcr.microsoft.com/devcontainers/universal:2-linux

# Set environment variables
ENV OPENCODE_SERVER_PORT=4096
ENV OPENCODE_SERVER_HOSTNAME=0.0.0.0

# Install Bun
# Manual installation to handle SSL certificate issues in Docker build environments
# Note: Downloads latest version; for production use, consider pinning to a specific version
RUN curl -fsSL --insecure https://github.com/oven-sh/bun/releases/latest/download/bun-linux-x64.zip -o /tmp/bun.zip && \
    unzip -q /tmp/bun.zip -d /tmp && \
    mkdir -p /root/.bun/bin && \
    mv /tmp/bun-linux-x64/bun /root/.bun/bin/ && \
    chmod +x /root/.bun/bin/bun && \
    rm -rf /tmp/bun.zip /tmp/bun-linux-x64

# Add Bun to PATH
ENV BUN_INSTALL="/root/.bun"
ENV PATH="$BUN_INSTALL/bin:$PATH"

# Install OpenCode using npm (from the base image)
# Note: SSL verification temporarily disabled due to certificate chain issues in build environment
# Downloads latest version; for production use, consider pinning: npm install -g opencode-ai@VERSION
RUN npm config set strict-ssl false && \
    npm install -g opencode-ai && \
    npm config set strict-ssl true

# Create directories for persistent storage with appropriate permissions
# /data: Projects and working directory
# /root/.config/opencode: Global configuration, providers, and oh-my-opencode
RUN mkdir -p /data /root/.config/opencode && \
    chmod 755 /data /root/.config/opencode

# Set working directory to /data for projects
WORKDIR /data

# Expose the web UI port
EXPOSE 4096

# Start opencode web on container startup
CMD ["opencode", "web", "--port", "4096", "--hostname", "0.0.0.0"]
