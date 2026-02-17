---
description: Load dynamic context about current codebase and prepare for work
---

# Prime Context

Quickly understand the current codebase state before starting work.

## Workflow

1. **Detect project type** - Check for package managers, config files, frameworks
2. **Scan structure** - List key directories and their purposes
3. **Read key files** - CLAUDE.md, README, package.json/pyproject.toml, etc.
4. **Check git state** - Branch, recent commits, uncommitted changes
5. **Report summary** - Concise overview of what this project is and current state

## Commands to Run

```bash
# Project detection
!`ls -la | head -20`

# Find config files
!`find . -maxdepth 2 -name "*.json" -o -name "*.toml" -o -name "*.yaml" -o -name "*.yml" -o -name "Makefile" -o -name "justfile" 2>/dev/null | grep -v node_modules | head -15`

# Directory structure
!`find . -maxdepth 2 -type d ! -path "*/\.*" ! -path "*/node_modules/*" ! -path "*/__pycache__/*" 2>/dev/null | head -20`

# Git status
!`git branch --show-current 2>/dev/null && git status --short 2>/dev/null | head -15`

# Recent commits
!`git log --oneline -5 2>/dev/null`
```

## Output Format

Provide a structured summary:

```
## Project: [name/type]

**Stack:** [languages, frameworks, tools detected]

**Structure:**
- [key directories and what they contain]

**Current State:**
- Branch: [current branch]
- Uncommitted: [count] files
- Recent: [last commit message]

**Key Files:**
- [important files found and their purpose]

**Ready for:** [suggested next actions based on state]
```

## Notes

- Keep output concise - this is for quick context loading
- Skip verbose explanations - user can ask for details
- Focus on actionable information
- If CLAUDE.md exists, note it but don't repeat everything
