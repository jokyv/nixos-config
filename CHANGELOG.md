## [0.6.0] - 2025-12-12

### 🚀 Features

- *(disks)* Isolate /nix and /tmp filesystems
- Enhance Brave browser with performance and privacy flags
- Improve fnott configuration with timeouts and shortcuts
- Enhance fuzzel with keybindings and dmenu mode
- Enhance gammastep with tray, notifications, and fade
- *(jokyv)* Isolate /var on a separate subvolume
- Enable bluetooth and pipewire jack/32-bit alsa support
- Add animation and visual enhancement settings to niri config
- Add workspace config and enhanced layout settings
- Update niri animations to use new kind format
- Add secure mount options for boot partition
- Add workspace-specific window rules and quick access keybindings
- Add dysk to home packages
- Add LUKS config file and clean up disk config
- Add tmpfs mount for /tmp with 4G size
- Add defaults and mode=1777 to tmpfs mount options
- Add disko for disk configuration management
- Sync luks disk config with unencrypted version
- Switch to black metal bathory theme
- Override base03 color with #556677
- Add flake-freshness script for monitoring package versions
- Support package tracking across all flake inputs
- Add auto-detection of packages from flake outputs
- *(health)* Add input age check to flake health script
- Replace polars with rich for better table formatting
- Update bash aliases and add Python packages
- Sort outdated packages first in table
- Make flake health script executable and path-aware
- Pin libreoffice to stable nixpkgs channel
- *(niri)* Add layer rule for swww wallpaper
- Add devenv and direnv to home-manager configuration
- Chain diffastic with delta for refined word-level diffs
- Configure difft as external git diff tool
- Add development tools and improve system configuration
- *(niri)* Remap `${mod}+${shift}+W` to toggle wallpaper update loop
- Update niri config with new settings and keybindings
- Add Vicinae launcher and update system configuration

### 🐛 Bug Fixes

- Use absolute path for SOPS_AGE_KEY_FILE
- Qualify spawn helper functions with full path
- Correct workspaces.names from list to attribute set
- Correct workspaces.names from attrset to list
- Remove invalid workspaces.names list to resolve config error
- Correct fnott notification timeout values
- Correct generation commands and improve flake comments
- Correct btrfs quota config and fix mount option typo
- Remove invalid disko quota config and add btrfs quota service
- Disable btrfs quota setup and fix automatic scrub interval
- Correct niri actions references in niri.nix
- Use config.niri.actions instead of inputs.niri.actions
- Improve path handling and directory management for nix commands
- Update path to nix_flake_health script in justfile
- Migrate git options to new settings structure
- Pass pkgs-stable to home-manager configuration
- Align niri's nixpkgs-stable input to follow nixpkgs
- Remove niri nixpkgs-stable override to use unstable
- Replace glxinfo with mesa-demos
- Resolve zram compression algorithm conflict
- Quote systemd service name with @ symbol
- Use zram-generator module instead of manual systemd service
- Replace non-existent zram-generator with standard zramSwap
- Remove duplicate zramSwap config from services.nix
- Comment out layer-rules hiding wallpaper from normal view
- Correct devenv package reference in home-manager config
- Correct devenv package reference from default to devenv
- Update devenv package reference in flake.nix
- Update devenv installation method in flake.nix
- Correct devenv package reference from default to devenv
- Enable bash integration for direnv
- Use nixpkgs devenv to avoid broken cachix build
- Remove duplicate pager setting in git config
- Configure git pager to use diffastic piped to delta
- Add exec to git pager wrapper for proper pipe chain
- Replace hardcoded diff commands with nix store paths
- Correct difftastic binary name and add side-by-side delta
- Remove external diff driver setting from git config
- Wrap layer-rules in list for niri configuration
- Correct layer-rules matches format to use list structure
- Update script paths and add Python requests package

### 💼 Other

- *(home)* Improve and document program configurations
- Update
- Update
- Update
- Update
- Update
- Update
- Update
- Update
- Update
- Update
- Update
- Update
- Update
- Update
- Add AI assistant directories to ignores
- Update
- Update
- Update

### 🚜 Refactor

