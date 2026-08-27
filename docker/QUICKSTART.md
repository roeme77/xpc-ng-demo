# MCP Server Container - Quick Start Guide

**Get the Xen Orchestra MCP Server running in 5 minutes!**

## Prerequisites

- Podman or Docker installed
- Xen Orchestra running and accessible on your network
- Your Xen Orchestra hostname/IP, username, and password (or API token)

## Step 1: Configure Credentials

```bash
cd docker
cp .env.example .env
nano .env
```

Edit `.env` with your Xen Orchestra details:

```env
XO_HOST=10.0.4.20          # Replace with your XO IP/hostname
XO_PORT=80                 # Usually 80 or 443
XO_USER=admin@admin.net    # Your XO username
XO_PASSWORD=admin          # Your XO password
```

## Step 2: Start the Container

```bash
podman-compose up -d
```

That's it! The container will:
- ✓ Validate your credentials
- ✓ Connect to Xen Orchestra
- ✓ Start the MCP server on port 3000

## Step 3: Verify It's Working

```bash
# Check the logs
podman-compose logs mcp-server

# You should see:
# ✓ Credentials validated
# ✓ Successfully connected to Xen Orchestra at http://10.0.4.20:80
# MCP Server listening on port 3000
```

## Test the API

```bash
# Health check
podman exec xpc-ng-mcp-server curl http://localhost:3000/health | jq .

# Server status
podman exec xpc-ng-mcp-server curl http://localhost:3000/status | jq .

# Server info & capabilities
podman exec xpc-ng-mcp-server curl http://localhost:3000/info | jq .
```

## Useful Commands

```bash
# View live logs
podman-compose logs -f mcp-server

# Stop the server
podman-compose stop

# Restart the server
podman-compose restart

# Remove the container (clean shutdown)
podman-compose down
```

## Troubleshooting

### "Connection refused" error?
- Verify `XO_HOST` is correct and accessible from your machine
- Check Xen Orchestra is running: `curl http://<XO_HOST>:<XO_PORT>`

### "Credentials validated" but other errors?
- Check username/password in `.env`
- Verify user has API access in Xen Orchestra

### Need more details?
See `README.md` or `../ai-coding-tools/docs/02-deployment-runbook.md` for comprehensive documentation.

## Next Steps

Once the MCP server is running:
- Use it with Terraform for infrastructure validation
- Integrate with Ansible for configuration management
- Query Xen Orchestra infrastructure via the `/info` endpoint

---

**Need help?** Check the logs with `podman-compose logs mcp-server`
