# Generate release notes for the repository using git-cliff

Generate release notes using git-cliff following the git manifesto conventions.

This command follows these steps from the git manifesto:
1. Checks current version with `git tag`
2. Uses year-month-mini version format (e.g., v22.09) or major-minor-mini (e.g., v2.0.0)
3. Generates release notes with git-cliff for the specified version range
4. Outputs in markdown format suitable for GitHub releases

Usage examples:
- Generate for all commits: /release-notes-repo
- Generate for specific version: /release-notes-repo v22.09
- Generate for version range: /release-notes-repo v21.05..v22.09
- Latest released version: /release-notes-repo --latest
- Unreleased commits: /release-notes-repo --unreleased
- Dry run (preview only): /release-notes-repo --dry-run
- Dry run for specific version: /release-notes-repo v22.09 --dry-run

The output will:
- Parse conventional commits (feat, fix, docs, style, refactor, etc.)
- Group changes alphabetically by scope/project
- Include breaking changes
- Format as markdown for GitHub release descriptions
- With --dry-run: Preview the output without modifying anything
- With --unreleased: Show commits since the latest tag (for new releases)
- With --latest: Show release notes for the latest tagged version

After running, you can copy the output to create a new GitHub release with:
- Release title matching the version (e.g., v22.09 or v2.0.0)
- Description using the generated release notes

Note: git-cliff doesn't have a built-in --dry-run flag. The command handles --dry-run internally to preview output.
