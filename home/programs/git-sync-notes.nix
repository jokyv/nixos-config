{
  config,
  pkgs,
  lib,
  ...
}:

let
  vaultPathFile = config.sops.secrets.notes_path.path;

  git-sync-notes-script = pkgs.writeShellScriptBin "git-sync-notes" ''
    set -euo pipefail

    log() {
      echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >&2
    }

    # Check network connectivity with retries
    wait_for_network() {
      local max_attempts=5
      local attempt=1
      while [ $attempt -le $max_attempts ]; do
        if ping -c 1 -W 2 github.com >/dev/null 2>&1; then
          log "Network is online"
          return 0
        fi
        log "Network check failed (attempt $attempt/$max_attempts), waiting 3 seconds..."
        sleep 3
        attempt=$((attempt + 1))
      done
      log "Network is not available after $max_attempts attempts"
      return 1
    }

    VAULT=$(tr -d '\n' < "${vaultPathFile}")
    # If VAULT is not absolute, prepend $HOME
    case "$VAULT" in
      /*) : ;;
      *) VAULT="$HOME/$VAULT" ;;
    esac

    if [ ! -d "$VAULT/.git" ]; then
      log "ERROR: Vault directory '$VAULT' is not a git repository"
      notify-send -u critical "Git sync FAILED" "Vault is not a git repository: $VAULT" 2>/dev/null || true
      exit 1
    fi

    cd "$VAULT"

    # Wait for network before proceeding
    if ! wait_for_network; then
      notify-send -u critical "Git sync FAILED" "Network unavailable – cannot sync" 2>/dev/null || true
      exit 1
    fi

    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")
    log "Current branch: $branch"

    # Fetch with retry logic
    fetch_attempts=3
    fetch_success=0
    for i in $(seq 1 $fetch_attempts); do
      if git fetch origin "$branch"; then
        fetch_success=1
        break
      fi
      log "Git fetch failed (attempt $i/$fetch_attempts), retrying in 2 seconds..."
      sleep 2
    done

    if [ $fetch_success -ne 1 ]; then
      log "ERROR: Git fetch failed after $fetch_attempts attempts"
      notify-send -u critical "Git sync FAILED" "Could not fetch from remote" 2>/dev/null || true
      exit 1
    fi

    needs_commit=0
    needs_pull=0
    needs_push=0

    [ -n "$(git status --porcelain)" ] && needs_commit=1
    [ "$(git rev-list --count "HEAD..origin/$branch" 2>/dev/null || echo 0)" -gt 0 ] && needs_pull=1
    [ "$(git rev-list --count "origin/$branch"..HEAD 2>/dev/null || echo 0)" -gt 0 ] && needs_push=1

    log "Status: commit=$needs_commit pull=$needs_pull push=$needs_push"

    if [ $needs_commit -eq 0 ] && [ $needs_pull -eq 0 ] && [ $needs_push -eq 0 ]; then
      log "Already synchronized – nothing to do"
      notify-send -u low "Git sync" "Already synchronized – nothing to do"
      exit 0
    fi

    if [ $needs_commit -eq 1 ]; then
      git add -A
      if git diff-index --cached --quiet HEAD --; then
        log "No changes to commit after staging"
        needs_commit=0
      else
        git commit -m "Auto-backup: $(date)"
        log "Committed changes"
        # After committing, we now have unpushed commits
        needs_push=1
      fi
    fi

    if [ $needs_pull -eq 1 ]; then
      log "Pulling changes from origin/$branch..."
      if ! git rebase "origin/$branch"; then
        log "ERROR: Rebase failed"
        notify-send -u critical "Git sync FAILED" "Rebase conflict in notes vault" 2>/dev/null || true
        exit 1
      fi
    fi

    if [ $needs_push -eq 1 ]; then
      log "Pushing to origin/$branch..."
      if ! git push origin "$branch"; then
        log "ERROR: Push failed"
        notify-send -u critical "Git sync FAILED" "Push failed in notes vault" 2>/dev/null || true
        exit 1
      fi
    fi

    actions=()
    [ $needs_commit -eq 1 ] && actions+=("committed")
    [ $needs_pull -eq 1 ] && actions+=("pulled")
    [ $needs_push -eq 1 ] && actions+=("pushed")
    action_str=$(IFS=", "; echo "$${actions[*]}")
    log "Sync completed: $action_str"
    notify-send -u normal "Git sync successful" "notes: $action_str" 2>/dev/null || true
  '';
in
{
  home.packages = with pkgs; [
    git-sync-notes-script
    libnotify
    git
  ];

  systemd.user.services.git-sync-notes = {
    Unit = {
      Description = "Auto-commit and push Obsidian vault changes to GitHub";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${git-sync-notes-script}/bin/git-sync-notes";
      # Ensure the environment includes Nix-profile and system binaries
      Environment = [
        "PATH=${config.home.profileDirectory}/bin:/run/current-system/sw/bin"
      ];
    };
  };

  systemd.user.timers.git-sync-notes = {
    Install = {
      WantedBy = [ "timers.target" ];
    };
    Timer = {
      OnCalendar = "hourly";
      Persistent = true;
    };
  };
}
