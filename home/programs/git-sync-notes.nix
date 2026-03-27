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

    VAULT=$(<"${vaultPathFile}")
    VAULT=''${VAULT%$'\n'}
    # If VAULT is not absolute, prepend $HOME
    case "$VAULT" in
      /*) : ;;
      *) VAULT="$HOME/$VAULT" ;;
    esac

    cd "$VAULT"

    branch=$(git rev-parse --abbrev-ref HEAD)
    git fetch origin "$branch"

    needs_commit=0
    needs_pull=0
    needs_push=0

    [ -n "$(git status --porcelain)" ] && needs_commit=1
    [ "$(git rev-list --count "HEAD..origin/$branch" 2>/dev/null || echo 0)" -gt 0 ] && needs_pull=1
    [ "$(git rev-list --count "origin/$branch"..HEAD 2>/dev/null || echo 0)" -gt 0 ] && needs_push=1

    [ $needs_commit -eq 0 ] && [ $needs_pull -eq 0 ] && [ $needs_push -eq 0 ] && {
      notify-send -u low "Git sync" "Already synchronized – nothing to do"
      exit 0
    }

    if [ $needs_commit -eq 1 ]; then
      git add -A
      git diff-index --cached --quiet HEAD -- || git commit -m "Auto-backup: $(date)"
    fi

    if [ $needs_pull -eq 1 ]; then
      if ! git rebase "origin/$branch"; then
        notify-send -u critical "Git sync FAILED" "Rebase conflict in notes vault" 2>/dev/null || true
        exit 1
      fi
    fi

    if [ $needs_push -eq 1 ]; then
      if ! git push origin "$branch"; then
        notify-send -u critical "Git sync FAILED" "Push failed in notes vault" 2>/dev/null || true
        exit 1
      fi
    fi

    actions=()
    [ $needs_commit -eq 1 ] && actions+=("committed")
    [ $needs_pull -eq 1 ] && actions+=("pulled")
    [ $needs_push -eq 1 ] && actions+=("pushed")
    action_str=$(IFS=", "; echo "$${actions[*]}")
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
      OnCalendar = "*:0/15";
      Persistent = true;
    };
  };
}
