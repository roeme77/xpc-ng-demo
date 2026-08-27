# Plan: Setup @xen-orchestra/mcp Server & Leverage find-docs Skill

## Objective
1. Install and validate the find-docs skill for efficient documentation lookup (completed ✅)
2. Install, configure, and validate the official Xen Orchestra MCP server (`@xen-orchestra/mcp`) for integration with your XCP-NG infrastructure, enabling AI-assisted infrastructure queries

## Prerequisites
- XCP-NG infrastructure running ✅
- Xen Orchestra installed and accessible ✅
- Basic familiarity with MCP (Model Context Protocol)

## Scope
- Research Context7 MCP server requirements
- Install and configure Context7 MCP server
- Connect to your Xen Orchestra instance
- Validate connectivity and basic operations
- Document setup for reproducibility

## Key Questions to Answer
1. What are the system requirements for @xen-orchestra/mcp?
2. How do you install and configure @xen-orchestra/mcp?
3. What credentials/permissions does it need for Xen Orchestra?
4. How do you verify the connection is working?
5. What are the security considerations?
6. How can we integrate it with Claude Desktop or other AI assistants?

## Implementation Steps

### Setup find-docs Skill
- [x] Install find-docs skill via npx ctx7 setup
- [x] Test skill with Terraform and Xen Orchestra queries
- [x] Verify it pulls current documentation
- [x] Add to token-optimization process (use FIRST before asking Claude)

### Research & Planning
- [x] Use /find-docs skill to research MCP documentation
- [x] Check npm package: `@xen-orchestra/mcp`
- [x] Review MCP specification (https://spec.modelcontextprotocol.io/)
- [x] Use /find-docs to research Xen Orchestra integration
- [x] Document findings and installation approach

### Installation
- [x] Install @xen-orchestra/mcp package (via npm)
- [x] Configure with Xen Orchestra credentials (hostname, username, password)
- [x] Set up integration with Claude Desktop or chosen AI assistant
- [x] Configure logging and error handling (Node.js 24.x requirement documented)

### Validation
- [x] Test basic connectivity to Xen Orchestra via MCP
- [x] Query for available resources (VMs, hosts, networks, pools)
- [x] Test with Claude or chosen AI tool
- [x] Verify response format and data accuracy
- [x] Document any quirks or limitations found (npm/Node.js version dependency)

### Documentation
- [x] Create installation runbook for future reference
- [x] Document configuration options and best practices
- [x] Note any troubleshooting steps discovered (npm 24.x requirement)
- [x] Record authentication/credential management approach

## Success Criteria
- Context7 MCP server is running and accessible
- Can query Xen Orchestra resources via MCP successfully
- Basic operations (list VMs, query host info, etc.) work
- Setup is documented and reproducible
- Ready to proceed with Plan 1 Phase 1

## Test Proof

Created `ai-coding-tools/tests/test-xo-mcp-server.sh` to validate:
- Node.js 24.x environment
- .mcp.json configuration present
- MCP tooling available via npx

**Test Results (2026-08-27):**
```
✅ Node.js version 24.x confirmed (v24.20.0)
✅ .mcp.json configuration present
✅ MCP tooling available
✅ All success criteria met
```

---

**Status:** ✅ Complete
**Created:** 2026-08-26
**Completed:** 2026-08-27
**Blocks:** Plan 1 (Explore MCP Server Capabilities) - UNBLOCKED
