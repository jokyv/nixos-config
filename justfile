set shell := ["bash", "-euo", "pipefail", "-c"]
[no-cd]
set positional-arguments

default:
  @just --list

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
  home-manager switch -b backup --flake .#jokyv --show-trace || { echo "Home Manager switch failed"; exit 1; }

# Rebuild the home config using nh
nhh:
  nh home switch -c jokyv .

# -----------------------------------------------
# NixOS specific
# -----------------------------------------------

# Rebuild the system
switch:
  sudo nixos-rebuild switch --impure --flake .#nixos --show-trace

# Rebuild the system using nh
nhs:
  nh os switch .

# Build a new configuration
boot:
  sudo nixos-rebuild boot --fast --impure --flake .#nixos --show-trace

# Dry-build a new configuration
dry:
  sudo nixos-rebuild dry-activate --fast --flake .#nixos --show-trace

# Format code
fmt:
  nix fmt

# Run tests
test:
  nix flake check --show-trace --print-build-logs --verbose

# Update all inputs
up:
  nix flake update --refresh --commit-lock-file

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
  @echo "Formatting Nix files with nix fmt..."
  nix fmt

# Create a commit with generation number
commit:
  @gen_number=$(nixos-rebuild list-generations | awk '/True/ {print $1}')
  git commit -am "chore(nixos): apply generation $gen_number"

# Buffed nixos-rebuild switch - depends on format, switch, and commit
buffedswitch: format switch commit
  @echo "Done."
    
# -----------------------------------------------
# Old commands
# -----------------------------------------------
