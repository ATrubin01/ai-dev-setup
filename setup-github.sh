#!/usr/bin/env zsh

source ./utils.sh

step "Setting up GitHub MCP"

# Pull token from keychain
GITHUB_TOKEN=$(security find-generic-password -a "$USER" -s "github-token" -w 2>/dev/null)

if [[ -z "$GITHUB_TOKEN" ]]; then
  errorMessage "GitHub token not found in keychain."
  statement "Run: security add-generic-password -a \"\$USER\" -s \"github-token\" -w \"YOUR_TOKEN\""
  stepFailed "GitHub MCP setup"
  exit 1
fi

stepComplete "GitHub token found in keychain"

# Add to shell profile if not already there
SHELL_PROFILE="$HOME/.zshrc"
if ! grep -q "GITHUB_PERSONAL_ACCESS_TOKEN" "$SHELL_PROFILE"; then
  echo "\n# GitHub MCP" >> "$SHELL_PROFILE"
  echo "export GITHUB_PERSONAL_ACCESS_TOKEN=\$(security find-generic-password -a \"\$USER\" -s \"github-token\" -w 2>/dev/null)" >> "$SHELL_PROFILE"
  stepComplete "Added GitHub token to $SHELL_PROFILE"
else
  stepComplete "GitHub token already in $SHELL_PROFILE"
fi

export GITHUB_PERSONAL_ACCESS_TOKEN="$GITHUB_TOKEN"

stepComplete "GitHub MCP configured"
