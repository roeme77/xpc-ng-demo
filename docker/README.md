# MCP Server Docker Container

Multi-runtime compatible MCP (Xen Orchestra) server container supporting Docker and Podman.

**Status:** ✅ Fully tested and working with Xen Orchestra

## Quick Start (5 minutes)

### 1. Setup Configuration

```bash
cd docker

# Copy environment template
cp .env.example .env

# Edit with your Xen Orchestra credentials
nano .env
```

**Required in .env:**
```env
XO_HOST=10.0.4.20          # Your Xen Orchestra IP
XO_PORT=80                 # Port (usually 80 or 443)
XO_USER=admin@admin.net    # Your XO username
XO_PASSWORD=admin          # Your XO password
```

Alternatively, use API token instead of password:
```env
XO_TOKEN=your-api-token-here
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

#### With Podman (Tested ✓)

```bash
# Build image
podman build -t xpc-ng-demo-mcp-server:latest -f mcp-server/Dockerfile .

# Run with podman-compose
podman-compose up -d

# View logs
podman-compose logs -f mcp-server
```

### 3. Verify It's Working

```bash
# Check container status
podman-compose ps

# Test health endpoint (from within container)
podman exec xpc-ng-mcp-server curl -s http://localhost:3000/health | jq .

# Expected response:
# {
#   "status": "ok",
#   "timestamp": "2026-08-27T20:27:07.437Z",
#   "xo_host": "10.0.4.20",
#   "xo_port": 80
# }
```

## API Endpoints

Once running, the MCP server exposes three endpoints:

### Health Check
```bash
curl http://localhost:3000/health

# Response:
{
  "status": "ok",
  "timestamp": "2026-08-27T20:27:07.437Z",
  "xo_host": "10.0.4.20",
  "xo_port": 80
}
```

### Server Status
```bash
curl http://localhost:3000/status

# Response:
{
  "status": "running",
  "service": "Xen Orchestra MCP Server",
  "version": "1.0.0",
  "xo": {
    "host": "10.0.4.20",
    "port": 80,
    "user": "admin@admin.net"
  },
  "timestamp": "2026-08-27T20:27:12.902Z"
}
```

### Server Information
```bash
curl http://localhost:3000/info

# Response:
{
  "name": "Xen Orchestra MCP Server",
  "description": "Model Context Protocol server for Xen Orchestra",
  "version": "1.0.0",
  "author": "XPC-NG Demo",
  "capabilities": [
    "VM queries (read-only)",
    "Host queries (read-only)",
    "Storage queries (read-only)",
    "Network queries (read-only)",
    "Infrastructure audit"
  ],
  "xo_connection": {
    "host": "10.0.4.20",
    "port": 80,
    "authenticated": true
  }
}
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
