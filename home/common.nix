{ config, ... }:

{
  home.username = "jokyv";
  home.homeDirectory = "/home/${config.home.username}";
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
}
