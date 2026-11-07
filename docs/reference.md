# Configuration Reference

This document provides a comprehensive reference for the NixOS configuration framework.

## Directory Structure

```
nixos-config/
├── docs/               # Documentation
│   ├── installation.md    # Installation guide
│   ├── reference.md       # This reference guide
│   ├── programs.md        # Program configurations
│   └── secrets_management.md  # Secrets management guide
├── home/               # Home Manager configurations
│   ├── core/              # Shared home modules
│   ├── profiles/          # Development/gaming profile modules
│   ├── default.nix        # Development entrypoint
│   ├── gaming.nix         # Gaming entrypoint
│   └── programs/          # Individual program configurations
│       ├── bash.nix
│       ├── brave.nix
│       ├── foot.nix
│       ├── firefox.nix
│       ├── helix.nix
│       ├── kitty.nix
│       ├── niri.nix
│       ├── stylix.nix
│       ├── yazi.nix
│       └── deprecated/    # Old configs kept out of imports
├── hosts/              # Host-specific configurations
│   ├── dora/           # GNOME policy; install configuration waits for target hardware
│   │   ├── default.nix           # GNOME host configuration
│   │   └── desktop.nix           # GNOME desktop policy
│   └── jokyv/         # Current host files
│       ├── default.nix           # Main host configuration
│       ├── hardware-configuration.nix  # Hardware settings
│       └── zsa-udev-rules.nix    # Custom udev rules
├── disks/              # Disk configurations (shared across hosts)
│   ├── universal-config.nix    # Shared disko module
│   ├── disk-config-btrfs-luks.nix  # Legacy Btrfs+LUKS config
│   └── disk-config-btrfs.nix       # Legacy Btrfs config
├── install/            # Install-only config for disko
│   ├── default.nix      # Install wrapper
│   └── jokyv.nix        # Jokyv install settings
├── flake.nix          # Main flake configuration
├── flake.lock         # Locked dependency versions
├── justfile          # Task automation commands
└── secrets.enc.yaml  # Encrypted secrets
```

## Core Configuration Files

### flake.nix

The main flake configuration defines:

- Nixpkgs inputs and dependencies
- System configurations
- Home Manager configurations
- Development shells
- Custom packages

Key sections:

- `inputs`: Define external dependencies (nixpkgs, home-manager, etc.)
- `outputs`: Define system configurations, packages, and development tools

### Host Configuration (`hosts/*/default.nix`)

Each host configuration includes:

- System-level settings
- Hardware configurations
- Service definitions
- User configurations
- Import statements for modular components

### Machine Matrix

| Host    | User    | Role                                      | Runtime output | Install output    |
| ------- | ------- | ----------------------------------------- | -------------- | ----------------- |
| `nixos` | `jokyv` | main desktop                              | `.#nixos`      | `.#jokyv-install` |
| `dora`  | `dora`  | GNOME policy; target hardware unavailable | Not available  | Not available     |

### Host, User, and Output Naming

- **Hostnames:** Use short, lowercase, role-based or person-based names, such as `atlas` or `dora`. Set the machine name with `networking.hostName`.
- **Usernames:** Use lowercase, stable login names. A personal host normally has one primary user; shared machines can have multiple users. Hostname and username may match, as with `dora`, but do not have to: a user keeps the same login name across differently named hosts.
- **New host paths and outputs:** Use the hostname for `hosts/<host>/`, runtime output `nixosConfigurations.<host>`, install settings `install/<host>.nix`, and install output `nixosConfigurations."<host>-install"`. Select the outputs with `.#<host>` and `.#<host>-install`. Here `<host>` means the hostname, not the username.

Existing names are preserved. The main desktop is the exception: hostname and runtime output `nixos`, primary user `jokyv`, host files in `hosts/jokyv/`, install settings `install/jokyv.nix`, and install output `jokyv-install`. This policy does not rename any of them. Dora currently has policy files in `hosts/dora/` but no runtime or install flake output; `dora-install` is a future name, not an available output.

For example, a future personal host named `atlas` with primary user `jokyv` would use:

| Setting          | Example                                                                |
| ---------------- | ---------------------------------------------------------------------- |
| Hostname         | `networking.hostName = "atlas";`                                       |
| Primary user     | `users.users.jokyv`                                                    |
| Host policy      | `hosts/atlas/default.nix`                                              |
| Runtime output   | `nixosConfigurations.atlas`, selected with `.#atlas`                   |
| Install settings | `install/atlas.nix`                                                    |
| Install output   | `nixosConfigurations."atlas-install"`, selected with `.#atlas-install` |

