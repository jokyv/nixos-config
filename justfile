set shell := ["bash", "-euo", "pipefail", "-c"]
set positional-arguments := true

# Display all available commands sorted
default:
    @just --list

# Display help for all available commands unsorted
help:
    just --list --unsorted

# -----------------------------------------------
# Rebuild Commands
# -----------------------------------------------

# Rebuild the home config
[group('rebuild')]
home:
    @echo "[INFO] Rebuilding Home Manager configuration..."
    home-manager switch -b backup --flake .#jokyv --show-trace || { echo "[ERROR] Home Manager switch failed"; exit 1; }
    @echo "[SUCCESS] Home Manager rebuild successful"

# Rebuild the home config using nh
[group('rebuild')]
home-nh:
    nh home switch -c jokyv .

# Switch to gaming mode
[group('rebuild')]
game:
    @echo "[INFO] Switching to gaming mode..."
    home-manager switch --flake .#gaming || { echo "[ERROR] Gaming mode switch failed"; exit 1; }
    @echo "[SUCCESS] Gaming mode activated"

# Alias hnh for home-nh

alias hnh := home-nh

# Rebuild the system
[group('rebuild')]
switch:
    @echo "[INFO] Rebuilding system configuration..."
    sudo nixos-rebuild switch --impure --flake .#nixos --show-trace || { echo "[ERROR] System rebuild failed"; exit 1; }
    @echo "[SUCCESS] System rebuild successful"

# Rebuild the system using nh
[group('rebuild')]
switch-nh:
    nh os switch .

# Alias hnh for home-nh

alias snh := switch-nh

# Build a new configuration
[group('rebuild')]
boot:
    @echo "[WARNING] Building boot configuration..."
    sudo nixos-rebuild boot --fast --impure --flake .#nixos --show-trace || { echo "[ERROR] Boot config failed"; exit 1; }
    @echo "[SUCCESS] Boot configuration built successfully"

# Dry-build a new configuration
[group('rebuild')]
dry:
    @echo "[WARNING] Running dry-build..."
    sudo nixos-rebuild dry-activate --fast --flake .#nixos --show-trace || { echo "[ERROR] Dry-run failed"; exit 1; }
    @echo "[SUCCESS] Dry-build completed successfully"

# Run tests
[group('dev')]
test:
    @echo "[INFO] Running tests..."
    nix flake check --show-trace --print-build-logs --verbose
    @echo "[SUCCESS] Tests completed"

# Update all inputs
[group('dev')]
up:
    @echo "[WARNING] Updating flake inputs..."
    nix flake update --refresh --commit-lock-file
    @echo "[SUCCESS] Flake inputs updated"

# Update specific input. Usage: just upp nixpkgs
[group('dev')]
upp input:
    nix flake update {{ input }}

# Show what has yet to be persisted in a folder. Usage: just ephemeral $HOME | $PAGER
[group('maintenance')]
ephemeral dir="$HOME":
    list-ephemeral {{ dir }}

# Open a Nix REPL - run manually to load flake: `:lf .`
[group('dev')]
repl:
    nix repl

# Dry run to see what would be cleaned with default cleanup command
[group('maintenance')]
cleanup-dry:
    @echo "[INFO] Dry run - showing what would be cleaned..."
    nh clean all --keep 3 --dry || { echo "[ERROR] Dry cleanup failed"; exit 1; }
    @echo "[SUCCESS] Dry cleanup completed"

# Quick cleanup - keep 10 generations (safe)
[group('maintenance')]
cleanup-quick:
    @echo "[INFO] Running quick cleanup (keeping 10 generations)..."
    nh clean all --keep 10 || { echo "[ERROR] Quick cleanup failed"; exit 1; }
    @echo "[SUCCESS] Quick cleanup completed"

# Smart cleanup - keep 3 generations (recommended for regular use)
[group('maintenance')]
cleanup-smart:
    @echo "[INFO] Running smart cleanup (keeping 3 generations)..."
    nh clean all --keep 3 || { echo "[ERROR] Smart clean failed"; exit 1; }
    sudo nix store optimise || { echo "[ERROR] Store optimization failed"; exit 1; }
    @echo "[SUCCESS] Smart cleanup completed"

# Deep / aggressive cleanup (use with caution)
[group('maintenance')]
cleanup-deep:
    @echo "[WARNING] Running deep cleanup (keeping only current generation)..."
    nh clean all --keep 1 || { echo "[ERROR] Deep clean failed"; exit 1; }
    sudo nix-collect-garbage --delete-older-than 30d || { echo "[ERROR] Garbage collection failed"; exit 1; }
    @echo "[SUCCESS] Deep cleanup completed"

# cleanup alias (points to smart cleanup as default)
[group('maintenance')]
cleanup: cleanup-smart

# Encode secrets
[group('secrets')]
encode:
    sops -e secrets.yaml > secrets.enc.yaml

