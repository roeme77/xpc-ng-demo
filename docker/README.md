# MCP Server Docker Container

Multi-runtime compatible MCP (Xen Orchestra) server container supporting Docker and Podman.

## Quick Start

### 1. Setup Configuration

```bash
# Copy environment template
cp .env.example .env

# Edit with your Xen Orchestra credentials
nano .env
```

### 2. Build and Run

#### With Docker

```bash
# Build image
docker build -t xpc-ng-demo-mcp-server:latest -f mcp-server/Dockerfile .

# Run with docker-compose
docker-compose up -d

# View logs
docker-compose logs -f mcp-server
```

#### With Podman

```bash
# Build image
podman build -t xpc-ng-demo-mcp-server:latest -f mcp-server/Dockerfile .

# Run with podman-compose
podman-compose up -d

# View logs
podman-compose logs -f mcp-server
```

### 3. Verify

```bash
# Check container status
docker-compose ps
# or
podman-compose ps

# Check health
docker-compose ps | grep healthy
# or
podman-compose ps | grep healthy
```

## Configuration

### Environment Variables

Set in `.env` file:

- **XO_HOST** - Xen Orchestra hostname/IP (required)
- **XO_USER** - Xen Orchestra username (required)
- **XO_PASSWORD** - Xen Orchestra password (required)
- **XO_PORT** - Xen Orchestra API port (default: 443)
- **MCP_SERVER_PORT** - MCP server port (default: 3000)
- **NODE_ENV** - Node environment: production/development (default: production)
- **LOG_LEVEL** - Log level: error/warn/info/debug (default: info)

### Volume Mounts

- `/config` - Config directory for .mcp.json (read-only)
- `/app/logs` - Logs directory (optional)

## Compatibility

### Tested With

- ✅ Docker 20.10+
- ✅ Docker Compose 2.0+
- ✅ Podman 4.0+
- ✅ Podman Compose 1.0+

### Key Features

- Multi-runtime compatible (no Docker-specific features)
- Standard bridge networking (works with both runtimes)
- Health checks enabled
- Non-root user execution
- Resource limits defined
- Structured logging

## Troubleshooting

### Container won't start

```bash
# Check logs
docker-compose logs mcp-server
# or
podman-compose logs mcp-server

# Verify environment variables
docker-compose config
# or
podman-compose config
```

### Health check failing

- Verify XO_HOST, XO_USER, XO_PASSWORD are correct
- Check network connectivity to Xen Orchestra
- Ensure credentials have proper permissions

### Port already in use

- Change `MCP_SERVER_PORT` in `.env` or docker-compose.yml
- Or kill existing process: `lsof -i :3000`

## Build Arguments

For custom builds:

```bash
docker build -t xpc-ng-demo-mcp-server:latest \
  --build-arg NODE_VERSION=24 \
  -f mcp-server/Dockerfile .
```

## Security Considerations

1. **Credentials**: Use `.env` file (git-ignored) for secrets
2. **Non-root user**: Container runs as `mcp` user (UID 1000)
3. **Read-only config**: `/config` mounted as read-only
4. **Resource limits**: CPU and memory limits defined
5. **Health checks**: Automatic container restart on failure

## Development

For development with live reloading:

```bash
# Create docker-compose.override.yml
docker-compose -f docker-compose.yml -f docker-compose.override.yml up -d
```

Example override for development:

```yaml
version: '3.8'
services:
  mcp-server:
    environment:
      NODE_ENV: development
      LOG_LEVEL: debug
    volumes:
      - .:/app:rw
```

## Cleanup

```bash
# Stop containers
docker-compose down
# or
podman-compose down

# Remove images
docker rmi xpc-ng-demo-mcp-server:latest
# or
podman rmi xpc-ng-demo-mcp-server:latest

# Remove all data
rm -rf logs/ config/
```
