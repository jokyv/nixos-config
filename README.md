# NixOS Configuration Framework

**Next-gen Declarative System Configuration**  
![NixOS](https://img.shields.io/badge/NixOS-24.05-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

A complete NixOS ecosystem featuring modern Linux desktop capabilities with declarative configuration management.

## Featured Stack
### Core Components
- **Display Protocol:** Wayland
- **Compositor:** [Niri](https://github.com/YaLTeR/niri) (Scrollable-tiling Wayland compositor)
- **Security:** sops-nix with AGE encryption
- **Theming:** Stylix unified theming engine
- **Package Management:** Nix Flakes + Home Manager

### Development Ecosystem
- **Language Servers:** Nixd, Rust-analyzer, Python-LSP, Markdown Oxide
- **Version Control:** Git with Delta diff viewer
- **Shell Environments:** Nushell, Bash, Xonsh
- **Package Management:** UV (Python), Cargo (Rust)

### Desktop Environment
- **Terminals:** Kitty, Foot
- **Editors:** Helix (Modern Vim alternative)
- **Browsers:** Firefox, Brave
- **File Management:** Nautilus, Yazi (Terminal file manager)
- **Productivity:** Obsidian, Zathura (PDF viewer)
- **System Utilities:** Waybar, Fuzzel (App launcher), Cliphist (Clipboard manager)

## Configuration Structure
```
nixos-config/
├── CHANGELOG.md
├── LICENSE
├── README.md
├── dprint.json
├── flake.lock
├── flake.nix
├── home/               # Home Manager configurations
│   ├── default.nix
│   ├── env.nix
│   └── programs/       # Individual program configurations
├── hosts/              # Host-specific configurations
│   └── jokyv/
│       ├── default.nix
│       ├── hardware-configuration.nix
│       └── zsa-udev-rules.nix
├── justfile            # Task automation
└── secrets.enc.yaml    # Encrypted secrets
```

## Key Features
- **Declarative Configuration:** Entire system state defined in Nix expressions
- **Reproducible Builds:** Deterministic package management
- **Atomic Upgrades:** Rollback support for system changes
- **Secrets Management:** Encrypted credentials with sops-nix
- **Unified Theming:** Consistent appearance across all applications
- **Modern Workflow:** Wayland-based desktop with tiling window management

## Getting Started
1. **Prerequisites:**
   - NixOS installation
   - Flakes support enabled
   - Age encryption keys configured

2. **Installation:**
   ```bash
   nixos-rebuild switch --flake .#nixos
   ```

3. **Home Manager Setup:**
   ```bash
   home-manager switch --flake .#jokyv
   ```

4. **Common Tasks:**
   - Update system: `just up`
   - Rebuild configuration: `just switch`
   - Manage secrets: `just encode` / `just decode`

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
