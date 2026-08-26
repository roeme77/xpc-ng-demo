# XCP-NG DevOps Demo

A hands-on learning project for infrastructure automation using XCP-NG, Xen Orchestra, Terraform, Ansible, and MCP servers.

> **Status: Work in Progress**
>
> This repository demonstrates practical approaches to infrastructure as code and DevOps automation using open-source tools. It serves as a learning guide for building self-service, automated infrastructure without enterprise tools.

## Project Goals

- **🔌 MCP Integration** — Learn how to integrate MCP (Model Context Protocol) servers with Xen Orchestra for enhanced automation and AI-assisted infrastructure management.

- **🏗️ Infrastructure as Code** — Master Terraform and Ansible to define, deploy, and manage virtualized infrastructure programmatically.

- **⚡ Automated VM Provisioning** — Build a system to spin up VMs from templates, install and configure tools, and maintain them over time.

- **🔐 Secrets Management** — Implement secure secret storage and management patterns suitable for small infrastructure without enterprise solutions.

- **🤖 AI-Assisted Development** — Learn to leverage AI tools and skills in your workflow, including Claude Code, GitHub Copilot, and Codex for accelerated development and infrastructure automation.

## Learning Path

This project progresses through several interconnected topics. Start with foundational concepts and build toward a complete automated system:

### 1. MCP & Xen Orchestra

Understand how MCP servers extend Xen Orchestra's capabilities and enable AI-assisted infrastructure management. This section includes testing and optimizing the Context7 MCP server for efficient API integration.

- [MCP meets Xen Orchestra](https://xen-orchestra.com/blog/mcp-meets-xen-orchestra/)

**@xen-orchestra/mcp Server Setup:**
- Learn how to set up and configure the official Xen Orchestra MCP server
- Test efficient API communication patterns with Xen Orchestra APIs
- Integrate with AI assistants (Claude Desktop, etc.)
- Debug and monitor MCP server interactions in real-time
- Use Context7 (reference documentation tool) for efficient knowledge access

### 2. Infrastructure as Code Fundamentals

Learn DevOps principles and tools in the XCP-NG ecosystem:

- [Introduction to DevOps with XCP-NG](https://xen-orchestra.com/blog/virtops0-intro-on-devops/)
- [Using the Xen Orchestra Terraform Provider](https://xen-orchestra.com/blog/virtops1-xen-orchestra-terraform-provider/)
- [Managing Existing Infrastructure with Terraform](https://xen-orchestra.com/blog/managing-existing-infrastructure-with-terraform-2/)
- [Ansible with Xen Orchestra](https://xen-orchestra.com/blog/virtops3-ansible-with-xen-orchestra/)
- [Tracking Changes in Your Infrastructure](https://xen-orchestra.com/blog/virtops-4-track-any-change-in-your-virtualized-infrastructure/)

### 3. VM Provisioning & Configuration

Automate VM creation, software installation, and system configuration using Terraform and Ansible playbooks.

### 4. Application Deployment

Deploy self-made and third-party applications using Docker Compose, pulling code directly from GitHub.

### 5. Secrets & Security

Implement practical secrets management without enterprise tools (HashiCorp Vault, etc.). Topics include environment variables, local encryption, and CI/CD integration patterns.

### 6. AI-Assisted Development

Explore how modern AI tools can accelerate infrastructure automation and code development:

- **Claude Code** — Use Claude Code as an integrated development environment with AI assistance for writing Terraform, Ansible, and custom automation scripts.
- **GitHub Copilot** — Leverage Copilot for code completion and suggestions in your IaC configurations and tooling.
- **Codex & Model Context Protocol** — Understand how to integrate AI models via MCP servers and use them for intelligent infrastructure decisions and code generation.
- **AI Skills & Custom Workflows** — Create reusable AI-powered skills for common DevOps tasks within your chosen tooling.

## Directory Structure

As the project develops, expect the following structure:

```
xpc-ng-demo/
├── README.md                    # Project documentation
├── CLAUDE.md                    # Claude Code guidance
├── terraform/                   # Infrastructure as Code
│   ├── providers.tf
│   ├── variables.tf
│   ├── main.tf
│   └── outputs.tf
├── ansible/                     # Configuration management
│   ├── playbooks/
│   ├── roles/
│   └── inventory.yml
├── mcp-server/                  # MCP server integration
│   ├── src/
│   └── README.md
├── scripts/                     # Utility scripts
├── docs/                        # Additional documentation
└── .github/                     # CI/CD workflows
```

## Quick Start

Prerequisites:

- XCP-NG infrastructure running
- Xen Orchestra installed and accessible
- [Terraform](https://www.terraform.io/downloads) (latest version)
- [Ansible](https://www.ansible.com/get-started) (2.10+)
- Git and basic command-line familiarity

More details coming as the project develops. For now, review the learning resources above.

## Resources

Key references for learning and development:

- **[Xen Orchestra](https://xen-orchestra.com/)** — Web-based management interface for XCP-NG with API and Terraform support.
- **[Terraform Documentation](https://docs.terraform.io/language)** — Complete reference for Terraform configuration language and modules.
- **[Ansible Documentation](https://docs.ansible.com/ansible/latest/)** — Guides for playbooks, roles, modules, and best practices.
- **[MCP Specification](https://spec.modelcontextprotocol.io/)** — Technical specification for Model Context Protocol servers and clients.
- **[XCP-NG Project](https://xcp-ng.org/)** — Official XCP-NG documentation and community resources.

## Secrets Management

This project avoids expensive enterprise tools while maintaining security. Planned approaches:

- **Environment Variables** — For development and local testing
- **Ansible Vault** — Encrypt sensitive data within playbooks
- **Terraform Variables** — Use `*.tfvars` files (git-ignored) for credentials
- **GitHub Secrets** — For CI/CD pipelines (if using GitHub Actions)
- **Local Encryption** — GPG-based encryption for shared secrets in safe storage

---

**Status:** This repository is in early development. Content and structure will evolve as the project progresses. Contributions and feedback are welcome.
