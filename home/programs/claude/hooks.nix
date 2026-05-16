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
    # TDD enforcement: warn when editing Python files without test files
    {
      matcher = "Write|Edit";
      hooks = [
        {
          type = "command";
          command = ''
            FILE="$CLAUDE_FILE_PATH"
            if echo "$FILE" | grep -q '\.py$' && ! echo "$FILE" | grep -qiE '(test_|_test|conftest)' && [ -f "$FILE" ]; then
              BASENAME=$(basename "$FILE" .py)
              DIRNAME=$(dirname "$FILE")
              FOUND=false
              for TPATH in "$DIRNAME/test_$BASENAME.py" "$DIRNAME/$BASENAME"_test.py "$DIRNAME/../test_$BASENAME.py" "test_$BASENAME.py" "tests/test_$BASENAME.py" "tests/unit/test_$BASENAME.py"; do
                if [ -f "$TPATH" ]; then FOUND=true; break; fi
              done
              if [ "$FOUND" = false ]; then
                echo ""
                echo -e "\033[1;33m⚠️  TDD: No test file for $FILE\033[0m"
                echo "   Run /skill tdd to start test-first workflow"
                echo ""
              fi
            fi
          '';
        }
      ];
    }

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

    # Session analysis reminder (weekly, after 20+ tool uses)
    {
      matcher = ".*";
      hooks = [
        {
          type = "command";
          command = ''
            REMINDER_FILE="$HOME/.claude/logs/session-analysis-reminder"
            COUNT_FILE="$HOME/.claude/logs/tool-count"
            mkdir -p "$(dirname "$REMINDER_FILE")"

            COUNT=$(cat "$COUNT_FILE" 2>/dev/null || echo 0)
            COUNT=$((COUNT + 1))
            echo "$COUNT" > "$COUNT_FILE"

            if [ "$COUNT" -ge 20 ]; then
              if [ ! -f "$REMINDER_FILE" ] || [ $(($(date +%s) - $(cat "$REMINDER_FILE" 2>/dev/null || echo 0))) -gt 604800 ]; then
                echo ""
                echo -e "\033[1;36m💡 TIP: Run /session-analysis to review conversation patterns\033[0m"
                echo ""
                date +%s > "$REMINDER_FILE"
              fi
              echo "0" > "$COUNT_FILE"
            fi
          '';
        }
      ];
    }
  ];
}
