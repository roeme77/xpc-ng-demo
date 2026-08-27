# MCP Server Deployment Runbook

**Quick Reference for deploying containerized MCP server with Docker or Podman**

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
# Start with docker-compose
docker-compose up -d

# Or manually:
docker run -d \
  --name xpc-ng-mcp-server \
  --restart unless-stopped \
  -p 3000:3000 \
  --env-file .env \
  -v $(pwd)/config:/config:ro \
  -v $(pwd)/logs:/app/logs \
  xpc-ng-demo-mcp-server:latest
```

### 5. Verify

```bash
# Check container status
docker-compose ps

# Check logs
docker-compose logs -f mcp-server

# Test health
curl http://localhost:3000/health
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
# Start with podman-compose
podman-compose up -d

# Or manually:
podman run -d \
  --name xpc-ng-mcp-server \
  --restart always \
  -p 3000:3000 \
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

# Check logs
podman-compose logs -f mcp-server
# or
podman logs -f xpc-ng-mcp-server

# Test health
curl http://localhost:3000/health
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

### Health Check

```bash
# Quick health test
curl -v http://localhost:3000/health

# Expected response:
# HTTP/1.1 200 OK
```

### Full Verification Checklist

```bash
# 1. Container running?
docker ps | grep mcp-server
# or
podman ps | grep mcp-server

# 2. Logs clean?
docker logs xpc-ng-mcp-server
# or
podman logs xpc-ng-mcp-server

# 3. Network accessible?
curl http://localhost:3000/health

# 4. Environment variables set?
docker exec xpc-ng-mcp-server env | grep XO_
# or
podman exec xpc-ng-mcp-server env | grep XO_

# 5. Can reach Xen Orchestra?
docker exec xpc-ng-mcp-server ping -c 1 <XO_HOST>
# or
podman exec xpc-ng-mcp-server ping -c 1 <XO_HOST>
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
