---
description: Analyze recent Claude conversations for friction patterns and suggest CLAUDE.md improvements
---

# Session Analysis

Analyze recent Claude Code conversation history (last 7 days) to find friction points and improve CLAUDE.md.

**Token-efficient:** ~800-1200 tokens per run.

## Workflow

### 1. Find Recent Conversation Files

```bash
# Find JSONL files modified in last 7 days
!`find ~/.claude/projects -name "*.jsonl" -type f -mtime -7 2>/dev/null | head -10`
```

### 2. Extract Friction Patterns

```bash
# Search for friction keywords in recent sessions (limited output)
!`find ~/.claude/projects -name "*.jsonl" -type f -mtime -7 -exec grep -h '"role":"user"' {} \; 2>/dev/null | grep -iE '"(wrong|incorrect|no,|stop|don'"'"'t|not what|ignoring|repeating|again|mistake|error|fail|bad|fix|shouldn'"'"'t|doesn'"'"'t|broken)"' | head -15`
```

### 3. Generate Concise Report

```
## Session Analysis (Last 7 Days)

**Sessions analyzed:** [N] | **Friction points found:** [N]

### Top Patterns

1. **[Pattern]** - [N] occurrences
   - Fix: Add "[rule]" to CLAUDE.md

2. **[Pattern]** - [N] occurrences
   - Fix: Add "[rule]" to CLAUDE.md

3. **[Pattern]** - [N] occurrences
   - Fix: Add "[rule]" to CLAUDE.md

### Suggested CLAUDE.md Addition

```
[Single most impactful rule to add]
```
```

## Friction Keywords

| Category | Keywords |
|----------|----------|
| Corrections | wrong, incorrect, no, stop, don't |
| Repetition | again, repeating, still, keeps |
| Quality | mistake, error, fail, broken |

## Where to Apply Changes

**Default:** Update local `<current-repo>/CLAUDE.md` directly.

**For global rules:** Ask user first before editing `~/nixos-config/home/programs/claude.nix` (memory.text block), then remind to run `just home`.

## Notes

- Only analyzes last 7 days (token-efficient)
- Limits output to 15 matches max
- Focus on top 3 patterns only
- Run weekly for continuous improvement
