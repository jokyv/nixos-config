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

    # Binary file protection
    {
      matcher = "Write|Edit";
      hooks = [
        {
          type = "command";
          command = ''
            if [ -f "$CLAUDE_FILE_PATH" ] && file "$CLAUDE_FILE_PATH" | grep -q "binary\|data"; then
              echo "BINARY_FILE_BLOCKED: Cannot modify binary file $CLAUDE_FILE_PATH"
              exit 1
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

    # Git conflict marker detection
    {
      matcher = "Write|Edit";
      hooks = [
        {
          type = "command";
          command = ''
            if grep -qE "^(<{7}|={7}|>{7})" "$CLAUDE_FILE_PATH" 2>/dev/null; then
              echo "GIT_CONFLICT_MARKERS in $CLAUDE_FILE_PATH - resolve before committing"
            fi
          '';
        }
      ];
    }
  ];
}
