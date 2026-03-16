#!/usr/bin/env zsh

source ./utils.sh

step "Setting up Claude Code"

# Install Claude Code if needed
if ! command -v claude &>/dev/null; then
  statement "Installing Claude Code"
  npm install -g @anthropic-ai/claude-code
  stepComplete "Installed Claude Code"
else
  stepComplete "Claude Code already installed"
fi

step "Configuring MCP Servers"

SETTINGS_FILE="$HOME/.claude/settings.json"
mkdir -p "$HOME/.claude"

# Pull GitHub token from keychain
GITHUB_TOKEN=$(security find-generic-password -a "$USER" -s "github-token" -w 2>/dev/null)
if [[ -z "$GITHUB_TOKEN" ]]; then
  warningMessage "GitHub token not found in keychain — GitHub MCP will be skipped"
  warningMessage "Run setup-github.sh first"
fi

# Write Claude Code settings with MCP servers
cat > "$SETTINGS_FILE" << EOF
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "$(security find-generic-password -a "$USER" -s "github-token" -w 2>/dev/null)"
      }
    },
    "aws": {
      "command": "npx",
      "args": ["-y", "aws-mcp-server"],
      "env": {
        "AWS_PROFILE": "default",
        "AWS_REGION": "us-east-1"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "$HOME"]
    }
  }
}
EOF

stepComplete "MCP servers configured"
statement "GitHub MCP    → read/create PRs, issues, branches"
statement "AWS MCP       → query AWS accounts and resources"
statement "Filesystem    → read/write local files"

step "Setting up global CLAUDE.md template"

mkdir -p "$HOME/.claude"
if [[ ! -f "$HOME/.claude/CLAUDE.md" ]]; then
  cp "$(dirname "$0")/templates/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
  stepComplete "Global CLAUDE.md installed at ~/.claude/CLAUDE.md"
else
  warningMessage "~/.claude/CLAUDE.md already exists — skipping"
fi

stepComplete "Claude Code setup complete"
echo ""
infoMessage "Start Claude Code with: claude"
infoMessage "Bootstrap any project with: ai-bootstrap"
