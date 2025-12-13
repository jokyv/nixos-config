# Program Configurations

This document describes the configured programs and their customizations in this NixOS configuration.

## Development Tools

### Helix Editor

Helix is configured as the primary text editor with modern features:

- Language servers integration for multiple languages
- Tree-sitter syntax highlighting
- Modal editing experience
- Built-in file explorer and fuzzy finder

Configuration location: `home/programs/editor.nix`

### Terminal Emulators

#### Kitty

Modern, GPU-accelerated terminal emulator with:
- True color support
- Font ligatures
- Tabs support
- Remote control capabilities

#### Foot

Lightweight Wayland-native terminal with:
- Minimal resource usage
- Wayland integration
- Scrollback buffer
- URL detection

### Shells

#### Nushell

Modern shell with structured data support:
- Built-in data manipulation commands
- JSON/YAML support
- Auto-completion
- Syntax highlighting

#### Bash

Default shell with customizations:
- Custom prompt
- Useful aliases
- Auto-completion enhancements

## Development Environment

### Version Control

#### Git

Configured with:
- Delta diff viewer for better diffs
- Custom aliases for common operations
- GPG signing support
- Credential caching

### Language Support

#### Nix

- Nixd language server for Nix files
- Automatic formatting with nixfmt
- Flake completion and validation

#### Rust

- Rust-analyzer LSP
- Cargo package manager
- Rustfmt formatting
- Clippy linting

#### Python

- Python LSP server
- UV package manager
- Black code formatter
- isort import sorting

#### Other Languages

- Node.js for JavaScript/TypeScript
- Go for Go development
- Java support
- PHP support

## Desktop Applications

### Web Browsers

#### Firefox

Configured with:
- Privacy-enhancing settings
- Custom extensions
- Hardware acceleration
- Theme integration

#### Brave

Privacy-focused browser with:
- Ad-blocking
- Crypto wallet
- Brave rewards
- Sync support

### File Management

#### Nautilus

GNOME file manager with:
- Thumbnail previews
- Archive support
- Network filesystem support
- Extensions support

#### Yazi

Terminal file manager with:
- TUI interface
- Image preview
- Fuzzy finding
- Vim-like keybindings

### Communication

#### Discord

Desktop client with:
- Voice chat
- Screen sharing
- Rich presence
- Custom themes

## System Utilities

### System Monitoring

#### Htop

Process viewer with:
- Color-coded metrics
- Tree view
- Resource monitoring
- Customizable display

#### Btop

Modern system monitor with:
- Real-time graphs
- Battery status
- Network usage
- Temperature monitoring

### Clipboard Management

#### Cliphist

Clipboard history manager:
- Persistent history
- Image support
- Keyboard shortcuts
- Privacy options

### Application Launcher

#### Fuzzel

Wayland-native launcher with:
- Fuzzy finding
- Custom themes
- Keyboard navigation
- Application icons

## Multimedia

### Audio

#### PipeWire

Low-latency audio server with:
- Professional audio support
- Bluetooth audio
- Network streaming
- JACK compatibility

### Video

#### MPV

Video player with:
- Hardware acceleration
- High-quality scaling
- Subtitle support
- Custom configuration

## Security Tools

### Password Management

#### KeePassXC

Cross-platform password manager:
- Encrypted database
- Auto-type
- Browser integration
- TOTP support

### Encryption

#### Age

Modern file encryption:
- Ed25519 keys
- SSH key support
- Simple usage
- Secure defaults

## Automation

### Task Runner

#### Just

Command runner with:
- Justfile syntax
- Command aliases
- Shell integration
- Cross-platform support

## Customization

### Theming

All programs are configured to use the unified theme from Stylix:
- Consistent colors across applications
- Dark/light mode support
- Custom color schemes
- Font configuration

### Keybindings

Consistent keybindings across applications where applicable:
- Vim-style in terminal applications
- Custom shortcuts for window management
- Browser navigation shortcuts
- System-wide hotkeys

## Configuration Management

Program configurations are modularized in `home/programs/`:

- `browser.nix` - Web browser settings
- `editor.nix` - Text editor configuration
- `terminal.nix` - Terminal emulator settings
- `shell.nix` - Shell configuration
- `media.nix` - Multimedia applications
- `development.nix` - Development tools
- `system.nix` - System utilities

Each module can be imported independently and customized per host or user.

## Adding New Programs

To add a new program:

1. Create a new file in `home/programs/` if it doesn't exist
2. Add the program configuration
3. Import the module in `home/default.nix`
4. Test with `home-manager switch --flake .#hostname`
5. Commit changes with a descriptive message

Example:

```nix
# home/programs/new-program.nix
{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [ new-program ];

  programs.new-program = {
    enable = true;
    settings = {
      # Configuration options
    };
  };
}
```