- Simplify fastfetch memory and binary prefix configuration
- Improve fd.nix configuration and add exec-batch option
- Configure foot for functional settings with Stylix
- Remove foot dpi-aware and gammastep notify settings
- Simplify fnott configuration by removing unused settings
- Use snake_case for niri config variables
- Add reusable spawn helpers for niri keybindings
- Organize keybindings by category
- Extract outputs and window rules into separate variables
- Extract startup applications into separate variable
- Simplify keybindings combination with sequential updates
- Use foldl to combine keybinding categories
- Improve niri config structure and simplify presets
- Remove duplicate workspace_quick_access keybindings
- Optimize swap and compression settings in disk config
- *(flake)* Use attribute sets for input definitions
- Use config.lib.niri.actions.spawn directly
- Reorganize disk config files and update stylix scheme paths
- Simplify package tracking to use single nixpkgs input
- Improve table formatting with polars and color legend
- Simplify script to only check packages from nixpkgs
- Remove auto-detection feature and simplify script
- Reorganize imports and improve code structure
- Replace individual python packages with python313.withPackages
- Rename variable in python package list
- Pass pkgs-stable via inherit instead of extraSpecialArgs
- Pass pkgs-stable via extraSpecialArgs in home config
- Separate unstable and stable packages into distinct sections
- Move diffastic from flake to home packages
- Drop difftastic and use delta side-by-side directly
- Switch Python LSP to ty and improve configuration
- Move python packages to home manager and improve health checks
- Consolidate Python packages using withPackages

### 📚 Documentation

- Update changelog for v0.5.0
- Add comments explaining inheritance patterns
- Add installation instructions
- Replace SSH clone URL with HTTPS in install guide
- Update disk config file path in installation instructions
- Add example for setting initial user password
- Switch clone command to SSH URL in install guide
- Update install guide and tweak niri config
- Update installation instructions and fix git clone URLs
- Add secrets management documentation

### ⚡ Performance

- *(nixos)* Use sd-switch to avoid restarting user services on rebuild

### 🎨 Styling

- Reformat nix files with nixfmt
- Reformat niri configuration with improved indentation
- Format niri config with consistent spacing
- Fix formatting in niri.nix
- Reformat code and update default flake path
- Align comment style in flake.nix
- Remove unused extraSpecialArgs comment from flake
- Reformat home.packages list for readability
- Adjust comment formatting for consistency

### ⚙️ Miscellaneous Tasks

- *(nixos)* Apply generation 123
- Update zoxide config for bash shell
- Remove unsupported border and shadow settings from niri config
- Remove unsupported focus-ring settings
- Reorganize niri workspace assignments and keybindings
- Increase swap size and comment out tmpfs config
- Updates since fresh installation
- Enable niri flake input
- Add niri flake inputs and update configuration
- Update package list in freshness.toml
- Update helix config and add niri package
- Remove nix flake health script and config
- Update nixpkgs-stable to nixos-25.05
- Dedupe nixpkgs-stable input for niri flake
- Update nixpkgs and home-manager to 25.05 branches
- Make niri follow nixpkgs-stable to avoid duplicate
- Comment out xwayland-satellite and update aider-chat comment
- Replace noto-fonts-emoji with color variant and add news command
- Remove redundant comment and whitespace from flake.nix
- Add devenv and fix difftastic typo in home config
- Add claude.nix file
- Started documentation for this repo
- *(yazi)* Rename manager to mgr in yazi settings
## [0.5.0] - 2025-10-06

### 🚀 Features

- *(niri)* Automatically pull nixos-config on startup
- Add systemd service for waybar
- Update niri config with input, layout, and startup improvements
- Add newline to waybar clock format
- Add niri config for window rules and overview zoom
- *(host)* Enable firewall, pipewire, and security hardening
- Add waybar to niri startup programs
- Add security hardening configurations to NixOS setup
- Enhance user config, security, packages and nix settings
- Reorganize nixos config with security improvements
- Enable OpenSSH and add Greek locale
- Enhance security and persistence settings
- Enhance system security with sudo config and root lock
- Add services configuration and remove duplicate SSH block
- *(jokyv)* Add declarative disk configuration with disko
- *(host)* Add ZRAM swap and LUKS encryption option
- Add obsidian and nh programs, update wayland env vars
- Add blueman and bluetooth configuration
- Enhance bluetooth security with privacy and timeout settings
- Enable blueman service for bluetooth
- *(justfile)* Add diff, format, and buffedswitch recipes
- Add error handling to home command
- Add utility scripts for NixOS development and maintenance
- Improve justfile recipes with error handling and sudo
- Add colorized output and better logging
- Add status command and improve justfile organization
- *(nixos)* Enable system maintenance and hardware features
- Add noctalia-shell configuration
- Add wallpaper configuration and enable noctalia bar

