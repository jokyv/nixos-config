{ config, ... }:

{
  home = {
    username = "jokyv";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "24.05";
  };
  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
}
