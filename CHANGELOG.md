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
