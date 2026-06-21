{ config, pkgs, ... }:

{
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
    desktop = "${config.home.homeDirectory}";
    download = "${config.home.homeDirectory}/downloads";
    pictures = "${config.home.homeDirectory}/pics";
    templates = "${config.home.homeDirectory}";
    publicShare = "${config.home.homeDirectory}";
    documents = "${config.home.homeDirectory}";
    music = "${config.home.homeDirectory}";
    videos = "${config.home.homeDirectory}";
    extraConfig = {
      PROJECTS = "${config.home.homeDirectory}/projects";
    };
  };

  gtk = {
    iconTheme = {
      package = pkgs.candy-icons;
      name = "candy-icons";
    };
  };

  fonts.fontconfig.enable = true;

  # Hyprland eval warning: silence configType deprecation
  # Module loaded by noctalia/niri dependency, not directly used
  wayland.windowManager.hyprland.configType = "hyprlang";
}
