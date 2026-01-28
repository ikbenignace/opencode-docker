# Use Microsoft's DevContainer base image with Ubuntu 22.04 (GLIBC 2.35)
# This is required for bun-pty terminal support which needs GLIBC 2.32+
FROM mcr.microsoft.com/devcontainers/base:jammy

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

# Install Node.js and npm
# Note: Using Ubuntu's default Node.js (v12) with npm package
# This is sufficient for installing OpenCode via npm
# TODO: Consider upgrading to a supported Node.js LTS version (v18 or v20) once SSL certificate issues in build environment are resolved
RUN apt-get update && \
    apt-get install -y nodejs npm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install OpenCode using npm
# Note: SSL verification temporarily disabled due to certificate chain issues in build environment
# Downloads latest version; for production use, consider pinning: npm install -g opencode-ai@VERSION
RUN npm config set strict-ssl false && \
    npm install -g opencode-ai && \
    npm config set strict-ssl true

# Set working directory to /root (home directory for projects and config)
WORKDIR /root

# Expose the web UI port
EXPOSE 4096

# Start opencode web on container startup
CMD ["opencode", "web", "--port", "4096", "--hostname", "0.0.0.0"]
