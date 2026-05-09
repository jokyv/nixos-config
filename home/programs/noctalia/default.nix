{ config, pkgs, lib, ... }:

{
  imports = [
    ./bar.nix
    ./widgets.nix
    ./notifications.nix
    ./ui.nix
    ./launcher.nix
    ./dock.nix
    ./wallpaper.nix
    ./desktop-widgets.nix
  ];

  programs.noctalia-shell.enable = true;
}
