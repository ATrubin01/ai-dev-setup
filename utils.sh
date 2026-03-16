#!/usr/bin/env zsh

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

step() {
  echo "\n${BLUE}==>${NC} $1"
}

stepComplete() {
  echo "${GREEN}✓${NC} $1"
}

stepFailed() {
  echo "${RED}✗${NC} $1"
}

statement() {
  echo "  ${CYAN}→${NC} $1"
}

infoMessage() {
  echo "${CYAN}ℹ${NC} $1"
}

warningMessage() {
  echo "${YELLOW}⚠${NC} $1"
}

errorMessage() {
  echo "${RED}✗ ERROR:${NC} $1"
}

ask_yn_question() {
  echo -n "${YELLOW}?${NC} $1 [y/n]: "
  read answer
  [[ "$answer" == "y" || "$answer" == "Y" ]]
}
