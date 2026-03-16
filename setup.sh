#!/usr/bin/env zsh

source ./utils.sh

echo "${CYAN}"
echo "  ╔═══════════════════════════════════════╗"
echo "  ║       AI Dev Environment Setup        ║"
echo "  ║   Claude Code + GitHub + AWS MCPs     ║"
echo "  ╚═══════════════════════════════════════╝"
echo "${NC}"

# Check dependencies
step "Checking dependencies"

if ! command -v brew &>/dev/null; then
  errorMessage "Homebrew not installed. Install it at https://brew.sh"
  exit 1
fi
stepComplete "Homebrew"

if ! command -v node &>/dev/null; then
  statement "Installing Node.js"
  brew install node
fi
stepComplete "Node.js $(node --version)"

if ! command -v npm &>/dev/null; then
  errorMessage "npm not found"
  exit 1
fi
stepComplete "npm $(npm --version)"

# Check for GitHub token in keychain
step "Checking credentials"
GITHUB_TOKEN=$(security find-generic-password -a "$USER" -s "github-token" -w 2>/dev/null)
if [[ -z "$GITHUB_TOKEN" ]]; then
  warningMessage "GitHub token not found in keychain"
  echo -n "  Paste your GitHub Personal Access Token: "
  read -s GITHUB_TOKEN
  echo ""
  security add-generic-password -a "$USER" -s "github-token" -w "$GITHUB_TOKEN"
  stepComplete "GitHub token stored in keychain"
else
  stepComplete "GitHub token found in keychain"
fi

# Run setup scripts
./setup-github.sh
./setup-aws.sh
./setup-claude.sh

echo ""
echo "${GREEN}╔═══════════════════════════════════════╗${NC}"
echo "${GREEN}║        Setup Complete! 🎉              ║${NC}"
echo "${GREEN}╚═══════════════════════════════════════╝${NC}"
echo ""
infoMessage "MCP Servers configured:"
statement "GitHub     → npx @modelcontextprotocol/server-github"
statement "AWS        → npx aws-mcp-server"
statement "Filesystem → npx @modelcontextprotocol/server-filesystem"
echo ""
infoMessage "Next steps:"
statement "1. Run: source ~/.zshrc"
statement "2. Run: claude"
statement "3. To bootstrap a new project, copy templates/CLAUDE.md into your repo"
echo ""
warningMessage "Remember to revoke and regenerate your GitHub token if it was ever exposed"
