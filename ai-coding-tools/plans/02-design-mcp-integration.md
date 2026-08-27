# Plan 02: Design MCP Integration with Infrastructure Automation

**Status:** ✅ Complete
**Created:** 2026-08-26
**Completed:** 2026-08-27

## Objective
Design how the MCP server will integrate with Terraform and Ansible to create a cohesive infrastructure automation workflow, with containerization support for Docker and Podman.

## Scope
- [x] Define MCP server deployment architecture (containerized)
- [x] Design container strategy supporting Docker AND Podman
- [x] Support both docker-compose and podman-compose
- [x] Design integration points with Terraform provider
- [x] Plan integration patterns with Ansible
- [x] Document communication flows
- [x] Plan error handling and resilience patterns

## Key Decisions Made

1. **Container Strategy** ✅
   - Single OCI-compliant Dockerfile (no Docker-specific syntax)
   - Works with both docker-compose and podman-compose
   - Base image: node:24-slim (small footprint, stable)
   - No Docker-specific features (no buildkit, Docker Secrets, etc.)
   - Secrets via environment variables and mounted config files

2. **Deployment** ✅
   - Containerized as primary approach
   - Standalone development option via docker-compose.override.yml
   - Health checks enabled (30s interval)
   - Restart policy: unless-stopped

3. **Integration Pattern** ✅
   - MCP provides read-only observational capabilities
   - Terraform handles infrastructure provisioning (write operations)
   - Ansible handles configuration management
   - MCP used for pre-flight validation and post-deployment audits

4. **Failure Recovery** ✅
   - Health checks trigger automatic container restart
   - Restart policy: unless-stopped
   - Credential validation in entrypoint
   - Graceful error handling

5. **Secrets Management** ✅
   - .env file (git-ignored) for credentials
   - Environment variables injected at runtime
   - Config volumes mounted read-only
   - No secrets hardcoded in Dockerfile

## Deliverables Complete ✅

### Docker Implementation
- [x] `docker/mcp-server/Dockerfile` - Multi-runtime compatible (node:24-slim, non-root user)
- [x] `docker/mcp-server/entrypoint.sh` - Config management, validation, health checks
- [x] `docker/docker-compose.yml` - Works with docker-compose and podman-compose
- [x] `docker/.env.example` - Credentials template (git-ignored pattern)
- [x] `docker/.gitignore` - Protects secrets
- [x] `docker/README.md` - Quick start guide and troubleshooting

### Architecture & Planning
- [x] `ai-coding-tools/docs/02-mcp-architecture.md` - 7 ASCII diagrams:
  - Container architecture diagram
  - Integration workflow diagram
  - Multi-runtime compatibility diagram
  - Deployment modes (production/development)
  - Configuration flow
  - Security model
  - Networking architecture

- [x] `ai-coding-tools/docs/02-deployment-runbook.md` - Complete deployment guide:
  - Docker deployment (6 steps)
  - Podman deployment (6 steps)
  - Verification checklist
  - Troubleshooting guide
  - Maintenance procedures
  - Performance tuning
  - Security best practices

## Implementation Details

### Multi-Runtime Compatibility Features
- ✅ OCI-compliant Dockerfile (node:24-slim base)
- ✅ Standard bridge networking
- ✅ Volume mount syntax compatible with both
- ✅ Environment variable handling (same on both)
- ✅ Health check implementation
- ✅ Restart policies (unless-stopped, always)
- ✅ Resource limits support
- ✅ Logging configuration (json-file)

### Container Features
- ✅ Non-root user execution (mcp:1000, UID 1000)
- ✅ Resource limits: 2 CPU cores, 512MB RAM
- ✅ Health checks: 30s interval, 10s timeout, 3 retries
- ✅ Restart policy: unless-stopped
- ✅ Logging: json-file with rotation (10MB, 3 files)
- ✅ Read-only config volumes (/config:ro)
- ✅ Write-enabled log volumes (/app/logs)

### Security Model
- ✅ No secrets in Dockerfile or git
- ✅ Credentials via .env file (git-ignored)
- ✅ Environment variable injection
- ✅ Resource limits enforced
- ✅ Non-root user execution
- ✅ Health checks (auto-restart on failure)
- ✅ Log rotation (prevents disk fill)
- ✅ Bridge network isolation (secure default)

## Architecture Decisions

### Container Base Image
**Decision:** node:24-slim
**Rationale:**
- Matches system npm 24.x requirement
- Slim variant reduces footprint (180MB vs 1GB)
- Official image, well-maintained
- Good security update cadence

### Networking
**Decision:** Bridge network (default)
**Rationale:**
- Default, most secure option
- Supported by both Docker and Podman
- Isolates container from host network
- Supports host port mapping

### Restart Policy
**Decision:** unless-stopped
**Rationale:**
- Automatic recovery on failure
- Doesn't restart if explicitly stopped
- Good for production deployments
- Standard best practice

### Secrets Management
**Decision:** Environment variables + .env file
**Rationale:**
- Works with both Docker and Podman
- Doesn't require Docker Secrets (Podman limitation)
- Easy to integrate with CI/CD
- Standard 12-factor app pattern

## Integration Pattern

```
Terraform (Write)
    ↓
Provision Infrastructure
    ↓
MCP Server (Read-Only)
    ├─ Pre-flight validation
    ├─ Audit changes
    └─ Compliance verification
    ↓
Ansible (Configure)
    ├─ Install software
    ├─ Configure systems
    └─ Deploy applications
    ↓
MCP Server (Audit)
    └─ Verify deployment state
```

## Success Criteria ✅

- [x] Dockerfile builds successfully with Docker
- [x] Dockerfile builds successfully with Podman
- [x] docker-compose.yml works with docker-compose
- [x] docker-compose.yml works with podman-compose
- [x] MCP server containerized and ready for deployment
- [x] Configuration manageable via environment and volumes
- [x] Clear architectural decisions documented with diagrams
- [x] Integration strategy leverages MCP read-only capabilities
- [x] Complete foundation for Phase 3 (Terraform)
- [x] Fully portable deployment (works on Docker OR Podman)

---

## Next Phase

**Plan 03: Terraform Infrastructure as Code**
- Implement Terraform provider for XCP-NG
- Create VM provisioning configuration
- Integrate with MCP for validation

All prerequisites complete. Ready to proceed with infrastructure provisioning.

