# NixOS Configuration - AI Assistant Context

## Project Overview

Personal NixOS configuration using flakes and home-manager for declarative system management.

## Key Technologies

- **NixOS** - Linux distribution with declarative configuration
- **Home Manager** - User-level package and config management
- **Niri** - Scrollable-tiling Wayland compositor
- **sops-nix** - Secrets management with AGE encryption
- **Stylix** - Unified theming

## Configuration Modes

Two home-manager configurations available:

| Mode | Command | Description |
|------|---------|-------------|
| Work | `just home` or `home-manager switch --flake .#jokyv` | Full development setup |
| Gaming | `just game` or `home-manager switch --flake .#gaming` | Minimal + Steam |

## Project Structure

```
.
├── flake.nix              # Main flake with NixOS and home-manager outputs
├── hosts/jokyv/           # NixOS system configuration
│   └── default.nix        # Main system config (hardware, users, services)
├── home/                  # Home-manager configurations
│   ├── default.nix        # Work mode (full dev setup)
│   ├── gaming.nix         # Gaming mode (minimal + Steam)
│   ├── env.nix            # Environment variables
│   └── programs/          # Individual program configs
│       ├── claude.nix     # Claude AI assistant config
│       ├── claude/        # Claude commands & skills
│       │   ├── commands/  # Custom slash commands
│       │   └── skills/    # Custom skills
│       ├── niri.nix       # Window manager
│       ├── waybar.nix     # Status bar
│       └── ...            # Other programs
├── secrets.enc.yaml       # Encrypted secrets (sops)
└── justfile               # Task runner commands
```

## Common Commands (justfile)

```bash
just home          # Rebuild work home-manager config
just game          # Switch to gaming mode
just switch        # Rebuild NixOS system (requires sudo)
just up            # Update all flake inputs
just cleanup       # Smart cleanup (keep 3 generations)
just encode        # Encrypt secrets
just decode        # Decrypt secrets
```

## NixOS System Rebuild

```bash
sudo nixos-rebuild switch --flake .#nixos
```

## Recent Updates (2026-02-17)

- **Claude commands restructure**: Unified workflow commands
  - `/work-setup` - Project initialization and environment setup
  - `/work-prime` - Context priming for better AI understanding
  - `/work-maintain` - Project maintenance (security scan, cleanup)
  - `/work-sync-docs` - Unified doc sync (merged from update-claudemd/update-docs)
  - Existing: `work-git-commit`, `work-issue`, `work-release-notes`
- **Security integration**: `work-maintain` now includes `trivy` filesystem scan

### Previous (2026-02-15)
- **Gaming mode**: New `home/gaming.nix` with minimal config + Steam
- **32-bit graphics**: Enabled `hardware.graphics.enable32Bit` for Steam
- **XDG fix**: Updated deprecated `XDG_PROJECTS_DIR` to `PROJECTS`

## Notes for AI Assistants

- This is a NixOS config project, not a typical application
- Changes to `flake.nix` affect both system and home-manager outputs
- System-level changes (hardware, kernel) require `sudo nixos-rebuild`
- User-level changes use `home-manager switch`
- Secrets are encrypted with sops-nix - never commit decrypted `secrets.yaml`
