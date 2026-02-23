# Git Worktree Isolation Skill

Isolate risky or complex agent work in separate git worktrees to protect the main repository.

## When to Use

- Large refactors touching many files
- Experimental changes with uncertain outcome
- Multiple parallel agent tasks
- Testing risky transformations
- Working on features that might be abandoned

## Workflow

### 1. Create Isolated Worktree

```bash
# From main repo
git worktree add ../<project>-<task-name> -b <task-name>

# Example: git worktree add ../myapp-refactor-auth -b refactor/auth
```

### 2. Work in Isolation

```bash
cd ../<project>-<task-name>
# Agent makes changes here - main repo untouched
```

### 3. Review & Merge

```bash
# Review changes
git diff main

# If good: push and create PR
git push -u origin <task-name>

# If bad: simply delete worktree
cd ../<main-project>
git worktree remove ../<project>-<task-name>
git branch -D <task-name>
```

### 4. Cleanup After Merge

```bash
git worktree remove ../<project>-<task-name>
git branch -d <task-name>
```

## Quick Reference

| Command | Purpose |
|---------|---------|
| `git worktree add <path> -b <branch>` | Create new worktree |
| `git worktree list` | Show all worktrees |
| `git worktree remove <path>` | Delete worktree |
| `git worktree prune` | Clean up stale entries |

## Integration with Work Commands

1. `/work-prime` - Understand current state before creating worktree
2. `/work-design-review` - Review changes in worktree before merging
3. `/work-git-commit` - Commit from within worktree

## Example Session

```
User: I need to refactor the auth module but it's risky

Agent: Let me isolate this in a worktree.

$ git worktree add ../myapp-refactor-auth -b refactor/auth
$ cd ../myapp-refactor-auth

[Agent performs refactor in isolation]

$ git diff main  # Review
$ git push -u origin refactor/auth  # Ready for PR

Main repo at ~/myapp is completely untouched.
```

## Benefits

- **Safety**: Main repo never corrupted
- **Parallelism**: Multiple worktrees for multiple tasks
- **Easy rollback**: Just delete the worktree
- **Clean history**: No WIP commits in main
