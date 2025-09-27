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

# Define a task to install Home Manager
install:
  echo "Installing Home Manager..."
  nix-shell '<home-manager>' -p home-manager --run "home-manager switch"

# Define a task to update Home Manager
# update:
#     echo "Updating Home Manager..."
#     nix-channel --update
#     nix-shell '<home-manager>' -p home-manager --run "home-manager switch"

# Define a task to apply Home Manager configuration
apply:
  echo "Applying Home Manager configuration..."
  nix-shell '<home-manager>' -p home-manager --run "home-manager switch"

# Define a task that runs install, update, and apply
# all: install update apply
#     echo "Home Manager setup complete!"

# Define a task to clean up old generations
clean:
  echo "Cleaning up old generations..."
  nix-collect-garbage --delete-older-than 7d

# Rebuild the home config
home:
  @echo "[INFO] Rebuilding Home Manager configuration..."
  home-manager switch -b backup --flake .#jokyv --show-trace || { echo "[ERROR] Home Manager switch failed"; exit 1; }
  @echo "[SUCCESS] Home Manager rebuild successful"

# Rebuild the home config using nh
nhh:
  nh home switch -c jokyv .

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

# Clean up with the help of nh
nhclean:
  nh clean all --keep 5

# Clean up with the help of nh but dry run
nhcleandry:
  nh clean all --keep 5 --dry

# Remove all generations older than 7 days
cleanup:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d

# Garbage collect all unused nix store entries
gc:
  # sudo nix store gc --debug
  sudo nix store gc
  nix-collect-garbage --delete-old
  sudo nix-collect-garbage --delete-old

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
# Experiments
# -----------------------------------------------

# Show the current changes
diff:
  @echo "Showing changes to Nix configuration..."
  git diff -U0 --color=always .

# Format the configuration files using the standard Nix formatter
format:
  @echo "Formatting Nix files with nixpkgs-fmt..."
  nixpkgs-fmt .

# Create a commit with generation number
commit:
  # Create a descriptive commit message and commit
  @gen_number=$(sudo nixos-rebuild list-generations | awk '/True/ {print $1}'); \
  @commit_msg="chore(nixos): apply generation $gen_number"; \
  echo "Committing changes with message: '$commit_msg'"; \
  git commit -am "$commit_msg"

# Buffed nixos-rebuild switch - depends on format, switch, and commit
buffedswitch: format switch commit
  @echo "Done."

# -----------------------------------------------
# Utility Scripts
# -----------------------------------------------

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

# Smart cleanup that preserves recent generations while removing older ones
smart-clean:
  nh clean all --keep 3 || { echo "[ERROR] Smart clean failed"; exit 1; }
  sudo nix store optimise || { echo "[ERROR] Store optimization failed"; exit 1; }

# Remove only very old generations (more aggressive cleanup)
deep-clean:
  nh clean all --keep 1 || { echo "[ERROR] Deep clean failed"; exit 1; }
  sudo nix-collect-garbage --delete-older-than 30d || { echo "[ERROR] Garbage collection failed"; exit 1; }

# Generate documentation from the flake (if available)
docs:
  nix build .#docs
  find result/share/doc -name "*.html" | head -5
