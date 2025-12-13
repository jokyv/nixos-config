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
│   ├── default.nix        # Main home configuration
│   ├── env.nix           # Environment variables
│   └── programs/         # Individual program configurations
│       ├── browser.nix
│       ├── editor.nix
│       ├── terminal.nix
│       └── ...
├── hosts/              # Host-specific configurations
│   └── jokyv/          # Host-specific files
│       ├── default.nix           # Main host configuration
│       ├── hardware-configuration.nix  # Hardware settings
│       └── zsa-udev-rules.nix    # Custom udev rules
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
- `just home`: Apply Home Manager configuration
- `just up`: Update system packages
- `just encode`: Encrypt secrets
- `just decode`: Decrypt secrets
- `just clean`: Clean build artifacts

## Secrets Management

The configuration uses sops-nix for encrypted secrets:

1. Edit secrets: `sops secrets.enc.yaml`
2. Generate keys: `age-keygen -o ~/.config/sops/age/secrets.key`
3. Access in configuration: `config.sops.secrets.<secret-name>.path`

## Development Workflow

1. Make configuration changes
2. Test locally: `nix flake check`
3. Apply changes: `just switch` or `just home`
4. Commit changes with semantic commit messages
5. Update changelog for significant changes

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