#!/usr/bin/env zsh

source ./utils.sh

step "Setting up AWS MCP"

# Check AWS CLI
if ! command -v aws &>/dev/null; then
  statement "Installing AWS CLI"
  brew install awscli
  stepComplete "Installed AWS CLI"
else
  stepComplete "AWS CLI already installed"
fi

# Check for existing config
if [[ -f "$HOME/.aws/config" ]]; then
  stepComplete "AWS config found"
  statement "Profiles detected:"
  grep '^\[' ~/.aws/config | sed 's/\[//;s/\]//' | while read profile; do
    echo "    - $profile"
  done
else
  warningMessage "No ~/.aws/config found. Set up AWS SSO or credentials first."
  warningMessage "Run: aws configure"
fi

stepComplete "AWS MCP configured"
