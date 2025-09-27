set shell := ["bash", "-euo", "pipefail", "-c"]
set positional-arguments

default:
  @just --list

# Display help for all available just commands
help:
  just --list --unsorted

# -----------------------------------------------
# home-manager specific
# -----------------------------------------------

# Legacy Home Manager commands (commented out as they use old patterns)
# install:
#   echo "Installing Home Manager..."
#   nix-shell '<home-manager>' -p home-manager --run "home-manager switch"

# apply:
#   echo "Applying Home Manager configuration..."
#   nix-shell '<home-manager>' -p home-manager --run "home-manager switch"

# Legacy cleanup alias (backward compatibility)
clean:
  @echo "[INFO] Running legacy cleanup command (redirecting to cleanup-smart)..."
  just cleanup-smart

# Rebuild the home config
home:
  @echo "[INFO] Rebuilding Home Manager configuration..."
  home-manager switch -b backup --flake .#jokyv --show-trace || { echo "[ERROR] Home Manager switch failed"; exit 1; }
  @echo "[SUCCESS] Home Manager rebuild successful"

# Rebuild the home config using nh
nhh:
  nh home switch -c jokyv .

# Alias for nhh
home-nh: nhh

# -----------------------------------------------
# NixOS specific
# -----------------------------------------------

# Rebuild the system
switch:
  @echo "[INFO] Rebuilding system configuration..."
  sudo nixos-rebuild switch --impure --flake .#nixos --show-trace || { echo "[ERROR] System rebuild failed"; exit 1; }
  @echo "[SUCCESS] System rebuild successful"

# Rebuild the system using nh
nhs:
  nh os switch .

# Build a new configuration
boot:
  @echo "[WARNING] Building boot configuration..."
  sudo nixos-rebuild boot --fast --impure --flake .#nixos --show-trace || { echo "[ERROR] Boot configuration failed"; exit 1; }
  @echo "[SUCCESS] Boot configuration built successfully"

# Dry-build a new configuration
dry:
  @echo "[WARNING] Running dry-build..."
  sudo nixos-rebuild dry-activate --fast --flake .#nixos --show-trace || { echo "[ERROR] Dry-run failed"; exit 1; }
  @echo "[SUCCESS] Dry-build completed successfully"

# Format code
fmt:
  @echo "[INFO] Formatting code..."
  nixpkgs-fmt .
  @echo "[SUCCESS] Formatting completed"

# Run tests
test:
  @echo "[INFO] Running tests..."
  nix flake check --show-trace --print-build-logs --verbose
  @echo "[SUCCESS] Tests completed"

# Update all inputs
up:
  @echo "[WARNING] Updating flake inputs..."
  nix flake update --refresh --commit-lock-file
  @echo "[SUCCESS] Flake inputs updated"

# Update specific input. Usage: just upp nixpkgs
upp input:
  nix flake update {{input}}

# Show what has yet to be persisted in a folder. Usage: just ephemeral $HOME | $PAGER
ephemeral dir="$HOME":
  list-ephemeral {{dir}}

# Open a Nix REPL - run manually to load flake: `:lf .`
repl:
  nix repl

# -----------------------------------------------
# Cleanup Commands
# -----------------------------------------------

# Cleanup commands (organized by aggressiveness)

# Quick cleanup - keep 5 generations (safe)
cleanup-quick:
  @echo "[INFO] Running quick cleanup (keeping 5 generations)..."
  nh clean all --keep 5
  @echo "[SUCCESS] Quick cleanup completed"

# Smart cleanup - keep 3 generations (recommended for regular use)
cleanup-smart:
  @echo "[INFO] Running smart cleanup (keeping 3 generations)..."
  nh clean all --keep 3 || { echo "[ERROR] Smart clean failed"; exit 1; }
  sudo nix store optimise || { echo "[ERROR] Store optimization failed"; exit 1; }
  @echo "[SUCCESS] Smart cleanup completed"

