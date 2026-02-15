# NixOS Configuration Framework

**Next-gen Declarative System Configuration**\
![NixOS](https://img.shields.io/badge/NixOS-26.05-blue.svg)
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

## Project Structure

For a complete overview of the project structure and configuration files, see the **[Configuration Reference](docs/reference.md)**.

This documentation provides detailed explanations of:

- Directory structure and file organization
- Configuration hierarchy
- Centralized disk configurations
- Host-specific settings
- Home Manager modules

## Key Features

- **Universal Installer:** Auto-detects first disk with configurable filesystems (Btrfs/Ext4) and LUKS encryption
- **Declarative Configuration:** Entire system state defined in Nix expressions
- **Reproducible Builds:** Deterministic package management
- **Atomic Upgrades:** Rollback support for system changes
- **Secrets Management:** Encrypted credentials with sops-nix
- **Unified Theming:** Consistent appearance across all applications
- **Modern Workflow:** Wayland-based desktop with tiling window management

## Documentation 📚

Complete documentation is available in the [`docs/`](docs/) directory:

- **[Installation Guide](docs/installation.md)** - Step-by-step setup instructions
- **[Configuration Reference](docs/reference.md)** - Detailed configuration guide
- **[Program Configurations](docs/programs.md)** - Configured programs and settings
- **[Secrets Management](docs/secrets_management.md)** - Managing encrypted secrets

> **GitHub Pages**: Documentation is also available as a hosted website at https://jokyv.github.io/nixos-config/

## Getting Started

1. **Prerequisites:**
   - NixOS installation
   - Flakes support enabled
   - Age encryption keys configured

2. **Installation:**
   - See the [Installation Guide](docs/installation.md) for detailed steps
   ```bash
   nixos-rebuild switch --flake .#nixos
   ```

3. **Home Manager Setup:**

   Two configuration modes are available:

   | Mode | Command | Description |
   |------|---------|-------------|
   | **Work** (default) | `just home` or `home-manager switch --flake .#jokyv` | Full development setup with all tools |
   | **Gaming** | `just game` or `home-manager switch --flake .#gaming` | Minimal config with Steam |

4. **Common Tasks:**
   - Update system: `just up`
   - Rebuild configuration: `just switch`
   - Manage secrets: `just encode` / `just decode`

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