### 🐛 Bug Fixes

- Remove duplicate trusted-users setting from security.nix
- Remove trusted-users from nix settings and consolidate in security.nix
- Move bluetooth config from services to hardware module
- Replace octal escape sequences with tput for portable colors
- Replace variable prefixes with hardcoded text in justfile
- Correct shell variable handling in just recipes
- Revert commit command to working version
- Correct noctalia config for current user

### 💼 Other

- Update
- Update
- Update
- Update
- Update
- Update
- Update
- Update
- Update
- Update
- Update
- Update
- Update
- Update
- Update
- Update

### 🚜 Refactor

- *(home)* Simplify service definitions and organize packages
- Update waybar and sww configuration
- Update NixOS configuration with comments and cleanup
- Fix syntax and add lynis package
- Consolidate security settings into security.nix
- Reorganize security config and systemd settings
- Move security settings to appropriate config files
- Enable OpenSSH service and clean up comments
- Organize system packages into categorized sections
- Reorganize config sections and add network settings
- Move security services to dedicated module
- Improve config organization and consistency
- Move system services to dedicated services.nix module
- Improve bootloader configuration structure and add comments
- Reorganize nix modules and services configuration
- Consolidate bluetooth configuration with enhanced security
- Move bluetooth service config to services.nix
- Restructure buffedswitch with explicit task dependencies
- Replace color variables with text prefixes in justfile
- Reorganize cleanup commands with descriptive names and logging
- Reorganize and consolidate cleanup commands in justfile
- Reorganize cleanup commands with improved structure
- Consolidate format command and add legacy cleanup aliases

### 🎨 Styling

- Remove newline from waybar clock format
- Change waybar background to black
- Replace section headers with dashes in Nix config
- Format justfile

### ⚙️ Miscellaneous Tasks

- Reorder startup commands and comment out terminal spawn
- Comment out NetworkManager systemd service config
- Update security settings with comments
- Reorganize nixos configuration with section comments
- Consolidate security settings into security.nix
- Reorganize configs and enhance security settings
- Comment out hardened kernel and add IPv6 sysctl rules
- Remove duplicate blueman from user packages
- Enable dprint in home configuration
- *(autoupgrade)* Use local flake for development
- Disable nu shell and adjust git diff output
- *(nixos)* Apply generation 120
- *(nixos)* Apply generation 120
- Set bash shell with strict options in justfile
- Fix justfile syntax and simplify tasks
- *(nixos)* Apply generation 120
- Update formatting tool and fix commit script
- Reorganize justfile commands and update health check
- Remove no-cd setting from justfile
- Update nix commands in justfile
- Remove unused docs command from justfile
- Update packages and refactor justfile commands
- Reorder niri keybindings
- *(nixos)* Apply generation 121
- Add noctalia-shell and quickshell flake inputs
- Update flake inputs and noctalia configuration
## [0.4.0] - 2025-09-01

### 🚀 Features

- Migrate wallpaper management from waypaper to swww
- Add 'talk' alias and update scripts path handling
- Add gh-create alias for GitHub repo creation
- *(git)* Add count parameter to log aliases
- Refactor home-manager configuration

### 🐛 Bug Fixes

- Update stylix module path to homeModules
- Correct swww init service type and dependencies
- Correct typo in git.add.interactive config
- Add git aliases with proper escaping
- Correct default count handling in git aliases
- Use -n for count in git log aliases

### 💼 Other

- Update
- Update
- Update
- Update
- Update
- Update
- Update

### ⚙️ Miscellaneous Tasks

- Update CHANGELOG.md with new version
- Disable dprint and adjust niri config
- *(release)* Update changelog for v0.4.0
## [0.3.0] - 2025-05-31