# Deep cleanup - aggressive (use with caution)
cleanup-deep:
  @echo "[WARNING] Running deep cleanup (keeping only current generation)..."
  nh clean all --keep 1 || { echo "[ERROR] Deep clean failed"; exit 1; }
  sudo nix-collect-garbage --delete-older-than 30d || { echo "[ERROR] Garbage collection failed"; exit 1; }
  @echo "[SUCCESS] Deep cleanup completed"

# Dry run to see what would be cleaned
cleanup-dry:
  @echo "[INFO] Dry run - showing what would be cleaned..."
  nh clean all --keep 3 --dry

# Legacy cleanup alias (points to smart cleanup as default)
cleanup: cleanup-smart

# Encode secrets
encode:
  sops -e secrets.yaml > secrets.enc.yaml

# Decode secrets
decode:
  sops -d secrets.enc.yaml > secrets.yaml

# Check when inputs were last updated
age:
  check-age

# -----------------------------------------------
# Experiments & Development
# -----------------------------------------------

# Show the current changes
diff:
  @echo "Showing changes to Nix configuration..."
  git diff -U0 --color=always .

# Legacy format alias (redirects to fmt)
format:
  @echo "[INFO] Running legacy format command (redirecting to fmt)..."
  just fmt

# Create a commit with generation number
commit:
  # Create a descriptive commit message and commit
  @gen_number=$(sudo nixos-rebuild list-generations 2>/dev/null | awk '/True/ {print $1}' | tail -1) || gen_number="unknown"; \
  @commit_msg="chore(nixos): apply generation $gen_number"; \
  echo "Committing changes with message: '$commit_msg'"; \
  git commit -am "$commit_msg" || { echo "[WARNING] Commit failed or no changes to commit"; exit 0; }

# Buffed nixos-rebuild switch - depends on format, switch, and commit
buffedswitch: format switch commit
  @echo "Done."

# -----------------------------------------------
# Utility Scripts
# -----------------------------------------------

# Quick system status check
status:
  @echo "[INFO] System Status Summary"
  sudo nixos-rebuild list-generations | tail -3
  @echo "---"
  @sudo nix-store --verify --check-contents --dry-run 2>/dev/null && echo "[SUCCESS] Nix store integrity: OK" || echo "[WARNING] Nix store verification failed or requires repair"
  @echo "[SUCCESS] Status check completed"

# Run a complete development workflow: format code, run tests, and dry-run the build
dev: fmt test dry

# Perform a quick security audit of the flake without building anything
audit:
  nix flake check --no-build --no-eval-cache

# Display detailed system information including Nix version and platform details
info:
  nix-shell -p nix-info --run "nix-info -m"

# Build the system configuration without applying it, then show differences from current system
backup:
  sudo nixos-rebuild build --flake .#nixos
  sudo nix store diff-closures /run/current-system ./result

# Safely edit encrypted secrets using SOPS (Secrets OPerationS)
edit-secrets:
  sops secrets.yaml

# Validate that the encrypted secrets file can be decrypted successfully
validate-secrets:
  @echo "[INFO] Validating secrets..."
  sops -d secrets.enc.yaml > /dev/null && echo "[SUCCESS] Secrets are valid" || { echo "[ERROR] Secrets validation failed"; exit 1; }

# Rotate the encryption key for secrets (use if keys are compromised)
rotate-secrets:
  sops --rotate secrets.yaml

# Check the integrity of the Nix store and run 'nix config check' for system health
health:
  @echo "[INFO] Running system health checks..."
  sudo nix-store --verify --check-contents
  nix config check
  @echo "[SUCCESS] Health checks completed"

# Calculate the total disk space used by the current system configuration
disk-usage:
  sudo nix-store --query --disk-usage $(sudo nix-store -q --requisites /run/current-system)

# Legacy aliases for backward compatibility
smart-clean: cleanup-smart
deep-clean: cleanup-deep
nhclean: cleanup-quick
nhcleandry: cleanup-dry
gc: cleanup-deep

