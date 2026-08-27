# Plan 02: Design MCP Integration with Infrastructure Automation

## Objective
Design how the MCP server will integrate with Terraform and Ansible to create a cohesive infrastructure automation workflow, with containerization support for Docker and Podman.

## Scope
- Define MCP server deployment architecture (containerized)
- Design container strategy supporting Docker AND Podman
- Support both docker-compose and podman-compose
- Design integration points with Terraform provider
- Plan integration patterns with Ansible
- Document communication flows
- Plan error handling and resilience patterns

## Key Decisions to Make
1. **Container Strategy** - Support both Docker and Podman, with both compose tools
   - Single Dockerfile compatible with both runtimes
   - Compose files work with `docker-compose` and `podman-compose`
   - No Docker-specific features (no Docker secrets, buildkit extensions)

2. How will the MCP server be deployed? (containerized, standalone option for development)

3. What Terraform resources will the MCP server expose?

4. How will Ansible communicate with the MCP server?

5. What's the failure recovery strategy?

6. How will secrets be managed for MCP server access?

## Container Architecture Design

### Multi-Runtime Compatibility
- **Dockerfile:** Use standard Dockerfile (no Docker-specific syntax)
- **Base Image:** Official node:24 (slim variant for smaller footprint)
- **Compose Files:** 
  - `docker-compose.yml` (works with both tools)
  - `podman-compose.yml` (if needed for podman-specific overrides)
- **Entrypoint:** Shell script handling environment setup
- **Secrets:** Via environment variables or mounted config files (not Docker Secrets)

### Design Considerations
- [ ] Ensure Dockerfile is buildkit-agnostic
- [ ] Test compose files with both docker-compose and podman-compose
- [ ] No privileged mode or special capabilities required
- [ ] Network mode: bridge (compatible with both)
- [ ] Volume mounting strategy for config and credentials
- [ ] Health check implementation
- [ ] Container restart policies

## Architecture Outputs
- [ ] Dockerfile (node:24-slim base, multi-runtime compatible)
- [ ] docker-compose.yml (works with docker-compose and podman-compose)
- [ ] podman-compose.yml (if podman-specific config needed)
- [ ] Container architecture diagram (ASCII)
- [ ] Component interaction diagram (ASCII)
- [ ] Terraform + MCP integration strategy
- [ ] Ansible + MCP integration strategy
- [ ] Error handling and retry patterns
- [ ] Secrets management approach (env vars, mounted files)
- [ ] Deployment runbook (Docker and Podman instructions)

## Success Criteria
- [ ] Dockerfile builds successfully with Docker
- [ ] Dockerfile builds successfully with Podman
- [ ] docker-compose.yml works with docker-compose
- [ ] docker-compose.yml works with podman-compose
- [ ] MCP server runs and serves requests in container
- [ ] Configuration can be mounted or injected via environment
- [ ] Clear architectural decisions documented
- [ ] Integration strategy leverages MCP read-only capabilities
- [ ] Foundation for implementation in Phases 3-5
- [ ] Deployment works on machines with Docker OR Podman (not Docker-dependent)

---

**Status:** Not started
**Created:** 2026-08-26
**Blocks:** Plan 03 (Terraform Infrastructure as Code)
