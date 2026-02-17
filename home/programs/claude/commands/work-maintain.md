---
description: Periodic maintenance workflow for keeping the codebase healthy
---

# Work Maintain

Periodic maintenance workflow for codebase health and hygiene.

## Workflow Pattern

**Check → Clean → Update → Security → Audit → Report**

## Phase 1: Health Check

Quick assessment of current state:

```bash
# Git status
!`git status --short 2>/dev/null | head -20 || echo "Not a git repository"`

# Disk usage in current directory
!`du -sh . 2>/dev/null && du -sh */ 2>/dev/null | sort -rh | head -10`

# Large files that might need attention
!`find . -type f -size +10M 2>/dev/null | grep -v node_modules | grep -v ".git" | head -10`

# Check for stale branches (local)
!`git branch -vv 2>/dev/null | grep -v "\[origin" | head -10 || echo "No stale branches"`
```

## Phase 2: Cleanup

Based on project type, suggest cleanup commands:

### NixOS Projects
```bash
# Check nix store usage
!`nix path-info --size --all 2>/dev/null | sort -rn | head -10 || echo "Nix not available"`

# Suggest cleanup commands (don't auto-run)
# - nh clean all --keep 3
# - nix store optimise
# - nix-collect-garbage --delete-older-than 30d
```

### Python Projects
```bash
# Check for cache directories
!`find . -type d -name "__pycache__" -o -name ".pytest_cache" -o -name "*.egg-info" -o -name ".mypy_cache" 2>/dev/null | head -10`

# Check virtualenv size
!`test -d .venv && du -sh .venv || test -d venv && du -sh venv || echo "No venv found"`
```

### Node Projects
```bash
# Check node_modules size
!`test -d node_modules && du -sh node_modules || echo "No node_modules"`

# Check for old lock files
!`test -f package-lock.json && stat --format="%y" package-lock.json || test -f yarn.lock && stat --format="%y" yarn.lock || test -f pnpm-lock.yaml && stat --format="%y" pnpm-lock.yaml || echo "No lock file"`
```

### General
```bash
# Find old log files
!`find . -name "*.log" -mtime +30 2>/dev/null | head -10`

# Find temporary files
!`find . -name "*.tmp" -o -name "*.bak" -o -name "*~" 2>/dev/null | head -10`

# Check for duplicate files (by name)
!`find . -type f -name "*.md" 2>/dev/null | xargs -I{} basename {} | sort | uniq -d | head -10`
```

## Phase 3: Dependencies Check

Check for outdated or vulnerable dependencies:

```bash
# Python - check for outdated packages
!`test -f pyproject.toml && uv pip list --outdated 2>/dev/null || echo "No pyproject.toml or uv not available"`

# Node - check for outdated packages
!`test -f package.json && npm outdated 2>/dev/null || echo "No package.json"`

# Nix - check flake inputs age
!`test -f flake.lock && stat --format="%y" flake.lock || echo "No flake.lock"`

# Check for security advisories (npm)
!`test -f package.json && npm audit 2>/dev/null | head -20 || echo "No package.json"`
```

## Phase 4: Security Scan

Check for accidentally committed secrets:

```bash
# Scan for potential secrets (exclude encrypted files and comments)
!`grep -rn -E "(api_key|apikey|password|passwd|secret|token|credential|private_key|aws_access|aws_secret)" --include="*.py" --include="*.ts" --include="*.js" --include="*.nix" --include="*.yaml" --include="*.yml" --include="*.env" 2>/dev/null | grep -v "secrets.enc" | grep -v ".sops" | grep -v "# " | grep -v "example" | head -20 || echo "No secrets found"`

# Check for .env files that should be gitignored
!`find . -name ".env" -o -name ".env.local" -o -name "*.env" 2>/dev/null | grep -v node_modules | head -10`

# Verify .gitignore covers sensitive patterns
!`test -f .gitignore && grep -E "(\.env|secrets|credentials|.*key.*\.pem)" .gitignore || echo "No secret patterns in .gitignore"`
```

## Phase 5: Code Health

Static analysis and code quality checks:

```bash
# Count TODO/FIXME comments
!`grep -r "TODO\|FIXME\|HACK\|XXX" --include="*.py" --include="*.ts" --include="*.js" --include="*.nix" 2>/dev/null | head -20`

# Check for large files in git history
!`git rev-list --objects --all 2>/dev/null | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | sed -n 's/^blob //p' | sort -rnk2 | head -10 || echo "Not a git repo"`

# Find dead code potential (Python)
!`test -f pyproject.toml && find . -name "*.py" -exec grep -l "def\|class" {} \; 2>/dev/null | head -10 || echo "Not a Python project"`
```

## Phase 6: Report Generation

Provide a structured maintenance report:

```
## Maintenance Report

**Generated:** [timestamp]
**Project:** [name]
**Type:** [detected type]

### Storage
- Total size: [size]
- Largest directories: [list]
- Cleanup potential: [estimate]

### Dependencies
- Outdated packages: [count]
- Security issues: [count/severity]
- Last lock file update: [date]

### Security
- Potential secrets found: [count]
- .env files exposed: [yes/no]
- .gitignore coverage: [adequate/needs update]

### Code Health
- TODOs/FIXMEs: [count]
- Large files: [count]
- Potential dead code: [count]

### Recommendations

**High Priority:**
1. [action]

**Medium Priority:**
2. [action]

**Low Priority:**
3. [action]

### Commands to Run

```bash
# Suggested cleanup (review before running)
[cleanup commands based on project type]
```

### Next Maintenance

Suggested interval: [weekly/biweekly/monthly]
```

## Interactive Options

After report, ask user:

1. **Run cleanup?** - Execute suggested cleanup commands
2. **Update dependencies?** - Run package updates
3. **Generate detailed audit?** - Deep dive into specific area
4. **Schedule reminder?** - Set up periodic maintenance reminder

## Notes

- Always preview destructive operations before running
- Keep backups of critical files before cleanup
- Log all maintenance actions
- Compare before/after states
- Consider setting up automated maintenance via cron/systemd timer
