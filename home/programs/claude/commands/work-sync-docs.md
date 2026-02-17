---
description: Sync documentation - update CLAUDE.md and docs/ from codebase changes
allowed-tools: Bash(git diff:*), Bash(git log:*), Bash(git status:*), Bash(find:*), Bash(grep:*), Bash(wc:*), Bash(ls:*), Read, Write, Edit
---

# Sync Documentation

Unified documentation sync for CLAUDE.md and project docs/. Intelligently updates documentation based on codebase changes.

## Usage

```
/work-sync-docs [target]
```

**Targets:**
- `claudemd` - Update CLAUDE.md from recent git changes
- `docs` - Update docs/ folder from codebase
- `all` - Both (default)

## Phase 1: Detect What Exists

```bash
# Check for existing documentation
!`test -f CLAUDE.md && echo "CLAUDE.md: exists" || echo "CLAUDE.md: not found"`
!`test -d docs && ls -la docs || echo "docs/: not found"`

# Project type detection
!`find . -maxdepth 2 \( -name "flake.nix" -o -name "pyproject.toml" -o -name "package.json" -o -name "Cargo.toml" -o -name "go.mod" \) 2>/dev/null | head -5`
```

## Phase 2: Git Analysis (for CLAUDE.md)

```bash
# Recent commits
!`git log --oneline -10 2>/dev/null`

# Changes in last week
!`git log --since="1 week ago" --pretty=format:"%h - %ar : %s" --stat 2>/dev/null | head -50`

# Files changed recently
!`git diff HEAD~5 --name-only 2>/dev/null | head -20`

# New files added
!`git diff --name-status HEAD~10 2>/dev/null | grep "^A" | head -10`

# Deleted files
!`git diff --name-status HEAD~10 2>/dev/null | grep "^D" | head -10`

# Modified core files
!`git diff --name-status HEAD~10 2>/dev/null | grep "^M" | head -15`
```

## Phase 3: Update CLAUDE.md

If CLAUDE.md exists, read it and update based on git changes:

@CLAUDE.md

### What to Update

1. **Project Overview** - New technologies, version changes
2. **Architecture** - New patterns, structural changes
3. **Setup Instructions** - New dependencies, env vars
4. **Development Workflow** - New scripts, tools, processes
5. **Recent Updates Section** - Add dated summary of changes

### Update Rules

- **Preserve** custom content, architectural decisions, setup instructions
- **Add** new sections for undocumented features
- **Remove** outdated information
- **Don't duplicate** - summarize, don't list every change
- **Add timestamp** to Recent Updates section

## Phase 4: Update docs/

If docs/ exists, scan and update:

```bash
# Existing documentation
!`find docs -name "*.md" 2>/dev/null | head -20`

# Check for API/code changes that need doc updates
!`git diff HEAD~5 -- "**/routes/**" "**/api/**" "**/controllers/**" "**/models/**" 2>/dev/null | head -100`
```

### Update Strategy

1. **Preserve** existing custom content and tutorials
2. **Update** API references with current code
3. **Add** new sections for undocumented features
4. **Sync** configuration examples with current options
5. **Verify** code examples still work

### Sections to Check

- API Documentation (endpoints, parameters, responses)
- Configuration (compare with actual config files)
- Quick Start Guide (verify steps still work)
- Examples (test against current code)

## Output Format

After updates, provide summary:

```
## Documentation Sync Report

**Updated:** [timestamp]

### CLAUDE.md
- [x] Section updated: [name]
- [x] New section added: [name]
- [ ] No changes needed: [reason]

### docs/
- [x] [filename]: [what changed]
- [x] [filename]: [what changed]

### Summary
- Files updated: [count]
- Sections added: [count]
- Breaking changes noted: [yes/no]

### Warnings
- [any issues or manual review needed]
```

## Notes

- Always read existing docs before modifying
- Keep timestamps on modified sections
- Maintain existing document structure
- Don't replace - enhance and update
- For new projects, generate from scratch
