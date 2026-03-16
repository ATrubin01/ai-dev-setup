#!/usr/bin/env zsh

source "$(dirname "$0")/utils.sh"

step "Bootstrapping AI context for this project"

# Check we're in a project directory
if [[ ! -d ".git" ]]; then
  warningMessage "No .git found — are you in the root of a project repo?"
  if ! ask_yn_question "Continue anyway?"; then
    exit 1
  fi
fi

# Check if CLAUDE.md already exists
if [[ -f "CLAUDE.md" ]]; then
  warningMessage "CLAUDE.md already exists"
  if ! ask_yn_question "Overwrite it?"; then
    exit 0
  fi
fi

stepComplete "Scanning project: $(pwd)"
statement "Claude will analyze your codebase and generate CLAUDE.md automatically"
echo ""

# Run Claude to scan the project and generate CLAUDE.md
claude --print "You are a project bootstrapper. Scan this entire project directory and generate a CLAUDE.md file.

Analyze:
- All config files (package.json, pom.xml, requirements.txt, go.mod, Dockerfile, etc.)
- Infrastructure files (Terraform, CloudFormation, Helm charts, k8s yamls)
- CI/CD workflows (.github/workflows/, .gitlab-ci.yml, etc.)
- README files
- Directory structure

Then generate a complete CLAUDE.md with these sections filled in accurately:
1. Project Overview (what it does, 2-3 sentences)
2. Technology Stack (languages, frameworks, databases, infrastructure, CI/CD)
3. Project Structure (key directories with descriptions)
4. Development Workflow (how to run locally, build, test)
5. Key Patterns & Conventions (naming, branching, PR rules)
6. Environments (dev/staging/prod with AWS profiles if applicable)
7. AWS Resources (if applicable)
8. AI Workflow Instructions (how Claude should help in this specific project)

Write the output directly to CLAUDE.md in the current directory.
Be specific — use actual values from the code, not placeholders." 2>/dev/null

if [[ -f "CLAUDE.md" ]]; then
  stepComplete "CLAUDE.md generated successfully"
  echo ""
  infoMessage "Run 'claude' to start working with full project context"
else
  errorMessage "CLAUDE.md was not created — run 'claude' manually and ask it to generate CLAUDE.md"
fi
