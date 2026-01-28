# Use Microsoft's Universal DevContainer as base
FROM mcr.microsoft.com/devcontainers/universal:2-linux

# Set environment variables
ENV OPENCODE_SERVER_PORT=4096
ENV OPENCODE_SERVER_HOSTNAME=0.0.0.0

# Install opencode globally
# Note: strict-ssl is temporarily disabled during installation to handle certificate chain issues
# in Docker build environments. This is re-enabled immediately after installation.
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
