# OpenCode Docker Container

A Docker container for [OpenCode AI](https://opencode.ai/) - an AI coding assistant with a web interface. This container is auto-published to GitHub Container Registry (GHCR) via GitHub Actions.

## Features

- **Base Image**: `mcr.microsoft.com/devcontainers/base:jammy` (Ubuntu 22.04 with GLIBC 2.35 for terminal support)
- **OpenCode Web**: Runs the OpenCode web interface on startup
- **Bun Runtime**: Includes Bun JavaScript runtime (available for use in projects)
- **Port**: Exposes port 4096 for the web UI
- **Persistent Storage**: Single volume mount for the entire home directory
  - `./home` → `/root` - Contains projects, `.config`, and all user data
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
  -v ./home:/root \
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
     -v ./home:/root \
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
  -v ./home:/root \
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

The container uses a single volume mount for the entire home directory:

#### Home Directory (`./home`)
- Mounted at `/root` inside the container
- This is the container's home directory and working directory
- Contains everything:
  - **Projects**: Clone your repositories directly in `/root` (they'll appear in `./home` on your host)
  - **Configuration**: `.config/opencode` directory with provider settings, API keys, and oh-my-opencode
  - **User data**: All other files and directories you create

This simple approach keeps everything in one place - just like a real home directory!

**With Docker Compose:**
- Everything in `./home` directory on your host machine

**With Docker CLI:**
```bash
-v /path/to/your/home:/root
```

**Example workflow:**
1. Start container with `docker-compose up -d`
2. Access the web UI and work on your code
3. Your projects and configs are automatically saved in `./home`
4. Stop container with `docker-compose down`
5. Restart anytime - all your data persists in `./home`

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