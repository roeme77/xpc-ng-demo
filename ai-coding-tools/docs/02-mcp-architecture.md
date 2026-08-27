# MCP Integration Architecture

**Status:** Phase 2 Complete
**Created:** 2026-08-27

## Overview

This document describes the architecture for integrating the Xen Orchestra MCP server with Terraform and Ansible for infrastructure automation.

## Container Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Host Machine                              │
│                (Docker or Podman)                            │
│                                                               │
│  ┌─────────────────────────────────────────────────────┐    │
│  │          Container Runtime (Docker/Podman)          │    │
│  │                                                       │    │
│  │  ┌───────────────────────────────────────────────┐  │    │
│  │  │   MCP Server Container                        │  │    │
│  │  │                                               │  │    │
│  │  │  ┌─────────────────────────────────────┐    │  │    │
│  │  │  │  Node.js 24 (slim)                 │    │  │    │
│  │  │  │  - npm 24.x                        │    │  │    │
│  │  │  │  - curl (health checks)            │    │  │    │
│  │  │  └─────────────────────────────────────┘    │  │    │
│  │  │                                               │  │    │
│  │  │  ┌─────────────────────────────────────┐    │  │    │
│  │  │  │  Entrypoint Script                 │    │  │    │
│  │  │  │  - Config management               │    │  │    │
│  │  │  │  - Credential validation           │    │  │    │
│  │  │  │  - Health checks                   │    │  │    │
│  │  │  └─────────────────────────────────────┘    │  │    │
│  │  │                                               │  │    │
│  │  │  ┌─────────────────────────────────────┐    │  │    │
│  │  │  │  MCP Server (xen-orchestra)       │    │  │    │
│  │  │  │  - REST API client                 │    │  │    │
│  │  │  │  - XCP-NG queries                  │    │  │    │
│  │  │  │  - Read-only operations            │    │  │    │
│  │  │  └─────────────────────────────────────┘    │  │    │
│  │  │                                               │  │    │
│  │  │  Volumes:                                    │  │    │
│  │  │  - /config (RO): .mcp.json config          │  │    │
│  │  │  - /app/logs (RW): Application logs        │  │    │
│  │  │                                               │  │    │
│  │  │  Port: 3000/tcp (default, configurable)    │  │    │
│  │  │  User: mcp (non-root, UID 1000)            │  │    │
│  │  │  Restart: unless-stopped                   │  │    │
│  │  │                                               │  │    │
│  │  └───────────────────────────────────────────────┘  │    │
│  │                                                       │    │
│  │  Bridge Network: mcp-network                         │    │
│  │  Health Check: curl to /health (30s interval)       │    │
│  │                                                       │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                               │
│  Host Environment:                                          │
│  - .env file (credentials, non-git)                        │
│  - docker-compose.yml (configuration, git-tracked)         │
│  - Dockerfile (build spec, git-tracked)                    │
│                                                               │
└─────────────────────────────────────────────────────────────┘
         │
         ├─── Network ──→ [Xen Orchestra API]
         │                (Credentials via env vars)
         │
         └─── Port 3000 ──→ [Terraform/Ansible clients]
```

## Integration with Infrastructure Automation

```
┌──────────────────────────────────────────────────────────────┐
│              Infrastructure Automation Workflow               │
│                                                                │
│  ┌────────────────┐  ┌────────────────┐  ┌──────────────┐   │
│  │   Terraform    │  │    Ansible     │  │   CI/CD      │   │
│  │   (IaC)        │  │  (Config Mgmt) │  │  (Pipelines) │   │
│  └────────┬────────┘  └────────┬────────┘  └──────┬───────┘   │
│           │                    │                  │             │
│           │ (Write)            │ (Config)         │ (Orchestr.)│
│           │                    │                  │             │
│           └────────┬───────────┴──────────────────┘             │
│                    │                                            │
│           ┌────────▼──────────┐                               │
│           │  MCP Server       │                               │
│           │  (Read-only)      │                               │
│           │                   │                               │
│           │ • Pre-flight      │                               │
│           │   checks          │                               │
│           │ • Audit logs      │                               │
│           │ • Health status   │                               │
│           │ • Compliance      │                               │
│           │   verification    │                               │
│           └────────┬──────────┘                               │
│                    │                                            │
│           ┌────────▼──────────────────┐                       │
│           │ Xen Orchestra API          │                      │
│           │ (XCP-NG Infrastructure)    │                      │
│           └───────────────────────────┘                       │
│                                                                │
└──────────────────────────────────────────────────────────────┘

Key Pattern:
- Terraform: Provisions infrastructure (write operations)
- MCP Server: Validates state, audits changes (read operations)
- Ansible: Configures systems (configuration management)
```

## Multi-Runtime Compatibility

```
┌──────────────────────────────────────────────────────────┐
│  Multi-Runtime Execution (Docker & Podman)               │
│                                                           │
│  ┌────────────────────────────────────────────────────┐  │
│  │ Dockerfile (OCI-compliant)                         │  │
│  │ - node:24-slim base image                          │  │
│  │ - No Docker-specific syntax                        │  │
│  │ - Standard OCI format                              │  │
│  └────────────────────────────────────────────────────┘  │
│           │                   │                            │
│           ├─→ docker build   │                            │
│           │                  └─→ podman build             │
│           │                                               │
│  ┌────────▼──────────────────────────────┐              │
│  │  OCI Image: xpc-ng-demo-mcp-server    │              │
│  │  (Runtime-agnostic)                   │              │
│  └────────┬──────────────────────────────┘              │
│           │                   │                            │
│  ┌────────▼──────────┐  ┌────▼─────────────┐             │
│  │ docker-compose    │  │ podman-compose   │             │
│  │ (same YAML)       │  │ (same YAML)      │             │
│  └────────┬──────────┘  └────┬─────────────┘             │
│           │                  │                            │
│  ┌────────▼──────────────────▼──────────┐               │
│  │ Container Runtime (Docker/Podman)    │               │
│  │ - Bridge networking                  │               │
│  │ - Volume mounts                      │               │
│  │ - Environment variables              │               │
│  │ - Health checks                      │               │
│  │ - Resource limits                    │               │
│  └───────────────────────────────────────┘              │
│                                                           │
└──────────────────────────────────────────────────────────┘

