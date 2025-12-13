# NixOS Configuration Framework Documentation

Welcome to the documentation for this modern NixOS configuration framework featuring declarative system management with Wayland, sops-nix, and unified theming.

## Quick Start

### Prerequisites
- NixOS system with flakes enabled
- Basic familiarity with Nix
- Age encryption key for secrets

### Installation
1. Clone this repository
2. Follow the [Installation Guide](installation.md) for detailed steps
3. Apply configuration: `nixos-rebuild switch --flake .#hostname`

### Key Commands
```bash
# Update system
just up

# Rebuild configuration
just switch

# Apply home-manager changes
just home

# Manage secrets
just encode    # Encrypt secrets
just decode    # Decrypt secrets
```

## Documentation

### Core Guides
- **[Installation Guide](installation.md)** - Complete setup instructions
- **[Configuration Reference](reference.md)** - Detailed configuration reference
- **[Program Configurations](programs.md)** - Configured programs and settings
- **[Secrets Management](secrets_management.md)** - Managing encrypted secrets

### Configuration Overview

This framework provides:

- **Declarative System** - Entire system defined in Nix
- **Modern Desktop** - Wayland with Niri compositor
- **Unified Theming** - Stylix for consistent appearance
- **Secret Management** - Encrypted configuration with sops-nix
- **Development Ready** - Pre-configured development environment
- **Reproducible** - Flakes ensure reproducible builds

## Architecture

```
nixos-config/
├── docs/               # Documentation (you are here)
├── home/               # Home Manager configurations
├── hosts/              # Host-specific settings
├── flake.nix          # Main configuration entrypoint
├── justfile          # Common tasks automation
└── secrets.enc.yaml  # Encrypted secrets
```

## Key Features

### Desktop Environment
- **Display Protocol**: Wayland for modern graphics
- **Window Manager**: Niri tiling compositor
- **Terminal**: Kitty/Foot with full Unicode support
- **Editor**: Helix with LSP integration
- **Browser**: Firefox with privacy settings

### Development Stack
- **Languages**: Nix, Rust, Python, Go, JavaScript
- **Tools**: Git, Cargo, UV, Node.js
- **LSP**: Complete language server setup
- **Version Control**: Git with Delta diff viewer

### System Management
- **Package Management**: Nix Flakes + Home Manager
- **Security**: sops-nix with AGE encryption
- **Theming**: Stylix unified theming
- **Automation**: Justfile for common tasks

## Getting Help

### Troubleshooting
- Check the [Configuration Reference](reference.md) for common issues
- Review logs with `journalctl -xe`
- Test configurations with `nix flake check`

### Community
- [NixOS Discourse](https://discourse.nixos.org/)
- [NixOS Wiki](https://wiki.nixos.org/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)

## Contributing

This configuration follows semantic versioning and conventional commits.

When contributing:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](../LICENSE) file for details.

---

*Built with ❤️ using NixOS*