### 🚀 Features

- *(helix.nix)* Continue to next row if markdown list
- *(nu)* Added alias to activate venv for AI
- *(helix.nix)* Markdown config updates
- Add GitHub CLI (gh) to default home packages
- Add scripts/apps directory, Python packages and mkDefault for fnott
- Add gh-create alias for creating and pushing to GitHub repo

### 🐛 Bug Fixes

- *(stylix.nix)* Commented out kvantum config part
- *(nu.nix)* Replaced depreceated config due to update
- Comment out GTK dark theme preference in Stylix
- Move style properties to window#waybar selector to fix CSS error
- Use @bg_active for Waybar tooltip background to ensure solidity
- Remove xdg-desktop-portal-gtk from portal config

### 💼 Other

- Update
- Update
- Update
- Update
- Update
- Update
- Update

### 🚜 Refactor

- Restructure stylix config using targets and enable Firefox
- Simplify configs and update python to 3.12
- Remove commented-out XDG portal config from home-manager
- Center clock module by moving it to modules-center

### 📚 Documentation

- Create changelog for my commits/releases
- Restructure and expand README documentation

### 🎨 Styling

- Remove unnecessary color definitions from waybar config
- Refactor waybar styles for consistency and correctness
- Remove top border from waybar config
- Center the clock text in the waybar module
- Replace text-align with halign in waybar config
- Remove halign from waybar clock module style
- Make tooltip background solid by using @bg_main color.

### ⚙️ Miscellaneous Tasks

- Comment out xdg-desktop-portal configuration
- Update niri, stylix, waybar configs and jokyv host config
## [0.2.0] - 2025-02-02

### 🚀 Features

- *(nu.nix)* Switched to variable home inetead of username
- *(jokyv/default.nix)* Removing python programs that i dn not need
- *(fnott.nix)* Specify summary font
- *(niri.nix)* Add scripts to niri binds
- *(home/default.nix)* Add jq program
- *(helix.nix)* Added nufmt and markdown-oxide to languages part
- *(fnott.nix)* Decrease the timeout values
- *(foot.nix)* Removed a lot of settings for troubleshooting
- *(niri.nix)* Clip_hist.py bindings and cliphist spawn at startup
- *(waybar.nix)* Added off button functionality
- *(helix.nix)* Added inline errors
- *(starship.nix)* Enabled sudo and added icons for it
- *(fd)* Added fd nix configs
- *(atuin.nix)* Enabled nushell integration
- *(yazi.nix)* Enable nushell integration
- *(starship.nix)* Enable nushell integration
- *(home/default.nix)* Added more programs managed by home-manager
- *(brave.nix)* Config for brave on wayland
- *(obsidian.nix)* Added obsidian and small refactoring
- *(niri.nix)* Shortcuts for obsidian and take screenshot script
- *(typos)* Add typos-lsp for typos support on markdown files
- *(niri)* Added window rules for firefox + URL refs with examples
- *(home)* Added aider
- *(helix)* Re-organising the languages section
- *(nu.nix)* Add path for aider app
- *(home)* Add discord but failing to launch
- *(niri.nix)* Add key binding for clip_hist.py del
- *(hosts/jokyv)* Removed some python packaages i do not need

### 🐛 Bug Fixes

- *(starship.nix)* Fix the format
- *(niri.nix)* Take screenshot path, script etc
- *(zsa)* Added zsa udev rules for my keyboard
- *(foot)* Fixed issue with foot and made it the default terminal
- *(niri)* Issues with typos and floating commands

### 💼 Other

- Update
- Update
- Update
- Update
- Update
- Update
- Update
- Update
- Update
- Update
- Update
- Update

### 🚜 Refactor

- *(home/default.nix)* Small changes
- *(home/default.nix)* Refactoring the packages list.
- *(waybar.nix)* Small changes

### 📚 Documentation

- *(CHANGELOG.md)* Create changelog for my commits/releases
## [0.1.0] - 2024-12-28

### 🚀 Features

- *(dprint.json)* Added dprint.json config file for markdown format

### 📚 Documentation

- *(README.md)* Add readme file
- *(LICENSE)* Added license
