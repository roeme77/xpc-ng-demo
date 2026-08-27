This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

`xpc-ng-demo` is a demonstration and learning project for **XCP-ng** (XenServer-compatible hypervisor) infrastructure management. The project uses the **Xen Orchestra MCP Server** to interact with and query XCP-ng infrastructure.

**Status:** Active. XO MCP server is fully operational and connected to live infrastructure.

## Common Development Tasks

### Infrastructure Queries
Query the live XCP-ng infrastructure using the XO MCP server:
```bash
# Check connection (via Claude Code)
# The XO MCP server provides queries for: hosts, VMs, storage, backups, networks, etc.
```

### Useful Queries
- **Get infrastructure summary:** Pools, hosts, VMs count
- **Query hosts:** Memory, CPU, power state
- **Query VMs:** Status, backups, configuration
- **Query storage:** Available disk space, repositories
- **Backup jobs:** Status and logs

### Build
<!-- Add build command once project structure is established -->

### Tests
<!-- Add test command and instructions for running specific tests -->

### Lint / Format
<!-- Add linting and formatting commands if applicable -->

### Run the Project
<!-- Add instructions for running the project locally -->

## Architecture

### Infrastructure Stack
- **Hypervisor:** XCP-ng 8.3.0 (Xen-based)
- **Management:** Xen Orchestra
- **MCP Server:** XO MCP server for Claude integration
- **Access:** Via REST API through Xen Orchestra

### Key Infrastructure
**Pool:** xcp-ng-prod

**Hosts (4 total):**
- xcp-ng-prod1 (Halted, 4-core Intel Celeron, 8 GB RAM)
- xcp-ng-prod2 (Running, 4-core Intel Celeron, 8 GB RAM, 2.2 GB free)
- xcp-ng-prod3 (Halted, 32-core Intel Xeon, 137 GB RAM)
- xcp-ng-prod4 (Halted, 8-core Intel Xeon, 68 GB RAM)

**Storage Repositories:**
- Local storage (prod3): 3.9 TB total, 3.4 TB free
- Local storage (prod2): 455 GB total, 198 GB free
- RAID storage (prod4): 11.9 TB total, 9.8 TB free
- ISO10G (NFS): 8.4 TB total, 8.3 TB free

**VMs:** 20 total (1 running: cd53b653-4256-90ec-f163-f93c185305e5, 19 halted)

### Key Components
- **XO MCP Server:** Provides queries for infrastructure state, hosts, VMs, storage, backups, and network configuration
- **REST API Integration:** Xen Orchestra exposes REST API for infrastructure management
- **Live Infrastructure Monitoring:** Real-time access to host and VM status, resource utilization

## Important Notes for Future Development

- Update this file as the project structure solidifies, especially in the "Common Development Tasks" and "Architecture" sections
- When adding major features or architectural patterns, document them here to help future instances work more efficiently
- Include any project-specific conventions or gotchas that aren't obvious from the code

## XO MCP Server Setup

The XO (Xen Orchestra) MCP server is configured and working. It requires npm 24.x (not 26.x) for proper operation.

**Available Operations:**
- Hosts, VMs, storage queries
- Backup job management and logs
- Network and pool configuration
- Alarms and message querying
- Task monitoring

Refer to token-optimization-checklist.md for when to use the XO MCP server vs. asking Claude for infrastructure analysis.

---

## Interacting with Me
I am navigating this code base as learner, to help me understand how the code, tools, scripts implemented and what makes it special.
Anytime you are answering a question about the implementation of it, please include reference points for comparing that implementation choice to one or two other alternative ways.

**Last Updated:** 2026-08-27 (XO MCP server verified, infrastructure documented)
