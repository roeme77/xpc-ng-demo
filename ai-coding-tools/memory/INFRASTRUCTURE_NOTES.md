# Infrastructure Notes & Discoveries

**Last Updated:** 2026-08-27

## Hardware & Passthrough Configuration

### LlamaFarm VM - PCI Passthrough
**VM ID:** 904806ef-330b-0f78-276a-89e132234f97

**PCI Device Attached:**
- Device ID: `0000:0b:00.0` (likely GPU/accelerator for ML inference)
- Configuration: `pci: "0/0000:0b:00.0"`

**VM Specifications:**
- Power State: Halted
- OS: Ubuntu 24.04.4 LTS
- CPU: 16 cores
- Memory: 68 GB
- MMIO hole size: 1 GB (typical for GPU passthrough)
- Auto-poweron: Enabled

**Use Case:** Machine learning inference workload (LlamaFarm suggests LLM serving)

---

## GPU Hardware Available

All 4 hosts have physical GPUs (PGPUs):
- **xcp-ng-prod1:** PGPU enabled (system display device)
- **xcp-ng-prod2:** PGPU enabled (system display device)
- **xcp-ng-prod3:** PGPU enabled, vGPU disabled (system display device)
- **xcp-ng-prod4:** PGPU enabled (system display device)

**Current VM GPU Configuration:**
- No other VMs have vGPU or GPU passthrough configured
- LlamaFarm is the only VM using PCI passthrough

---

## Query Patterns - Important Notes

### Checking for PCI Passthrough
**❌ Incomplete:** List operations with `fields: PCIs` don't expose passthrough info
```bash
vms_query(operation="GetVms", fields="name_label,power_state,PCIs")
# Returns minimal/empty PCI data
```

**✅ Correct:** Query individual VMs with `fields: *` to see full config
```bash
vms_query(operation="GetVm", id="vm-id", fields="*")
# Returns: attachedPcis[], other.pci configuration
```

**Key Fields:**
- `attachedPcis` - Array of attached PCI device IDs (e.g., `["0000:0b:00.0"]`)
- `other.pci` - Configuration string (e.g., `"0/0000:0b:00.0"`)

---

## Summary

- ✅ LlamaFarm has direct GPU/accelerator access via PCI passthrough
- ❌ No other VMs configured with hardware passthrough
- ❌ No vGPU support enabled on any host
- 📝 GPUs available but not actively used except for LlamaFarm

When investigating hardware capabilities, always query individual VMs with full field projection.
