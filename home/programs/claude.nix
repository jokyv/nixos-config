{ config, pkgs, ... }:

let
  TokenPath = config.sops.secrets.glm_auth_token.path;
  claudeDir = ./claude;
  hooksConfig = import ./claude/hooks.nix;
in
{
  sops.secrets.glm_auth_token = { };

  home.packages = [
    (pkgs.writeShellScriptBin "claude-wrapper" ''
      export ANTHROPIC_AUTH_TOKEN=$(cat ${TokenPath})
      exec ${pkgs.claude-code}/bin/claude "$@"
    '')
    # Smart git commit script for skill integration
    (pkgs.writeShellScriptBin "smart-git-commit" ''
      set -e

      # Check if we're in a git repository
      if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "Not in a git repository"
        exit 0
      fi

      # Check if there are any changes to commit
      if git diff --quiet && git diff --cached --quiet; then
        echo "No changes to commit"
        exit 0
      fi

      # Check if enough time has passed since last commit (30 minutes = 1800 seconds)
      last_commit_time=$(git log -1 --format="%at" 2>/dev/null || echo 0)
      current_time=$(date +%s)
      time_since_last_commit=$((current_time - last_commit_time))

      # Only commit if it's been more than 30 minutes
      if [ $time_since_last_commit -lt 1800 ]; then
        echo "Skipping auto-commit (last commit was $((time_since_last_commit / 60)) minutes ago)"
        exit 0
      fi

      # Stage all changes
      git add -A

      # Get the staged changes for analysis
      staged_changes=$(git diff --staged --minimal)

      if [ -z "$staged_changes" ]; then
        echo "No new changes to stage"
        exit 0
      fi

      # Generate commit message based on changes
      echo "Generating commit message..."
      if echo "$staged_changes" | grep -q "\.md$"; then
        if echo "$staged_changes" | grep -q "README\|docs\|documentation"; then
          commit_msg="docs: update documentation"
        elif echo "$staged_changes" | grep -q "config\|settings\|\.claude"; then
          commit_msg="config: update configuration"
        else
          commit_msg="docs: update markdown files"
        fi
      elif echo "$staged_changes" | grep -q "\.py$"; then
        if echo "$staged_changes" | grep -q "def\|class"; then
          commit_msg="refactor: update python code"
        elif echo "$staged_changes" | grep -q "import\|from"; then
          commit_msg="deps: update dependencies"
        else
          commit_msg="fix: update python implementation"
        fi
      elif echo "$staged_changes" | grep -q "deleted\|removed"; then
        commit_msg="chore: remove unused files"
      elif echo "$staged_changes" | grep -q "new\|create\|add"; then
        commit_msg="feat: add new files"
      else
        commit_msg="chore: sync changes $(date '+%H:%M')"
      fi

      # Create the commit
      if git commit -m "$commit_msg" --no-verify; then
        echo "Auto-committed: $commit_msg"
        echo "Time since last commit: $((time_since_last_commit / 60)) minutes"
      else
        echo "Failed to create commit"
        exit 1
      fi
    '')
  ];

  programs.claude-code = {
    enable = true;

    # Custom commands
    commands = {
      work-git-commit = "${claudeDir}/commands/work-git-commit.md";
      work-release-notes = "${claudeDir}/commands/work-release-notes.md";
      work-sync-docs = "${claudeDir}/commands/work-sync-docs.md";
      work-issue = "${claudeDir}/commands/work-issue.md";
      work-prime = "${claudeDir}/commands/work-prime.md";
      work-setup = "${claudeDir}/commands/work-setup.md";
      work-maintain = "${claudeDir}/commands/work-maintain.md";
      work-design-review = "${claudeDir}/commands/work-design-review.md";
    };

    # Custom skills
    skills = {
      smart-git-commit = "${claudeDir}/skills/smart-git-commit.md";
      python = "${claudeDir}/skills/python.md";
      session-analysis = "${claudeDir}/skills/session-analysis.md";
    };

    memory.text = ''
      # CLAUDE.md - Project Conventions & AI Assistant Instructions

      ## Core Principles

      - **Clarity over Cleverness:** Favor readable code over obscure implementations
      - **Consistency:** Match existing code style and patterns
      - **Modularity:** Single responsibility - each function/class does one thing well
      - **Minimal Scope:** Only change what's necessary for the task
      - **YAGNI & KISS:** Strictly follow requirements, don't over-engineer

      ## Code Style

      - Use project's linter/formatter if present
      - Comments explain _why_ not _what_
      - Group imports: built-in → third-party → internal
      - Indent with spaces, never tabs
      - Empty lines have no indentation
      - Be concise when naming; omit words if clear from context
      - Only comment to: clarify complex code, explain non-obvious decisions, group long scopes

      ### Naming

      - Variables/Functions: `lower_snake_case`
      - Components/Classes: `PascalCase`
      - Constants: `UPPER_SNAKE_CASE`
      - Files: `kebab-case` (React components: `PascalCase`)

      ## Python

      - Type hints (PEP 484) for all function signatures
      - Prefer functional constructs (comprehensions, generators) over loops
      - NumPy-style docstrings for functions/classes
      - Use `match...case` instead of complex `if...elif...else`
      - Libraries: polars > pandas, pathlib for paths, @dataclass for data, uv for deps
      - Catch specific exceptions, never broad `except Exception:`
      - Never swallow exceptions silently

      ## Git Commits

      ```
      <type>[scope]: <description>  # imperative, lowercase, ≤50 chars

      [optional body - WHY not HOW]

      [optional footer - Fixes #123, BREAKING CHANGE:]
      ```

      Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert

      ## Communication Style

      - Be concise - I'll ask if I need details
      - Avoid hyperbolic expressions
      - Provide critical feedback (not sycophantic or judgemental)
      - Emojis: 🤔 unsure, 🔥 confident, 🥳 success, 💩 failed, 🐞 bug, 😆 joke
      - Suggest tools/patterns with links when relevant

      ## AI Code Direction

      - Never accept first draft - review for structural issues
      - Before implementing, explain design approach and component relationships
      - Identify circular dependencies and suggest fixes
      - Question if a class should be a function (or vice versa)
      - Point out mixed responsibilities in classes
      - Ask "Is there a way to..." to explore alternatives
      - High-level modules shouldn't depend on low-level details

      ## Hooks Active

      - Secret leak detection: logs potential credential exposure
      - Binary file protection: blocks edits to binary files
      - Conflict marker detection: warns on git merge conflicts

      ## Environment

      - Shell: bash
      - NixOS: use `nix shell` if CLI tool not found
      - Python projects: use uv if `uv.lock` exists

      ## Security

      - For cryptographic keys, always provide authoritative link for verification
    '';

    settings = {
      env = {
        ANTHROPIC_BASE_URL = "https://api.z.ai/api/anthropic";
        API_TIMEOUT_MS = "3000000";
        ANTHROPIC_DEFAULT_HAIKU_MODEL = "glm-4.7-air";
        ANTHROPIC_DEFAULT_SONNET_MODEL = "glm-5";
        ANTHROPIC_DEFAULT_OPUS_MODEL = "glm-5";
        # ANTHROPIC_AUTH_TOKEN = "YOUR_TOKEN_HERE";  # Use sops or env var instead
        # CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1";  # Enable multi-agent orchestration
      };

      permissions = {
        allow = [ ];
        deny = [
          "Bash(rm -rf :*)"
          "Bash(sudo rm -rf :*)"
          "Bash(dd :*)"
          "Bash(mkfs :*)"
          "Bash(fdisk :*)"
          "Bash(format :*)"
          "Bash(shred :*)"
        ];
      };

      enabledPlugins = {
        "feature-dev@claude-code-plugins" = true;
        "security-guidance@claude-code-plugins" = true;
        "conductor@conductor-cc" = false;
        "code-simplifier@claude-plugins-official" = true;
        "rust-analyzer-lsp@claude-plugins-official" = true;
      };

      hooks = hooksConfig;
    };
  };
}