# Decode secrets
[group('secrets')]
decode:
    sops -d secrets.enc.yaml > secrets.yaml

# Safely edit encrypted secrets using SOPS (Secrets OPerationS)
[group('secrets')]
edit-secrets:
    sops secrets.yaml

# Validate that the encrypted secrets file can be decrypted successfully
[group('secrets')]
validate-secrets:
    @echo "[INFO] Validating secrets..."
    sops -d secrets.enc.yaml > /dev/null && echo "[SUCCESS] Secrets are valid" || { echo "[ERROR] Secrets validation failed"; exit 1; }

# Rotate the encryption key for secrets (use if keys are compromised)
[group('secrets')]
rotate-secrets:
    sops --rotate secrets.yaml

# Show the current changes
[group('dev')]
diff:
    @echo "Showing changes to Nix configuration..."
    git diff -U0 --color=always .

# Format code
[group('dev')]
fmt:
    @echo "[INFO] Formatting code..."
    treefmt .
    @echo "[SUCCESS] Formatting completed"

# Create a commit with generation number
[group('dev')]
commit:
    @echo "Committing generation {{ `sudo nixos-rebuild list-generations | awk '/True/ {print $1}'` }}"
    git commit -am "chore(nixos): apply generation {{ `sudo nixos-rebuild list-generations | awk '/True/ {print $1}'` }}"

# Buffed nixos-rebuild switch - depends on fmt, switch, and commit
[group('rebuild')]
buffedswitch: fmt switch commit
    @echo "Done."

# Quick system status check
[group('maintenance')]
status:
    @echo "[INFO] System Status Summary"
    sudo nixos-rebuild list-generations | tail -3
    @echo "---"
    @if sudo nix-store --verify --check-contents --dry-run 2>/dev/null; then \
      echo "[SUCCESS] Nix store integrity: OK"; \
    else \
      echo "[WARNING] Nix store verification requires repair or has issues"; \
    fi
    @echo "[SUCCESS] Status check completed"

# Run a complete development workflow: format code, run tests, and dry-run the build
[group('dev')]
dev: fmt test dry

# Perform a quick security audit of the flake without building anything
[group('dev')]
audit:
    nix flake check --no-build --no-eval-cache

# Display detailed system information including Nix version and platform details
[group('dev')]
info:
    nix-shell -p nix-info --run "nix-info -m"

# Build the system configuration without applying it, then show differences from current system
[group('dev')]
backup:
    sudo nixos-rebuild build --flake .#nixos
    sudo nix store diff-closures /run/current-system ./result

# Check the integrity of the Nix store and run 'nix config check' for system health
[group('maintenance')]
health:
    @echo "[INFO] Running system health checks..."
    @echo "[INFO] Running quick store verification (faster)..."
    sudo nix-store --verify --check-contents 2>/dev/null || echo "[WARN] Full store verification skipped - use 'health-full' for complete check"
    nix config check || true
    @echo "[SUCCESS] Health checks completed"

# Full system health check with complete store verification (slow)
[group('maintenance')]
health-full:
    @echo "[INFO] Running full system health checks..."
    @echo "[INFO] This may take 15-60 minutes depending on system size..."
    sudo nix-store --verify --check-contents
    nix config check || true
    @echo "[SUCCESS] Full health checks completed"

# Calculate the total disk space used by the current system configuration
[group('maintenance')]
disk-usage:
    sudo nix-store --query --disk-usage $(sudo nix-store -q --requisites /run/current-system)

# Check the health of the Nix flake (package freshness and input age).
[group('maintenance')]
flake-health:
    python3 ~/scripts/nix_flake_health/main.py --flake ~/nixos-config/flake.nix

# home-manager news
[group('dev')]
news:
    home-manager news --flake .#jokyv

# -----------------------------------------------
# Useful nix commands
# -----------------------------------------------

useful-commands:
    @echo "sudo nixos-rebuild switch - apply configuration right now"
    @echo "sudo nixos-rebuild boot - apply configuration on next boot"
    @echo "sudo nixos-rebuild test - test without making permanent"
    @echo "sudo nixos-rebuild switch --flake .#flakename - use flake"
    @echo "nix store gc - garbage collection"
    @echo "nix store optimise - optimise store"

    @echo "home-manager switch - apply home config"
    @echo "home-manager switch --flake .#user - use flake"

    @echo "sudo nixos-rebuild list-generations - list generation" 
    @echo "sudo nixos-rebuild switch --rollback - swith to previous generation" 
    @echo "sudo nixos-rebuild boot --option number <id> - boot into generataion id"

    @echo "home-manager generations - list home generations"
    @echo "home-manager switch --rollback - rollback to previous generation"
    @echo "nix-env --profile ~/.nix-profile --switch-generation <id> - switch to generation id"
    @echo "nix-env --profile ~/.nix-profile --delete-generations <id> - delete generation id"
