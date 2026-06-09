{ config, pkgs, lib, ... }:

{
  imports = [
    ./bar.nix
    ./widgets.nix
    ./notifications.nix
    ./ui.nix
    ./idle.nix
    ./launcher.nix
    ./dock.nix
    ./wallpaper.nix
    ./desktop-widgets.nix
    ./resume-fix.nix
  ];

  programs.noctalia.enable = true;
}
