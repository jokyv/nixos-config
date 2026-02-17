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
    };

    # Custom skills
    skills = {
      smart-git-commit = "${claudeDir}/skills/smart-git-commit.md";
    };

    memory.text = ''
      # CLAUDE.md - Project Conventions & AI Assistant Instructions

      ## Objective

      You are an AI coding assistant implementing features for this project. Your goal is to write clean, maintainable code following established conventions and patterns.

      ## Core Principles

      - **Clarity over Cleverness:** Favor readable code over obscure implementations
      - **Consistency:** Match existing code style and patterns
      - **Modularity:** Create focused functions/components with single responsibilities
      - **Minimal Scope:** Only change what's necessary for the task
      - **YAGNI & KISS:** Strictly follow requirements, don't over-engineer

      ## Code Style & Structure

      ### General

      - Use project's linter/formatter if present, otherwise use community standards
      - Comments explain _why_ not _what_
      - Group imports logically: built-in → third-party → internal
      - Use absolute imports (`@/...`) if configured

      ### Naming Conventions

      - Variables & Functions: `lower_snake_case`
      - Components: `PascalCase`
      - Constants: `UPPER_SNAKE_CASE`
      - Files: `kebab-case` (use `PascalCase` for React components)

      ### Documentation

      - Provide detailed type annotations for functions/components
      - Add README.md for significant new modules
      - Document complex algorithms and business logic

      ## Python Conventions

      - Use standard Python type hints (PEP 484) for all function arguments and return values
      - Prefer functional constructs (list comprehensions, generators, map/filter) over raw loops
      - Use descriptive variable names with auxiliary verbs
      - Functions and classes should have NumPy docstrings standard
      - Use match...case instead of complex if...elif...else statements
      - For refactoring: break into small steps, make minimal changes, maintain identical behavior

      ### Exception Handling

      - Catch specific exceptions, not broad `except Exception:`
      - Use `try/except/else/finally` blocks or context managers
      - Raise custom exception classes inheriting from `Exception` (suffix with `Error`)
      - Log errors with context before re-raising or handling
      - Never swallow exceptions silently without explaining why

      ### Python Libraries

      - Prefer polars over pandas for data analysis
      - Use pathlib for filesystem paths
      - Use @dataclass decorator for data-storing classes
      - Use uv for dependency management (not pip)
      - Use tomllib module for .toml file interactions

      ## Git Commit Standards

      Follow semantic commit messages:

      ```
      <type>[scope]: <description>

      [optional body]

      [optional footer]
      ```

      **Types:** feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert

      **Guidelines:**

      - Description: imperative, lowercase, no period, ≤50 chars
      - Body: explain WHY not HOW, wrap at 72 chars
      - Footer: reference issues (`Fixes #123`), breaking changes (`BREAKING CHANGE:`)
      - Commits should be atomic and specific
      - Use `git commit -m "message"` directly, never separate draft files

      ## Interaction Protocol

      1. Execute tasks from todo.md in specified order
      2. Focus exclusively on current task, don't implement future features
      3. Write code directly to correct files
      4. Mark completed tasks with `[x]` in todo.md
      5. Write tests for non-trivial new functions if testing framework exists
      6. If encountering errors/ambiguities, state problem clearly and wait for instruction

      # Communication style

      - Be concise in your responses
      - Don't bother explaining what you did in great detail: I'll ask if I need details
      - Avoid hyperbolic expressions and be direct
      - Don't be sycophantic: provide critical feedback (but not judgemental)
      - Once in a while, make a joke, but don't make it cheesy: be creative, use dark humor and nerdy jokes
      - Use the following emojis to express the tone of your response:
        * 🤔 - you are unsure
        * 🔥 - you are confident and we are on a roll
        * 🥳 - you have succeded
        * 💩 - you have failed or something went wrong
        * 🐞 - you found a bug
        * 😆 - you or I have made a joke
        * feel free to include other emojis as you see fit
      - If you think of an architectural pattern, library or tool that can help my project, suggest it an provide a link

      # Coding style

      - Indent with spaces and never tabs
      - Ensure empty lines have no indentation
      - Be concise when naming variables, functions and classes
      - You may omit words from a name if they are clear from context
      - Only use comments in the following cases:
        * To clarify complex code
        * To explain why something was done, if it is not immediately obvious
        * To group sequences of expression in a long scope and clarify steps (but don't use numbering)

      ## Shell

      I use bash; for all shell commands, assume this is the shell.

      I am in a NixOS environment: if you need access to a CLI tool and don't find it, you may use `nix shell` commands.

      ## Python projects

      Always use uv to manage the project if there is a `uv.lock`.

      # Security

      - When generating code with some cryptographic keys, *always* provide an authorative link to
        allow me to verify them.
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
