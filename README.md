# AI Dev Environment Setup

Automated setup script that configures Claude Code with MCP (Model Context Protocol) servers for GitHub and AWS — enabling AI-assisted development workflows across any project.

Inspired by enterprise AI dev tooling patterns (similar to AWS Kiro + Bedrock setups).

## What It Does

One script sets up a fully connected AI development environment:

- **GitHub MCP** — Claude can read/create issues, PRs, branches, and review code directly from chat
- **AWS MCP** — Claude can query your AWS accounts, describe resources, and assist with infrastructure
- **Filesystem MCP** — Claude can read/write local project files
- **CLAUDE.md template** — Standardized project context file so Claude understands any codebase instantly

## How It Works

```
Developer → Claude Code → MCP Servers → GitHub / AWS / Filesystem
```

MCP (Model Context Protocol) is an open standard by Anthropic that lets AI assistants connect to external tools and data sources. The same protocol is used by AWS Kiro (via Bedrock) and Claude Code (via Anthropic API).

## Quick Start

```bash
git clone https://github.com/alontrubin/ai-dev-setup.git
cd ai-dev-setup
./setup.sh
```

The script will:
1. Check for Homebrew, Node.js, npm
2. Prompt for your GitHub Personal Access Token (stored securely in macOS Keychain)
3. Detect your existing AWS profiles from `~/.aws/config`
4. Configure Claude Code's `~/.claude/settings.json` with all MCP servers
5. Install a global `CLAUDE.md` template

## Prerequisites

- macOS
- [Homebrew](https://brew.sh)
- [Claude Code](https://claude.ai/code)
- GitHub Personal Access Token (`repo`, `read:org`, `read:user` scopes)
- AWS CLI configured (`~/.aws/config`)

## Project Structure

```
ai-dev-setup/
├── setup.sh              # Main entry point
├── setup-claude.sh       # Claude Code + MCP server configuration
├── setup-github.sh       # GitHub token + MCP setup
├── setup-aws.sh          # AWS CLI check + profile detection
├── utils.sh              # Shared helper functions
└── templates/
    └── CLAUDE.md         # Project bootstrap template
```

## Bootstrapping a New Project

Copy the CLAUDE.md template into any repo to give Claude full project context:

```bash
cp ~/.claude/CLAUDE.md ./CLAUDE.md
# Fill in project-specific details
claude  # Claude now understands your entire project
```

## MCP Servers Used

| Server | Package | Purpose |
|--------|---------|---------|
| GitHub | `@modelcontextprotocol/server-github` | PRs, issues, branches |
| AWS | `aws-mcp-server` | AWS resource queries |
| Filesystem | `@modelcontextprotocol/server-filesystem` | Local file access |

## Credentials & Security

- GitHub tokens are stored in **macOS Keychain** via `security` CLI — never hardcoded
- AWS credentials use existing `~/.aws/config` profiles
- No secrets are committed to this repo
