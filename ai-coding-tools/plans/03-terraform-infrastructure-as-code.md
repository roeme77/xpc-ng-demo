# Plan: Build Terraform Infrastructure as Code

## Objective
Implement Terraform modules and configurations to programmatically define and deploy virtualized infrastructure on XCP-NG via Xen Orchestra.

## Scope
- Set up Terraform project structure
- Create provider configuration for Xen Orchestra
- Build reusable modules for common infrastructure patterns
- Implement variable management
- Document resource outputs
- Create example configurations

## Modules to Build
- [ ] VPC/Network module
- [ ] VM template module
- [ ] Compute instance module
- [ ] Storage volume module
- [ ] Security group/firewall rules module

## Configuration Files
- [ ] `providers.tf` — Xen Orchestra provider setup
- [ ] `variables.tf` — Input variables and defaults
- [ ] `main.tf` — Core infrastructure definitions
- [ ] `outputs.tf` — Resource outputs
- [ ] Environment-specific `.tfvars` files

## Testing & Validation
- [ ] Terraform plan output review
- [ ] Test infrastructure deployment
- [ ] Validate resource creation in Xen Orchestra
- [ ] Document troubleshooting steps

## Success Criteria
- Terraform can provision VMs on XCP-NG
- Modules are reusable across environments
- Variables are properly managed
- Documentation covers common operations (apply, destroy, state management)

---

**Status:** Not started
**Created:** 2026-08-26
