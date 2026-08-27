# MCP Server Capabilities & Integration Patterns

**Status:** ✅ Phase 1 Complete
**Last Updated:** 2026-08-27

## Overview

The Xen Orchestra MCP server provides **comprehensive read-only access** to XCP-NG infrastructure. It excels at infrastructure discovery, resource metrics, historical auditing, and health diagnostics.

**Key Finding:** The MCP server is a **purely observational tool** (no write operations exposed). It's production-ready for monitoring, auditing, and intelligence gathering but requires external systems for operational changes.

## Table of Contents

1. [Available Operations](#available-operations)
2. [Authentication & Authorization](#authentication--authorization)
3. [Performance Characteristics](#performance-characteristics)
4. [Practical Examples](#practical-examples)
5. [Limitations & Constraints](#limitations--constraints)
6. [Best Practices](#best-practices)
7. [Troubleshooting](#troubleshooting)

---

## Available Operations

The XO MCP server provides 30+ resource types with standardized query patterns across:

### Infrastructure Resources
- **Pools:** GetPools, GetPool, GetPoolDashboard, GetPoolAlarms, GetPoolMessages, GetPoolTasks, GetPoolMissingPatches
- **Hosts:** GetHosts, GetHost, GetHostAlarms, GetHostMessages, GetHostTasks, GetMissingPatches, GethostSmt
- **Networks:** GetNetworks, GetNetwork, GetNetworkAlarms, GetNetworkMessages, GetNetworkTasks
- **Storage:** GetSrs, GetSr, GetSrAlarms, GetSrMessages, GetSrTasks

### VM & Compute
- **VMs:** GetVms, GetVm, GetVmAlarms, GetVmMessages, GetVmTasks, GetVmVdis, GetVmDashboard, VmGetVmBackupJobs
- **Templates:** GetVmTemplates, GetVmTemplate, GetVmTemplateAlarms, GetVmTemplateVdis, GetVmTemplateMessages, GetVmTemplateTasks
- **Snapshots:** GetVmSnapshots, GetVmSnapshot, GetVmSnapshotAlarms, GetVmSnapshotVdis, GetVmSnapshotsMessages, GetVmSnapshotTasks
- **Block Devices:** GetVbds, GetVbd, GetVbdAlarms, GetVbdMessages, GetVbdTasks
- **Interfaces:** GetVifs, GetVif, GetVifAlarms, GetVifMessages, GetVifTasks

### Storage & Disks
- **Virtual Disks:** GetVdis, GetVdi, GetVdiAlarms, GetVdiMessages, GetVdiTasks
- **VDI Snapshots:** GetVdiSnapshots, GetVdiSnapshot, GetVdiSnapshotAlarms, GetVdiSnapshotMessages, GetVdiSnapshotTasks

### Backup & Recovery
- **Backup Jobs:** GetBackupJobs, GetBackupJob
- **Backup Logs:** GetBackupLogs, GetBackupLog
- **Repositories:** GetRepositories, GetRepository, GetBackupRepositoryHealth
- **Archives:** GetBackupArchives, GetBackupArchive
- **Restore Logs:** GetRestoreLogs, GetRestoreLog

### Admin & Security
- **Users:** GetUsers, GetUser, GetUserGroups, GetUserTasks, GetUserPrivileges, GetAuthenticationTokens
- **Groups:** GetGroups, GetGroup, GetGroupUsers, GetGroupTasks, GetGroupAclRoles
- **Roles:** GetAclV2Roles, GetAclV2Role, GetAclV2RolePrivileges, GetAclRoleUsers, GetAclRoleGroups
- **Privileges:** GetAclV2Privileges, GetAclV2Privilege

### Monitoring & Operational
- **Messages:** GetMessages, GetMessage
- **Alarms:** GetAlarms, GetAlarm
- **Tasks:** GetTasks, GetTask
- **Schedules:** GetSchedules, GetSchedule
- **Servers:** GetServers, GetServer, GetServerTasks
- **Hardware:** GetPcis, GetPci, GetPgpus, GetPgpu, GetPbds, GetPbd, GetPifs, GetPif

### System
- **Dashboard:** GetDashboard
- **GUI Routes:** GetGuiRoutes
- **Events:** OpenSseConnection (SSE streaming)
- **Ping:** Ping

### Query Patterns

**List Operations (GetX)**
- Returns data as markdown tables or JSON
- Supports `limit` parameter (pagination, tested up to 3000)
- Supports `fields` parameter (selective field projection)
- Supports `filter` parameter (XO filter expressions, e.g., `power_state:Running`)

**Single Item Operations (GetX with id)**
- Returns complete JSON object with all available fields
- Includes nested objects and arrays
- Includes internal references ($pool, $container, _xapiRef)
- Includes metadata (blockOperations, currentOperations, timestamps)

**Related Resource Operations (GetX[RelatedResource])**
- GetVmAlarms, GetVmMessages, GetVmTasks, GetVmVdis
- GetHostMessages, GetHostTasks, GetMissingPatches
- GetPoolDashboard (aggregated metrics)
- GetBackupRepositoryHealth (connectivity check)

---

## Authentication & Authorization

**Credential Handling:**
- Connection pre-authenticated via MCP server configuration
- No explicit auth headers or API keys in queries
- Server enforces role-based access control (RBAC)
- User context automatically applied

**Role-Based Access:**
- 8 built-in role templates: Administrator, VMs administrator, VMs creator, VMs power state manager, VMs read-only, Storage administrator, Network administrator, Read only
- Resource-based privileges: (resource, action) pairs
- Resources: vm, host, pool, network, sr, user, group, pci, vgpu, vbd, vif, etc.
- Actions: read, write, create, delete, and wildcard '*'

---

## Performance Characteristics

**Response Patterns:**
- List operations with limit: Fast (< 1s typical)
- Single item queries: Complete JSON with 50+ fields
- Complex queries (GetPoolDashboard): Returns nested hierarchies with 25+ items
- No apparent rate limiting observed
- Can query multiple resource types in parallel

**Data Structure Notes:**
- List operations default to markdown tables
- Single item queries return complete JSON with deeply nested structures
- GetVmMessages: 50+ historical messages per VM
- GetPoolDashboard: 25+ patches listed
- No timeout issues on complex queries

---

## Practical Examples

### Finding Running VMs
```bash
# Query only running VMs
vms_query(operation="GetVms", filter="power_state:Running")
# Returns: 1 running VM (cd53b653-4256-90ec-f163-f93c185305e5)
```

### VM Resource Inspection
```bash
vms_query(operation="GetVm", id="cd53b653-4256-90ec-f163-f93c185305e5")
# Returns:
# - CPUs: {max: 2, number: 2}
# - Memory: {static: [536MB-4GB], size: 4GB}
# - Power state: Running
# - Network addresses: 3 IPv4 addresses
# - OS: Ubuntu 22.04.5 LTS
```

### Pool-Wide Metrics
```bash
pools_query(operation="GetPoolDashboard", id="xcp-ng-prod")
# Returns:
# - Hosts: 1 running, 3 halted (total 4)
# - VMs: 1 running, 19 halted
# - CPU provisioning: 48 cores total, 2 assigned (4.17%)
# - Top resource usage by VM and host
# - Missing patches
```

### Backup Status
```bash
vms_query(operation="GetVmDashboard", id="vm-id")
# Returns:
# - lastRuns: [{backupJobId, timestamp, status}]
# - vmProtection: "protected"
# - backupArchives: [{id, timestamp, size}]
```

### Host Patch Management
```bash
hosts_query(operation="GetMissingPatches", id="host-id")
# Returns: [{url, version, name, license, changelog, release, size}...]
```

### Task Tracking
```bash
tasks_query(operation="GetTasks", limit=3)
# Returns: [{status, id, method, params, name, userId, type}]
```

### Repository Health Check
```bash
backup_repositories_query(operation="GetBackupRepositoryHealth", id="repo-id")
# Pings repository to verify connectivity
```

---

## Limitations & Constraints

### Read-Only Access
- All operations are **read-only queries**
- No write, delete, create, or action operations exposed
- Actions like vm.start, vm.stop appear in task logs but aren't directly callable

### No Write Operations
- ❌ CreateVM, CreateNetwork, CreatePool
- ❌ UpdateVM, SetVMMemory, etc.
- ❌ DeleteVM, DeleteNetwork
- ❌ StartVM, StopVM, RebootVM
- ❌ CreateBackup, ModifySchedule

### Data Availability Quirks
- EmptyResults return "No results." (not empty array)
- Certain queries return empty sets (GetAlarms, GetRestoreLogs, GetProxies, GetGroups)
- Deprecated operations available (GetDeprecatedBackupLogs, GetDeprecatedRestoreLogs)

### Field & Filter Constraints
- Field selection uses dot notation (e.g., CPUs.number)
- Not all nested fields may be selectable
- Filters use XO expression syntax; not all fields may be filterable
- Blocking operations: Some VMs have blockedOperations set (e.g., shutdown, destroy)

---

## Best Practices

1. **Use `fields` parameter to reduce data transfer** - Request only needed fields
2. **Use `filter` for targeted queries** - `power_state:Running` returns relevant subset
3. **Use `limit` for pagination** - Prevents large result sets from overwhelming
4. **Cache frequently accessed data** - Pool/host inventory doesn't change rapidly
5. **Use GetPoolDashboard for aggregates** - More efficient than querying individual resources
6. **Monitor GetMissingPatches regularly** - Keep infrastructure patched
7. **Track GetTasks for operational audit trail** - Understand what happened and when
8. **Check GetBackupRepositoryHealth proactively** - Catch connectivity issues early
9. **Query related resources together** - GetVmDashboard is more efficient than separate queries

---

## Troubleshooting

**No results from filter?**
- Verify filter syntax (space-sensitive, e.g., `power_state:Running` not `power_state: Running`)
- Check if field name is correct
- Try GetX without filter to see available values

**Missing expected fields?**
- Use `fields: *` to get all fields
- Check field availability (some are computed, not stored)
- Nested fields use dot notation

**Empty results for expected data?**
- Some datasets legitimately empty (GetAlarms if no alarms active)
- Check permissions (RBAC may restrict visibility)
- Verify resource exists

**Permission denied errors?**
- Verify user role has read privilege for resource type
- Check GetAclV2RolePrivileges for role capabilities
- May need different credentials

---

## Capability Matrix Summary

| Category | Capability | Status | Use Case |
|----------|-----------|--------|----------|
| Infrastructure Discovery | Query pools, hosts, networks, storage | ✅ Full | Inventory, auditing |
| VM Information | List, inspect, view related items | ✅ Full | Resource management, diagnostics |
| Storage Management | Query VDIs, snapshots, repositories | ✅ Full | Capacity planning, snapshots |
| Backup Monitoring | Query jobs, logs, archives, health | ✅ Full | Compliance, disaster recovery |
| Admin/Security | Query users, groups, roles, privileges | ✅ Full | RBAC auditing, compliance |
| Monitoring | View messages, alarms, tasks | ✅ Full | Audit trails, event tracking |
| Diagnostics | Missing patches, SMT status, health checks | ✅ Full | Maintenance, updates |
| VM Control | Start, stop, reboot, migrate | ❌ Not available | *Use Terraform/Ansible instead* |
| Backup Control | Create, modify, delete jobs | ❌ Not available | *Use Terraform/Ansible instead* |
| Resource Creation | Create VMs, networks, storage | ❌ Not available | *Use Terraform/Ansible instead* |

---

## Conclusion

The XO MCP server is **production-ready for observational/auditing use cases** but requires external systems (Terraform, Ansible, Xen Orchestra REST API) for operational changes.

**Best suited for:**
- Infrastructure monitoring and dashboards
- Compliance and audit logging
- Capacity planning and resource analysis
- Pre-flight checks before Terraform/Ansible operations

**Limitations requiring external tools:**
- VM/infrastructure automation → Use Terraform
- Configuration management → Use Ansible
- Operational changes → Use Xen Orchestra REST API directly

---

**Next Phase:** Use these insights for Plan 02 (Design MCP Integration) and Plan 03 (Terraform Infrastructure as Code).