This is a naming example, not a currently declared host. Follow [New host setup](installation.md#new-host-setup) to provision it.

### Gaming Optimizations

System-level gaming performance is configured in `hosts/jokyv/default.nix`:

- **GameMode daemon** (`programs.gamemode`): Automatic CPU/IO prioritization when games run
- **PipeWire low‑latency** (`services.pipewire.extraConfig`): 48kHz clock, 256‑sample quantum, RTKit with high priority
- **Steam hardware** (`hardware.steam-hardware.enable`): udev rules for controllers, VR, Steam Deck support
- **Kernel tuning** (`boot.kernelParams`, `boot.kernel.sysctl`): `nowatchdog`, `split_lock_detect=off`, `vm.max_map_count`, `vm.swappiness`, etc.
- **AMD CPU** (`nixos-hardware.nixosModules.common-cpu-amd-pstate`): Optimal power management and performance

User‑level gaming packages (Steam, Wine, MangoHUD) and environment variables are managed by Home Manager `home/gaming.nix` and activated via `just game`.

### Home Manager (`home/`)

Home configurations manage:

- User-level packages
- Dotfiles and configurations
- Program settings
- Environment variables
- Development tools

## Common Configuration Patterns

### Module System

Use imports to organize configurations:

```nix
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/desktop.nix
  ];
}
```

### Package Management

Add system packages:

```nix
environment.systemPackages = with pkgs; [
  git
  vim
  firefox
];
```

Add user packages via Home Manager:

```nix
home.packages = with pkgs; [
  helix
  kitty
  cargo
];
```

### Service Configuration

Enable and configure system services:

```nix
services = {
  xserver.enable = true;
  printing.enable = true;
  pipewire = {
    enable = true;
    alsa.enable = true;
  };
};
```

### Theming with Stylix

Configure system-wide theming:

```nix
stylix = {
  enable = true;
  base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  image = ../../wallpapers/nix.png;
  fonts = {
    monospace = {
      package = pkgs.nerdfonts;
      name = "FiraCode Nerd Font";
    };
  };
};
```

## Justfile Commands

The project includes a justfile for common tasks:

- `just switch`: Rebuild system configuration
- `just home`: Apply Home Manager configuration (development mode)
- `just game`: Apply Home Manager configuration (gaming mode)
- `just up`: Update system packages
- `just cleanup`: Smart cleanup (keep 3 generations)
- `just encode`: Encrypt secrets
- `just decode`: Decrypt secrets
- `just audit`: Run flake, dead-code, and Nix lint checks

## Repository Development Shell

Enter repo-scoped maintenance tools with:

```bash
nix develop
```

Available tools:

- `nixfmt`: Format Nix files
- `nixd`: Nix language server used by Helix (installed through Home Manager)
- `deadnix`: Find unused Nix declarations
- `statix`: Check Nix style and suggestions
- `nix-diff`: Compare derivations
- `nix-index`: Search package contents
- `nix-prefetch-git`: Prefetch Git sources and hashes
- `nix-output-monitor` (`nom`): Improve Nix build output
- `just`: Run repository tasks

One-shot usage works without entering an interactive shell:

```bash
nix develop --command deadnix --fail .
nix develop --command statix check
```

Fix commands modify files. Review changes before continuing:

```bash
nix develop --command deadnix --edit .
nix develop --command statix fix .
git diff
```

### CI Validation

[The GitHub Actions workflow](../.github/workflows/check.yml) runs `nix develop --command just test` on pushes and pull requests using an x86_64 Linux runner. It reuses the local test recipe to check the NixOS host and installer outputs and evaluate both Home Manager profiles.

CI accepts the flake's Nix settings non-interactively. It does not activate configurations or require the private SOPS AGE key. Evaluation checks do not verify boot or desktop runtime behavior.

## Secrets Management

The configuration uses sops-nix for encrypted secrets:

1. Edit secrets: `sops secrets.enc.yaml`
2. Generate keys: `age-keygen -o ~/.config/sops/age/secrets.key`
3. Access in configuration: `config.sops.secrets.<secret-name>.path`

## Development Workflow

1. Make one small configuration change in Helix.
2. Save; Helix runs `nixfmt` automatically for Nix files. `nixd` reports editor diagnostics.
3. Run targeted static checks:

   ```bash
   nix develop --command deadnix --fail .
   nix develop --command statix check
   ```

4. Review or fix findings. Do not run auto-fixes blindly across the repository.
5. Run the flake check:

   ```bash
   nix flake check --no-build
   ```

6. Apply only after checks pass: `just switch` or `just home`. `just audit` runs the same static checks as one command; it currently reports existing repository lint debt that must be fixed incrementally.
7. If system activation fails, inspect the exact failed unit before retrying.
8. Review `git diff`, then commit with semantic commit message.
9. Update changelog for significant changes.

## Troubleshooting

### Common Issues

1. **Build failures**
   - Check nix options: `nix options`
   - Verify flake inputs: `nix flake update`
   - Clean build: `just clean`

2. **Secrets not decrypting**
   - Verify key file permissions
   - Check sops configuration
   - Ensure age key is available

3. **Hardware detection**
   - Review `hardware-configuration.nix`
   - Check kernel modules
   - Verify firmware availability

### Useful Commands

```bash
# Check flake outputs
nix flake show

# Test configuration
nixos-rebuild test --flake .#hostname

# Search packages
nix search nixpkgs package-name

# Garbage collect
nix-collect-garbage -d
```

## Contributing

When contributing to the configuration:

1. Follow semantic commit messages
2. Update relevant documentation
3. Test changes thoroughly
4. Maintain backward compatibility where possible
5. Keep configurations modular and reusable
