{
  PreToolUse = [
    # Secret leak prevention
    {
      matcher = "Write|Edit|Bash";
      hooks = [
        {
          type = "command";
          command = ''
            if echo "$CLAUDE_TOOL_INPUT" | grep -qiE "(password|api_key|secret|token)\s*[=:]\s*['\"][^'\"]{8,}['\"]"; then
              mkdir -p ~/.claude/logs && echo "[SECURITY] Potential secret leak in $CLAUDE_FILE_PATH at $(date '+%Y-%m-%d %H:%M:%S')" >> ~/.claude/logs/security.log
            fi
          '';
        }
      ];
    }
  ];

  PostToolUse = [
    # Desktop notification on task completion
    {
      matcher = "TaskOutput";
      hooks = [
        {
          type = "command";
          command = ''notify-send "Claude Code" "Task completed" -t 2000 2>/dev/null || true'';
        }
      ];
    }
  ];
}
