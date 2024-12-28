# NixOS-Config

This is my NixOS configuration files/setup

> [!IMPORTANT]
> Configs under heavy development, expect breaks and frequent changes.

## How this repo is organised:

- home folder contains everything related to [home-manager](https://github.com/nix-community/home-manager) configs.
- host/jokyv folder contains this nixos configuration and hardware-configuration nix files.
- flake.nix and flake.lock
- justfile has collection of utility scripts related to nixos setup ONLY.
- .sops.yaml the configuration for sops
- secrets stored under `secrets.enc.yaml`

## Programs

- Window system: [Wayland](https://wayland.freedesktop.org/)
- Wayland Compositor: [Niri](https://github.com/YaLTeR/niri)
- ~~Terminal: [Alacritty](https://github.com/alacritty/alacritty)~~
- Terminal: [Kitty](https://github.com/kovidgoyal/kitty) and [foot](https://codeberg.org/dnkl/foot)
- Editor: [Helix](https://github.com/helix-editor/helix)
- Prompt: [Starship](https://github.com/starship/starship)
- Browser: [Firefox](https://www.mozilla.org/en-US/firefox) and [Brave](https://github.com/brave/brave-browser)
- Fonts: [Hack Nerd Font](https://www.nerdfonts.com/)
- Colorscheme: [Everforest](https://github.com/sainnhe/everforest)
- Application Launcher: [Fuzzel](https://codeberg.org/dnkl/fuzzel)
- File manager: [Nautilus](https://gitlab.gnome.org/GNOME/nautilus)
- Status Bar: [Waybar](https://github.com/Alexays/Waybar)
- Screenshots: [Grim](https://github.com/emersion/grim)/[slurp](https://github.com/emersion/slurp)/[swappy](https://github.com/jtheoof/swappy) or [Gnome-Screenshot](https://gitlab.gnome.org/GNOME/gnome-screenshot)
- Clipboard manager: [Cliphist](https://github.com/sentriz/cliphist) and [wl-clipboard](https://github.com/bugaevc/wl-clipboard)
- Document viewer: [Zathura](https://github.com/pwmt/zathura)
- Login Manager: [Ly](https://github.com/fairyglade/ly)
- Notification daemon: [fnot](https://codeberg.org/dnkl/fnott)
- Screenlock: [Swaylock](https://github.com/swaywm/swaylock)
