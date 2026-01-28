# Use Microsoft's Universal DevContainer as base
FROM mcr.microsoft.com/devcontainers/universal:2-linux

# Set environment variables
ENV OPENCODE_SERVER_PORT=4096
ENV OPENCODE_SERVER_HOSTNAME=0.0.0.0

# Install opencode globally
RUN npm install -g opencode

# Create data directory for persistent storage
RUN mkdir -p /data && chmod 777 /data

# Set working directory
WORKDIR /data

# Expose the web UI port
EXPOSE 4096

# Start opencode web on container startup
CMD ["opencode", "web", "--port", "4096", "--hostname", "0.0.0.0"]
