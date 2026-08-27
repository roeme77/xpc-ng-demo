# Plan 01: Explore MCP Server Capabilities

## Objective
Understand what the MCP (Model Context Protocol) server for XCP-NG can offer in terms of API integration, automation capabilities, and integration patterns with Xen Orchestra.

## Scope
- Use @xen-orchestra/mcp server to query XCP-NG capabilities
- Research the @xen-orchestra/mcp server and its capabilities
- Document available endpoints and operations
- Identify efficient API communication patterns
- Test MCP server interactions with Xen Orchestra
- Map out what infrastructure operations can be automated via MCP
- Use Context7 (reference documentation tool) to supplement learning

## Phase 1: Research XCP-NG Capabilities via MCP Server ✅

- [x] Query @xen-orchestra/mcp server for available resources (VMs, networks, storage, hosts)
- [x] Use Context7 or reference docs to understand XCP-NG operational capabilities
- [x] Research what operations the MCP server exposes (list, query, filter)
- [x] Identify read-only vs. action capabilities
- [x] Research performance and scalability characteristics
- [x] Identify limitations and constraints
- [x] Document best practices from MCP perspective
- [x] Gather examples of common queries and workflows

**Phase 1 Findings:**
- MCP server provides 30+ resource types with standardized query patterns
- All operations are **read-only** (no write/delete/create)
- Full coverage: VMs, hosts, networks, storage, backups, users, tasks, alarms
- Query patterns: GetX (list), GetX with id (single item), GetXRelated (filtered queries)
- Supports filtering, field projection, pagination
- RBAC enforced at query level
- Response times < 1s for typical queries
- Complete documentation in `ai-coding-tools/docs/01-mcp-server-capabilities.md`

## Phase 2: Live System Testing

- [x] List and query existing VMs and resources
- [x] Query network and storage information
- [x] Test authentication/credential handling
- [x] Measure response times for common operations
- [x] Test error scenarios and edge cases
- [x] Document any quirks or unexpected behaviors

**Phase 2 Findings:**
- Tested on live infrastructure: 4 hosts, 20 VMs, multiple storage repositories
- Filter syntax validated (e.g., `power_state:Running`)
- Field projection works (dot notation for nested fields)
- Pagination tested (limit parameter functional)
- No rate limiting observed
- RBAC constraints confirmed (certain operations blocked by VM state)

## Key Questions Answered

1. **What XCP-NG operations are exposed?** 
   - 30+ resource types: infrastructure, VMs, storage, backups, admin, monitoring
   - All read-only; no operational controls (start/stop/create/delete)

2. **How does MCP handle authentication?**
   - Pre-authenticated via server config
   - RBAC enforced per query
   - 8 built-in role templates available

3. **Performance characteristics?**
   - List queries: < 1s typical
   - Single item: complete JSON with 50+ fields
   - Complex queries: nested hierarchies (25+ items)
   - No timeouts observed

4. **What limitations exist?**
   - Read-only only (no write operations)
   - Field/filter syntax constraints
   - Some queries return empty (empty alarms, no active tasks)

5. **How to optimize MCP requests?**
   - Use `fields` parameter to reduce data transfer
   - Use `filter` to target specific subsets
   - Use `limit` for pagination
   - Cache static data (pool/host inventory)
   - Use dashboard operations for aggregates

## Deliverables ✅

- [x] MCP server capability documentation (`ai-coding-tools/docs/01-mcp-server-capabilities.md`)
- [x] API communication patterns documentation (section in docs)
- [x] Performance/optimization findings (documented)
- [x] List of feasible automation operations (30+ listed)
- [x] Live system test results and observations (from 4-host, 20-VM environment)
- [x] Practical examples and sample commands (8+ examples with actual results)
- [x] Troubleshooting guide (included in docs)

## Key Insights

**What MCP CAN Do:**
- ✅ Infrastructure discovery & inventory
- ✅ Resource metrics & usage analysis
- ✅ Historical audit trails (messages, tasks, backups)
- ✅ RBAC configuration inspection
- ✅ Health diagnostics & patch management
- ✅ Compliance auditing
- ✅ Capacity planning

**What MCP CANNOT Do:**
- ❌ VM lifecycle control (start/stop/reboot)
- ❌ Resource creation (create VM/network/storage)
- ❌ Configuration changes (memory, CPU, disk)
- ❌ Backup job management
- ❌ Destructive operations (delete)

**Integration Strategy:**
- Use MCP for **observational/auditing** use cases
- Use **Terraform** for infrastructure provisioning and IaC
- Use **Ansible** for configuration management
- Use **Xen Orchestra REST API** directly for operational changes

## Success Criteria ✅

- [x] Clear understanding of what can and cannot be automated via MCP
- [x] Documented patterns for efficient MCP usage
- [x] Foundation for Terraform/Ansible integration planning

---

**Status:** ✅ Complete
**Created:** 2026-08-26
**Completed:** 2026-08-27
**Blocks:** Plan 02 (Design MCP Integration) - UNBLOCKED
