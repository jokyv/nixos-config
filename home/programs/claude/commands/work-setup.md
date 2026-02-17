---
description: Interactive onboarding and setup workflow for new machines/repos
---

# Work Setup

Interactive setup workflow for initializing development environments.

## Workflow Pattern

**Deterministic checks → Interactive questions → Execute → Verify → Report**

## Phase 1: Environment Detection

First, understand what we're working with:

```bash
# OS and architecture
!`uname -a`

# Check for package managers
!`which nix 2>/dev/null && nix --version || echo "nix: not found"`
!`which uv 2>/dev/null && uv --version || echo "uv: not found"`
!`which npm 2>/dev/null && npm --version || echo "npm: not found"`
!`which cargo 2>/dev/null && cargo --version || echo "cargo: not found"`
!`which go 2>/dev/null && go version || echo "go: not found"`

# Check for essential tools
!`which git 2>/dev/null && git --version || echo "git: not found"`
!`which just 2>/dev/null && just --version || echo "just: not found"`
!`which claude 2>/dev/null && claude --version || echo "claude: not found"`

# Check current directory
!`pwd && ls -la | head -20`
```

## Phase 2: Project Detection

Identify project type and requirements:

```bash
# Find project configuration files
!`find . -maxdepth 2 \( -name "flake.nix" -o -name "flake.lock" -o -name "pyproject.toml" -o -name "package.json" -o -name "Cargo.toml" -o -name "go.mod" -o -name "justfile" -o -name "Makefile" \) 2>/dev/null | head -10`

# Check for CLAUDE.md (existing project conventions)
!`test -f CLAUDE.md && echo "CLAUDE.md: exists" || echo "CLAUDE.md: not found"`

# Check for existing .claude directory
!`test -d .claude && ls -la .claude || echo ".claude: not found"`
```

## Phase 3: Interactive Questions

Based on detected environment, ask the user:

1. **For NixOS/Nix projects:**
   - Should we set up direnv integration?
   - Configure nix-shell or devshell?
   - Install recommended tools via home-manager?

2. **For Python projects:**
   - Create virtual environment or use uv?
   - Install dev dependencies?
   - Set up pre-commit hooks?

3. **For Node projects:**
   - npm, pnpm, or bun?
   - Install dependencies now?
   - Configure linting/formatting?

4. **General:**
   - Copy CLAUDE.md template?
   - Set up git hooks?
   - Create initial justfile/Makefile?

## Phase 4: Execution Steps

Based on user selections, execute setup steps:

### NixOS Setup
```bash
# Example commands (only run if user confirms)
# nix develop
# direnv allow
# home-manager switch --flake .
```

### Python Setup
```bash
# uv sync
# uv run pre-commit install
```

### Node Setup
```bash
# npm install
# npx husky install
```

### Claude Integration Setup
```bash
# Create .claude directory if needed
# Copy CLAUDE.md template
# Set up commands directory
```

## Phase 5: Verification

After setup, verify everything works:

```bash
# Check that tools are available in environment
!`which python 2>/dev/null || which python3 2>/dev/null`
!`which node 2>/dev/null || echo "node: not in path"`

# For Nix projects
!`test -n "$IN_NIX_SHELL" && echo "In nix shell" || echo "Not in nix shell"`

# Check git is configured
!`git config user.name && git config user.email || echo "git: not configured"`
```

## Output Format

Provide a setup report:

```
## Setup Report

**Environment:** [OS, detected tools]
**Project Type:** [Nix/Python/Node/etc.]

### Actions Taken
- [x] [action 1]
- [x] [action 2]
- [ ] [skipped action - reason]

### Verification Results
- [tool]: [version/status]
- [tool]: [version/status]

### Next Steps
1. [recommended action]
2. [recommended action]

### Warnings/Notes
- [any issues encountered]
```

## Common Issues Resolution

| Issue | Resolution |
|-------|------------|
| Nix not found | Install via `sh <(curl -L https://nixos.org/nix/install) --daemon` |
| uv not found | `curl -LsSf https://astral.sh/uv/install.sh | sh` |
| Permission denied | Check file permissions, use nix-shell or sudo appropriately |
| Git not configured | Run `git config --global user.name "..."` and `git config --global user.email "..."` |
| Flake locked | Run `nix flake update` or use `--impure` flag |

## Notes

- Always ask before running destructive or long-running commands
- Provide dry-run options where possible
- Log all actions taken
- Keep backups of replaced files
- Support `--dry-run` flag for preview mode
