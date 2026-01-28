# OpenCode Docker Container

A Docker container for [OpenCode AI](https://opencode.ai/) - an AI coding assistant with a web interface. This container is auto-published to GitHub Container Registry (GHCR) via GitHub Actions.

## Features

- **Base Image**: `mcr.microsoft.com/devcontainers/universal:2-linux` (multi-language support + git)
- **OpenCode Web**: Runs the OpenCode web interface on startup
- **Bun Runtime**: Includes Bun JavaScript runtime for enhanced performance
- **Port**: Exposes port 4096 for the web UI
- **Persistent Storage**: Separate volumes for projects and configuration
  - `./data` - Projects and working directory
  - `./config` - Global configuration, providers, and oh-my-opencode settings
- **Auto-Published**: Automatically built and published to GHCR when Dockerfile changes

## Quick Start

### Using Docker Compose (Recommended)

1. Clone this repository:
   ```bash
   git clone https://github.com/ikbenignace/opencode-docker.git
   cd opencode-docker
   ```

2. Start the container:
   ```bash
   docker-compose up -d
   ```

3. Access the OpenCode web interface at:
   ```
   http://localhost:4096
   ```

4. Stop the container:
   ```bash
   docker-compose down
   ```

### Using Pre-built Image from GHCR

You can use the pre-built image without cloning the repository:

```bash
docker run -d \
  --name opencode-web \
  -p 4096:4096 \
  -v ./data:/data \
  -v ./config:/root/.config/opencode \
  ghcr.io/ikbenignace/opencode-docker:latest
```

### Using Docker CLI (Build Locally)

1. Clone and build:
   ```bash
   git clone https://github.com/ikbenignace/opencode-docker.git
   cd opencode-docker
   docker build -t opencode-docker .
   ```

2. Run the container:
   ```bash
   docker run -d \
     --name opencode-web \
     -p 4096:4096 \
     -v ./data:/data \
     -v ./config:/root/.config/opencode \
     opencode-docker
   ```

## Configuration

### Environment Variables

You can customize the OpenCode server with environment variables:

- `OPENCODE_SERVER_PORT`: Port for the web interface (default: 4096)
- `OPENCODE_SERVER_HOSTNAME`: Hostname to bind to (default: 0.0.0.0)
- `OPENCODE_SERVER_PASSWORD`: Optional password for authentication
- `OPENCODE_SERVER_USERNAME`: Optional username for authentication (default: opencode)

Example with authentication:
```bash
docker run -d \
  --name opencode-web \
  -p 4096:4096 \
  -v ./data:/data \
  -v ./config:/root/.config/opencode \
  -e OPENCODE_SERVER_PASSWORD=your-secure-password-here \
  -e OPENCODE_SERVER_USERNAME=admin \
  ghcr.io/ikbenignace/opencode-docker:latest
```

Or in `docker-compose.yml`:
```yaml
environment:
  - OPENCODE_SERVER_PORT=4096
  - OPENCODE_SERVER_HOSTNAME=0.0.0.0
  - OPENCODE_SERVER_PASSWORD=your-secure-password-here
  - OPENCODE_SERVER_USERNAME=admin
```

**Important**: Replace `your-secure-password-here` with a strong, unique password in production environments.

### Persistent Storage

The container uses two separate volumes for persistent storage:

#### 1. Projects Directory (`./data`)
- Mounted at `/data` inside the container
- This is your working directory where you work on code projects
- All project files and project-specific `.opencode/` directories are stored here

#### 2. Configuration Directory (`./config`)
- Mounted at `/root/.config/opencode` inside the container
- Stores global OpenCode configuration including:
  - Provider settings (API keys for OpenAI, Anthropic, etc.)
  - Oh-my-opencode installations and configurations
  - Global agents, commands, and plugins
  - User preferences and themes

**With Docker Compose:**
- Projects: `./data` in your current directory
- Config: `./config` in your current directory

**With Docker CLI, specify both volume mounts:**
```bash
-v /path/to/your/projects:/data \
-v /path/to/your/config:/root/.config/opencode
```

This separation ensures that your provider configurations and global settings persist independently from your project files.

## Accessing the Web Interface

Once the container is running, open your browser and navigate to:

```
http://localhost:4096
```

If you're running Docker on a remote server, replace `localhost` with your server's IP address.

## Building from Source

To build the image locally:

```bash
docker build -t opencode-docker .
```

Or with Docker Compose:

```bash
docker-compose build
```

## GitHub Actions Auto-Publishing

This repository includes a GitHub Actions workflow that automatically builds and publishes the Docker image to GitHub Container Registry (GHCR) when:

- Code is pushed to the `main` or `master` branch
- A new tag is created (e.g., `v1.0.0`)
- Manually triggered via workflow dispatch

The published image is available at:
```
ghcr.io/ikbenignace/opencode-docker:latest
```

## Troubleshooting

### Container won't start

Check the container logs:
```bash
docker-compose logs opencode
# or
docker logs opencode-web
```

### Cannot access the web interface

1. Verify the container is running:
   ```bash
   docker ps
   ```

2. Check if port 4096 is exposed:
   ```bash
   docker port opencode-web
   ```

3. Ensure no firewall is blocking port 4096

### Data not persisting

Ensure the volume is properly mounted. Check with:
```bash
docker inspect opencode-web
```

Look for the "Mounts" section to verify the volume is attached.

## License

This Docker configuration is provided as-is. OpenCode itself is licensed under its own terms - please refer to the [OpenCode repository](https://github.com/opencode-ai/opencode) for details.

## Resources

- [OpenCode Official Documentation](https://opencode.ai/docs/)
- [OpenCode Web Docs](https://opencode.ai/docs/web/)
- [GitHub Container Registry](https://ghcr.io)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.