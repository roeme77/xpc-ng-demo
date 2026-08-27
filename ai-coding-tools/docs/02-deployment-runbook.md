# MCP Server Deployment Runbook

**Tested and verified deployment instructions for Xen Orchestra MCP server container**

**Status:** ✅ Fully tested with Podman and Xen Orchestra (10.0.4.20:80)

## Table of Contents

1. [System Requirements](#system-requirements)
2. [Docker Deployment](#docker-deployment)
3. [Podman Deployment](#podman-deployment)
4. [Verification](#verification)
5. [Troubleshooting](#troubleshooting)
6. [Maintenance](#maintenance)

---

## System Requirements

### Docker
- Docker 20.10+
- Docker Compose 2.0+
- 512MB available RAM
- 2GB disk space

### Podman
- Podman 4.0+
- Podman Compose 1.0+
- 512MB available RAM
- 2GB disk space

### Both
- Xen Orchestra instance running and accessible
- Valid XO credentials (admin or API user)
- Network connectivity from host to Xen Orchestra

---

## Docker Deployment

### 1. Clone Repository

```bash
cd /path/to/xpc-ng-demo
cd docker
```

### 2. Configure Credentials

```bash
# Copy environment template
cp .env.example .env

# Edit with your credentials
nano .env
```

**Required fields:**
```env
XO_HOST=your-xen-orchestra.com
XO_USER=admin
XO_PASSWORD=your-secure-password
XO_PORT=443
```

### 3. Build Image

```bash
# Build from Dockerfile
docker build -t xpc-ng-demo-mcp-server:latest -f mcp-server/Dockerfile .

# Verify image was created
docker images | grep mcp-server
```

### 4. Start Container

```bash
# Start with docker-compose (uses host network for XO access)
docker-compose up -d

# Or manually:
docker run -d \
  --name xpc-ng-mcp-server \
  --restart unless-stopped \
  --net=host \
  --env-file .env \
  -v $(pwd)/config:/config:ro \
  -v $(pwd)/logs:/app/logs \
  xpc-ng-demo-mcp-server:latest
```

### 5. Verify

```bash
# Check container status
docker-compose ps

# Check logs (should show connection to XO successful)
docker-compose logs -f mcp-server

# Expected output:
# ✓ Credentials validated
# ✓ Successfully connected to Xen Orchestra at http://10.0.4.20:80
# MCP Server listening on port 3000

# Test health from within container
docker exec xpc-ng-mcp-server curl -s http://localhost:3000/health | jq .
```

### 6. Stop/Restart

```bash
# Stop
docker-compose stop

# Restart
docker-compose restart

# Remove (clean stop)
docker-compose down
```

---

## Podman Deployment

### 1. Clone Repository

```bash
cd /path/to/xpc-ng-demo
cd docker
```

### 2. Configure Credentials

```bash
# Copy environment template
cp .env.example .env

# Edit with your credentials
nano .env
```

**Required fields:**
```env
XO_HOST=your-xen-orchestra.com
XO_USER=admin
XO_PASSWORD=your-secure-password
XO_PORT=443
```

### 3. Build Image

```bash
# Build from Dockerfile (OCI-compliant)
podman build -t xpc-ng-demo-mcp-server:latest -f mcp-server/Dockerfile .

# Verify image was created
podman images | grep mcp-server
```

### 4. Start Container

```bash
# Start with podman-compose (uses host network for XO access)
podman-compose up -d

# Or manually:
podman run -d \
  --name xpc-ng-mcp-server \
  --restart always \
  --net=host \
  --env-file .env \
  -v $(pwd)/config:/config:ro \
  -v $(pwd)/logs:/app/logs \
  xpc-ng-demo-mcp-server:latest
```

### 5. Verify

```bash
# Check container status
podman-compose ps
# or
podman ps | grep mcp-server

# Check logs (should show XO connection successful)
podman-compose logs -f mcp-server
# or
podman logs -f xpc-ng-mcp-server

# Expected output:
# ✓ Credentials validated
# ✓ Successfully connected to Xen Orchestra at http://10.0.4.20:80
# MCP Server listening on port 3000

# Test health from within container
podman exec xpc-ng-mcp-server curl -s http://localhost:3000/health | jq .
```

### 6. Stop/Restart

```bash
# Stop
podman-compose stop
# or
podman stop xpc-ng-mcp-server

# Restart
podman-compose restart
# or
podman restart xpc-ng-mcp-server

# Remove (clean stop)
podman-compose down
# or
podman rm -f xpc-ng-mcp-server
```

---

## Verification

### Startup Verification (Tested ✓)

After starting the container, verify these steps in the logs:

```bash
# View container logs
podman-compose logs mcp-server

# Expected log sequence:
# ✓ Starting Xen Orchestra MCP Server...
# ✓ Validating Xen Orchestra credentials...
# ✓ Credentials validated
#   XO_HOST: 10.0.4.20
#   XO_PORT: 80
#   XO_USER: admin@admin.net
#   XO_AUTH: Password (or Token)
# ✓ Testing connectivity to Xen Orchestra...
# ✓ Successfully connected to Xen Orchestra at http://10.0.4.20:80
# ✓ Creating MCP configuration...
# ✓ Starting Node.js MCP server process...
# ✓ MCP Server listening on port 3000
# [timestamp] Connected to Xen Orchestra: 10.0.4.20:80
# [timestamp] Try: curl http://localhost:3000/health
```

### API Endpoint Health Check

```bash
# Test health endpoint (from within container)
podman exec xpc-ng-mcp-server curl -s http://localhost:3000/health | jq .

# Expected response:
{
  "status": "ok",
  "timestamp": "2026-08-27T20:27:07.437Z",
  "xo_host": "10.0.4.20",
  "xo_port": 80
}
```

### Test All Endpoints

```bash
# Health endpoint
podman exec xpc-ng-mcp-server curl -s http://localhost:3000/health | jq .

# Status endpoint
podman exec xpc-ng-mcp-server curl -s http://localhost:3000/status | jq .

# Info endpoint (capabilities)
podman exec xpc-ng-mcp-server curl -s http://localhost:3000/info | jq .
```

### Full Verification Checklist

```bash
# 1. Container running?
podman ps | grep mcp-server

# 2. Logs show successful startup?
podman logs xpc-ng-mcp-server | grep "Successfully connected"

# 3. Health endpoint responding?
podman exec xpc-ng-mcp-server curl -s http://localhost:3000/health | jq .status

# 4. Environment variables set?
podman exec xpc-ng-mcp-server env | grep XO_

# 5. Xen Orchestra connection verified?
podman exec xpc-ng-mcp-server curl -s http://localhost:3000/info | jq .xo_connection
```

---

## Troubleshooting

### Container Won't Start

```bash
# Check logs for errors
docker logs xpc-ng-mcp-server
# or
podman logs xpc-ng-mcp-server

# Common issues:
# 1. Port 3000 already in use
#    → Change MCP_SERVER_PORT in .env
#    → Or kill existing: lsof -i :3000

# 2. Missing credentials
#    → Verify .env file has XO_HOST, XO_USER, XO_PASSWORD
#    → Ensure values are not empty or quoted

# 3. Out of disk/memory
#    → Check: df -h
#    → Check: free -h
```

### Health Check Failing

```bash
# 1. Is container running?
docker ps | grep mcp-server

# 2. Is port accessible?
netstat -tlnp | grep 3000

# 3. Check logs for errors
docker logs xpc-ng-mcp-server

# 4. Test connectivity to Xen Orchestra
docker exec xpc-ng-mcp-server curl https://<XO_HOST>:443 -k

# 5. Verify credentials
docker exec xpc-ng-mcp-server env | grep XO_
```

### Connection Refused

```bash
# Port mapping wrong?
docker port xpc-ng-mcp-server

# Try accessing from container
docker exec xpc-ng-mcp-server curl http://localhost:3000/health

# Check firewall
sudo ufw status
sudo firewall-cmd --list-ports
```

### High Memory/CPU Usage

```bash
# Check resource stats
docker stats xpc-ng-mcp-server
# or
podman stats xpc-ng-mcp-server

# Adjust limits in docker-compose.yml:
# deploy:
#   resources:
#     limits:
#       cpus: '1'
#       memory: 256M
```

---

## Maintenance

### View Logs

```bash
# Recent logs
docker logs xpc-ng-mcp-server
# or
podman logs xpc-ng-mcp-server

# Follow logs (live)
docker logs -f xpc-ng-mcp-server
# or
podman logs -f xpc-ng-mcp-server

# Last 100 lines
docker logs --tail 100 xpc-ng-mcp-server
# or
podman logs --tail 100 xpc-ng-mcp-server

# With timestamps
docker logs -t xpc-ng-mcp-server
# or
podman logs -t xpc-ng-mcp-server
```

### Update Container

```bash
# Pull latest changes
git pull

# Rebuild image
docker build -t xpc-ng-demo-mcp-server:latest -f mcp-server/Dockerfile .
# or
podman build -t xpc-ng-demo-mcp-server:latest -f mcp-server/Dockerfile .

# Restart with new image
docker-compose restart mcp-server
# or
podman-compose restart mcp-server
```

### Backup Configuration

```bash
# Backup .env and config
tar czf mcp-backup-$(date +%Y%m%d).tar.gz .env config/

# Restore from backup
tar xzf mcp-backup-20260827.tar.gz
```

### Clean Up

```bash
# Stop and remove container
docker-compose down

# Remove image
docker rmi xpc-ng-demo-mcp-server:latest

# Or with podman
podman-compose down
podman rmi xpc-ng-demo-mcp-server:latest

# Remove logs and config
rm -rf logs/
rm -rf config/

# Remove .env (credentials)
rm .env
```

---

## Performance Tuning

### Resource Limits

Edit `docker-compose.yml`:

```yaml
deploy:
  resources:
    limits:
      cpus: '2'      # CPU cores
      memory: 512M   # RAM limit
    reservations:
      cpus: '0.5'    # Reserved CPU
      memory: 256M   # Reserved RAM
```

### Restart Policy

```yaml
restart_policy:
  condition: unless-stopped  # Auto-restart
  max_retries: 5             # Retry limit
  delay: 5s                  # Wait between restarts
```

### Logging Configuration

```yaml
logging:
  driver: "json-file"
  options:
    max-size: "10m"    # Rotate at 10MB
    max-file: "3"      # Keep 3 files
```

---

## Security Best Practices

1. **Secrets Management**
   - Never commit .env to git
   - Use git-ignored .env.example as template
   - Rotate credentials periodically

2. **Network Isolation**
   - Bridge network (default) isolates containers
   - Use firewall to limit port 3000 access
   - Require authentication in Terraform/Ansible

3. **Regular Updates**
   - Check for base image updates: `docker pull node:24-slim`
   - Rebuild container monthly
   - Monitor security advisories

4. **Monitoring**
   - Enable health checks
   - Monitor logs for errors
   - Set up alerts for restarts

---

## Advanced: Kubernetes Deployment

For production Kubernetes environments, convert compose to K8s manifests:

```bash
# Install kompose
curl -L https://github.com/kubernetes/kompose/releases/download/v1.26.1/kompose-linux-amd64 -o kompose
chmod +x kompose

# Convert
./kompose convert -f docker-compose.yml -o k8s/

# Deploy
kubectl apply -f k8s/
```

---

## Support & Troubleshooting Resources

- **Documentation:** `ai-coding-tools/docs/02-mcp-architecture.md`
- **Docker Docs:** https://docs.docker.com/
- **Podman Docs:** https://docs.podman.io/
- **Compose Docs:** https://docs.docker.com/compose/
- **Xen Orchestra:** https://xen-orchestra.com/

---

**Last Updated:** 2026-08-27
**Version:** 1.0
