# Smart Git Commit Skill

Automatically generates and creates git commits based on changes, with intelligent timing to avoid micro-commits.

## Usage

```bash
claude skill:smart-git-commit
```

## Features

- **Time-based filtering**: Only commits if 30+ minutes have passed since last commit
- **Change detection**: Checks if there are actual staged changes
- **AI-generated messages**: Uses Claude to create semantic commit messages
- **Cross-project**: Works in any git repository
- **Fallback handling**: Uses timestamp if AI generation fails

## Implementation

The skill performs these steps:

1. Check if we're in a git repository
2. Look for uncommitted changes
3. Check if enough time has passed (30 minutes)
4. Stage all changes
5. Generate appropriate commit message using AI
6. Create the commit with generated message

## Configuration

You can customize the time threshold by modifying the script (default: 30 minutes).

## Integration

To use this as an automatic hook, add to your Claude settings:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "claude skill:smart-git-commit",
            "statusMessage": "Smart commit check"
          }
        ]
      }
    ]
  }
}
```