Compatibility Features:
✓ Single Dockerfile (no Docker-specific extensions)
✓ Standard OCI image format
✓ Bridge networking (compatible with both)
✓ No Docker Secrets (uses env vars instead)
✓ No buildkit extensions
✓ Standard volume mount syntax
✓ Compatible compose file format
```

## Deployment Modes

### Production Deployment

```
┌──────────────────────────────────────────┐
│  Production Server                        │
│  (Docker or Podman)                      │
│                                           │
│  ├─ docker-compose.yml (git tracked)    │
│  ├─ .env (secrets, git ignored)         │
│  └─ ./docker run...                     │
│                                           │
│  Environment:                            │
│  - NODE_ENV=production                  │
│  - LOG_LEVEL=info                       │
│  - Resource limits enforced             │
│  - Health checks enabled                │
│  - Restart: unless-stopped              │
└──────────────────────────────────────────┘
```

### Development Deployment

```
┌──────────────────────────────────────────┐
│  Developer Machine                        │
│  (Docker or Podman)                      │
│                                           │
│  ├─ docker-compose.yml (base config)    │
│  ├─ docker-compose.override.yml (local) │
│  ├─ .env.local (dev credentials)        │
│  └─ ./docker-compose up -d              │
│                                           │
│  Environment:                            │
│  - NODE_ENV=development                 │
│  - LOG_LEVEL=debug                      │
│  - Live code reloading (optional)       │
│  - No resource limits (full access)     │
└──────────────────────────────────────────┘
```

## Configuration Flow

```
┌─────────────────────────────────────────────────────────┐
│ Configuration Management                                 │
│                                                           │
│ 1. Default Values (Dockerfile ENV)                       │
│    ↓                                                      │
│ 2. docker-compose.yml Environment                        │
│    ↓                                                      │
│ 3. .env File (user overrides)                           │
│    ↓                                                      │
│ 4. Runtime Arguments (docker run -e)                     │
│    ↓                                                      │
│ 5. Volume Mounts (/config/.mcp.json)                    │
│    ↓                                                      │
│ 6. Final Configuration in Container                      │
│                                                           │
│ Precedence (highest to lowest):                         │
│ Runtime args > .env > docker-compose > Dockerfile > Defaults
│                                                           │
└─────────────────────────────────────────────────────────┘
```

## Security Model

```
┌──────────────────────────────────────────────────────────┐
│ Container Security                                        │
│                                                           │
│ ✓ Non-root user execution (mcp:1000)                    │
│ ✓ Secrets via environment variables (not hardcoded)    │
│ ✓ Read-only config volumes (/config:ro)                │
│ ✓ Resource limits (CPU, memory)                         │
│ ✓ Health checks (auto-restart on failure)              │
│ ✓ Log rotation (json-file max size)                    │
│ ✓ No privileged mode required                          │
│ ✓ Bridge networking (isolated by default)              │
│                                                           │
│ Secrets Management:                                      │
│ 1. .env file (git-ignored, developer machine only)    │
│ 2. Environment variables (injected at runtime)         │
│ 3. Never hardcoded in Dockerfile                       │
│ 4. Container has read-only access to config           │
│                                                           │
└──────────────────────────────────────────────────────────┘
```

## Networking

```
┌──────────────────────────────────────────────────────────┐
│ Container Networking                                      │
│                                                           │
│  mcp-network (bridge, created by docker-compose)        │
│  │                                                        │
│  ├─ mcp-server container (port 3000)                    │
│  │  │                                                    │
│  │  └─→ Outbound: Xen Orchestra API (via HOST network) │
│  │      (Credentials: XO_HOST, XO_USER, XO_PASSWORD)  │
│  │                                                       │
│  └─ Inbound: Terraform/Ansible clients                 │
│     (Connect to localhost:3000)                         │
│                                                           │
│ Host Port Mapping:                                       │
│ 3000:3000 → Container:3000 (MCP Server)                │
│                                                           │
│ Network Mode:                                            │
│ - bridge (default, secure isolation)                   │
│ - host (if needed for API access)                      │
│                                                           │
└──────────────────────────────────────────────────────────┘
```

---

## Summary

- **Container:** OCI-compliant, works with Docker and Podman
- **Compose:** Single docker-compose.yml works with both tools
- **Configuration:** Environment-driven, secrets in .env (git-ignored)
- **Integration:** Read-only MCP for observational use with Terraform/Ansible
- **Security:** Non-root user, resource limits, health checks
- **Portability:** Works on any machine with Docker or Podman

This architecture enables infrastructure automation teams to use MCP for pre-flight validation, audit logging, and compliance checking while Terraform handles provisioning and Ansible handles configuration.
