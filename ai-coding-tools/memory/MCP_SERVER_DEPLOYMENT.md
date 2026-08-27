---
name: mcp-server-deployment-guide
description: Complete MCP server deployment guide - tested with Podman and Xen Orchestra (10.0.4.20:80)
metadata:
  type: project
---

# MCP Server Container Deployment

**Status:** ✅ Fully tested and production-ready
**Date Tested:** 2026-08-27
**Container Runtime:** Podman ✓ | Docker ✓
**Xen Orchestra:** 10.0.4.20:80 ✓

## Quick Reference

### For New Users: Start Here
→ See `docker/QUICKSTART.md` for 5-minute setup

### For Team Deployment
→ See `docker/README.md` for complete documentation

### For Troubleshooting
→ See `ai-coding-tools/docs/02-deployment-runbook.md` for comprehensive guide

## One-Liner Setup

```bash
cd docker
cp .env.example .env
nano .env  # Edit XO_HOST, XO_USER, XO_PASSWORD
podman-compose up -d
podman-compose logs mcp-server  # Verify "Successfully connected to Xen Orchestra"
```

## Verification

Container startup logs should show:
- ✓ Credentials validated
- ✓ Successfully connected to Xen Orchestra at http://<XO_HOST>:<XO_PORT>
- ✓ MCP Server listening on port 3000

Test endpoints:
```bash
podman exec xpc-ng-mcp-server curl -s http://localhost:3000/health | jq .
podman exec xpc-ng-mcp-server curl -s http://localhost:3000/status | jq .
podman exec xpc-ng-mcp-server curl -s http://localhost:3000/info | jq .
```

## Key Features

- **Multi-Runtime:** Works with Docker and Podman
- **Secure:** Validates credentials on startup, tests connectivity
- **Observable:** Color-coded logs, clear error messages
- **Reliable:** Proper error handling and graceful startup
- **API Endpoints:**
  - `/health` - Health check with XO status
  - `/status` - Server status and connection details
  - `/info` - Capabilities and authenticated connection info

## Network Configuration

- **Default:** Host network mode (required for local network access to XO)
- Alternative: Bridge network (if XO_HOST is accessible from container's bridge)

## Credentials

**Three ways to authenticate:**

1. **Password** (most common)
   ```env
   XO_USER=admin@admin.net
   XO_PASSWORD=your-password
   ```

2. **Token** (recommended for CI/CD)
   ```env
   XO_USER=admin@admin.net
   XO_TOKEN=your-api-token
   ```

3. **Both** (token takes precedence if both set)

## Files

- `docker/Dockerfile` - Multi-runtime compatible image (node:24-slim)
- `docker/docker-compose.yml` - Orchestration config
- `docker/mcp-server/entrypoint.sh` - Startup script with validation
- `docker/.env.example` - Credential template
- `docker/README.md` - User-facing documentation
- `docker/QUICKSTART.md` - 5-minute quick start
- `ai-coding-tools/docs/02-deployment-runbook.md` - Comprehensive runbook

## Tested Configuration

```
XO_HOST: 10.0.4.20
XO_PORT: 80
XO_USER: admin@admin.net
XO_PASSWORD: admin
Container Runtime: Podman 4.0+
Docker Compose: podman-compose 1.0+
Status: ✅ All endpoints responding correctly
```

## Common Commands

```bash
cd docker

# Build
podman build -t xpc-ng-demo-mcp-server:latest -f mcp-server/Dockerfile .

# Run
podman-compose up -d

# View logs
podman-compose logs -f mcp-server

# Test
podman exec xpc-ng-mcp-server curl http://localhost:3000/health | jq .

# Stop
podman-compose stop

# Restart
podman-compose restart

# Clean shutdown
podman-compose down
```

## Next Steps

Once MCP server is running:
1. **Plan 03:** Integrate with Terraform for infrastructure validation
2. **Ansible:** Use for configuration management
3. **Monitoring:** Subscribe to `/health` endpoint for uptime tracking

---

**For more details:** See the linked documentation files or run `docker/mcp-server/entrypoint.sh help`
