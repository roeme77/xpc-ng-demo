# Project Progress & Session Notes

**Last Updated:** 2026-08-26

## What We've Completed

### Documentation & Planning
- ✅ Created 6 implementation plans (Plan 00-05)
- ✅ Established Rules of Engagement process
- ✅ Created token-optimization checklist
- ✅ Set up .gitignore for macOS and development files
- ✅ Initialized git repository with 4 commits

### Tool Setup
- ✅ **find-docs skill** — Installed and tested for documentation lookup
  - Use `/find-docs <library> "<query>"` instead of asking Claude
  - Primary tool for getting current docs (Terraform, Ansible, Xen Orchestra)
  - Saves tokens and ensures up-to-date information

- ✅ **@xen-orchestra/mcp package** — Installed globally via npm
  - Configured in `.claude/settings.local.json` (not committed to git)
  - Ready to query Xen Orchestra infrastructure

### Git & SSH
- ✅ Configured SSH for multi-account GitHub access
- ✅ Using SSH key for `roeme77` personal account
- ✅ Successfully pushing to remote

## Key Setup Details

### @xen-orchestra/mcp Configuration
Located in `.claude/settings.local.json` (DO NOT COMMIT):
```json
{
  "mcpServers": {
    "xen-orchestra": {
      "command": "xo-mcp",
      "env": {
        "XO_URL": "http://10.0.4.20",
        "XO_USER": "admin@admin.net",
        "XO_PASSWORD": "admin"
      }
    }
  }
}
```

### SSH Multi-Account Setup
- Configured `~/.ssh/config` with `github.com-personal` host alias
- Using personal SSH key for `roeme77` account
- Added `IdentitiesOnly yes` to prevent SSH agent from offering wrong key

## Tools & Workflows Established

### Token Optimization Workflow
1. **Look up documentation** → Use `/find-docs` skill (never ask Claude first)
2. **Validate configs** → `terraform validate`, `ansible-lint`
3. **Query infrastructure** → Use @xen-orchestra/mcp or Xen Orchestra CLI
4. **Check codebase** → `git log`, `grep`, `find`
5. **Expensive AI reasoning** → Only for design, debugging, synthesis

### Development Processes
- **Rules of Engagement** — Self-explanatory code, test-first, ASCII diagrams for architecture
- **Token Optimization** — find-docs FIRST, then validation tools, then ask Claude
- **Refactoring** — TDD-driven, test-first approach (when ready)
- **Benchmarking** — Speed improvement process (for later iterations)

## Current Status: Plan 00

**Phase: Installation & Configuration**
- [x] Research using find-docs skill
- [x] Install @xen-orchestra/mcp package
- [x] Configure with Xen Orchestra credentials
- [ ] Test connectivity (in progress)
- [ ] Validation with basic queries
- [ ] Documentation of setup

## Next Steps

### Immediate (Plan 00 - Finish)
1. Test MCP server connection in Claude Code
2. Run basic queries (list VMs, hosts, pools)
3. Document setup in runbook
4. Commit `.claude/settings.local.json` pattern to CLAUDE.md (without credentials)

### Short Term (Plan 01 - Explore MCP Capabilities)
1. Use find-docs to research XCP-NG capabilities
2. Query @xen-orchestra/mcp server for available resources
3. Document MCP capabilities and limitations
4. Live system testing on XCP-NG infrastructure

### Medium Term (Plans 02-05)
1. Design MCP + Terraform + Ansible integration
2. Build infrastructure-as-code with Terraform
3. Implement VM configuration with Ansible
4. Set up secrets management and application deployment

## Important Notes for Future Sessions

- **Credentials are local-only** — `.claude/settings.local.json` is in .gitignore
- **find-docs is primary tool** — Always use it for documentation before asking Claude
- **SSH setup is personal-account-specific** — Uses `github.com-personal` alias
- **XCP-NG live system available** — Can test against real infrastructure at 10.0.4.20
- **Plans are sequential** — Plan 00 prerequisites Plan 01, etc.

---

## Session Checklist
- [x] Created implementation plans
- [x] Set up token optimization
- [x] Installed and tested find-docs skill
- [x] Installed @xen-orchestra/mcp
- [x] Configured SSH multi-account access
- [x] Set up git repo and pushed successfully
- [ ] Test MCP server connection
- [ ] Complete Plan 00 validation
