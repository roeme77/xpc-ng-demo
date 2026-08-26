# Token Optimization Checklist

START_TOKEN = 💰

## Purpose

This process helps you decide **when to use cheaper tools instead of expensive AI tokens**. Before asking Claude for a task, run through this checklist to identify if a non-AI approach could gather or prepare the information more efficiently.

## Pre-Claude Checklist

Before submitting a question or task to Claude, ask yourself:

### 1. Is this asking for external information?
- **Yes** → Use **websearch** first
  - Recent documentation, blog posts, external APIs
  - Current tool versions or features
  - Real-time information not in training data
- **No** → Continue to #2

### 2. Do you need to look up current documentation?
- **Yes** → Use **/find-docs skill** (leverage this FIRST)
  - Query Terraform documentation: `/find-docs Terraform "your question"`
  - Query Ansible documentation: `/find-docs Ansible "your question"`
  - Query XCP-NG/Xen Orchestra: `/find-docs "Xen Orchestra" "your question"`
  - Gets current docs without token cost
  - If skill not available, check local reference documents
- **No** → Continue to #3

### 3. Can a script/command gather the data you need?
- **Yes** → Run the **script/command** first
  - Grep the codebase to find code patterns
  - Run `terraform plan` to see what changes
  - Parse logs or config files for specific data
  - Execute shell commands to audit infrastructure state
  - Generate summaries from existing data
- **No** → Continue to #4

### 4. Is this working in well-understood patterns?
- **Yes** → Use **local context only** (no AI needed)
  - Applying a known code style fix
  - Making changes following established patterns
  - Simple refactoring in familiar code
  - Copy-pasting from documented examples
- **No** → Continue to #5

### 5. Can a DevOps tool validate or check this?
- **Yes** → Run the **tool** first
  - `terraform validate` or `terraform plan` before asking Claude to review configs
  - `ansible-lint` to check playbook syntax and best practices
  - `git log` or `git diff` to understand code history and changes
  - Xen Orchestra API/CLI to query infrastructure state
  - Context7 MCP server to query XCP-NG capabilities
- **No** → Continue to #6

### 6. Does this need architectural reasoning or complex debugging?
- **Yes** → Worth using **expensive AI reasoning**
  - Designing new systems or major features
  - Debugging complex interactions across components
  - Making trade-off decisions between approaches
  - Reviewing and explaining complex code
  - Synthesizing findings from multiple tools
- **No** → Reconsider if a cheaper approach applies

## DevOps-Specific Tools for This Project

| Tool | Use Case |
|------|----------|
| **/find-docs skill** | **Query current documentation for any library (Terraform, Ansible, XCP-NG, etc.) — use this FIRST before asking Claude** |
| **terraform validate** | Check HCL syntax before asking Claude to review |
| **terraform plan** | See what changes will happen before analysis |
| **ansible-lint** | Check Ansible playbook syntax and best practices |
| **git log / git diff** | Understand code history and recent changes |
| **Xen Orchestra API/CLI** | Query infrastructure state directly |
| **@xen-orchestra/mcp Server** | Query infrastructure state instead of asking Claude |
| **YAML validators** | Validate Ansible playbook syntax locally |
| **HCL validators** | Validate Terraform syntax locally |

## Common Scenarios

### Scenario: "How do I use Terraform with XCP-NG?"
- ✅ **Use /find-docs skill:** `/find-docs "Xen Orchestra" "Terraform provider"`
- ✅ Check README references (Xen Orchestra blog series)
- ❌ Don't ask Claude to explain (you have docs via skill)

### Scenario: "Is my Terraform config valid?"
- ✅ Run `terraform validate`
- ✅ Run `terraform plan` to see what changes
- ✅ Use `/find-docs` for syntax questions
- ✅ Ask Claude only if validation fails (provide error output)

### Scenario: "Does my Ansible playbook have issues?"
- ✅ Run `ansible-lint` on the playbook
- ✅ Check YAML syntax locally
- ✅ Use `/find-docs` for Ansible syntax/best practices
- ✅ Ask Claude only if lint finds issues

### Scenario: "What VMs do we have in XCP-NG?"
- ✅ Query Xen Orchestra API/CLI directly
- ✅ Use Context7 MCP server if available
- ❌ Don't ask Claude (query infrastructure directly)

### Scenario: "What capabilities does XCP-NG have?"
- ✅ Use `/find-docs` skill: `/find-docs "Xen Orchestra" "your question"`
- ✅ Use @xen-orchestra/mcp server to query live infrastructure
- ✅ Check XCP-NG official documentation
- ❌ Don't ask Claude first (use skill + MCP tools)

### Scenario: "Why is this deployment failing?"
- ✅ Run the deployment and capture error output
- ✅ Check Terraform/Ansible logs and error messages
- ✅ Ask Claude to analyze the output (provide logs)

### Scenario: "What Ansible roles do we already have?"
- ✅ Grep the ansible/ directory
- ✅ List files with `find`
- ❌ Don't ask Claude (you can do this locally)

### Scenario: "How should we structure secrets?"
- ✅ Check README for existing patterns
- ✅ Websearch for DevOps best practices
- ✅ Ask Claude to synthesize into a design (expensive, but warranted)

### Scenario: "Where is the VM creation code?"
- ✅ Use `grep -r "vm" terraform/`
- ✅ Use `git log` to find recent changes
- ❌ Don't ask Claude to find it

## When to Always Use Claude

Even with this checklist, use Claude for:
- **Synthesis and design** — Combining information into decisions
- **Debugging complex issues** — When multiple factors interact
- **Code review** — Architecture and correctness feedback
- **New feature design** — Before implementation
- **Learning explanations** — Understanding *why*, not just *what*

## Token Cost Rough Guide

| Task | Cost | Better Approach |
|------|------|-----------------|
| "Find files matching X" | Medium | `find` or `grep` |
| "Explain this existing code" | Medium | Read code + local notes |
| "Summarize logs/output" | Low-Medium | Script to extract key info first |
| "Design a new feature" | High | Worth it; use Claude |
| "Why is X failing?" | High | Gather data first, then ask Claude to analyze |
| "What's in my codebase?" | Low | `ls`, `find`, `grep` |
| "What does the docs say?" | Low | Websearch or RAG |

---

**Status:** Active process
**Created:** 2026-08-26
