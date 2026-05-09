{ config, pkgs, lib, ... }:

{
  programs.noctalia-shell.settings = {
    # Wallpaper settings (Noctalia handles wallpapers)
    wallpaper = {
      enabled = true;
      directory = "${config.home.homeDirectory}/pics/wallpapers";
      automationEnabled = true;
      wallpaperChangeMode = "random";
      randomIntervalSec = 600;
      skipStartupTransition = true;
      fillMode = "crop";
      sortOrder = "name";
      # Optional:
      # overviewEnabled = true; # make wallpaper blur
      # enableMultiMonitorDirectories = false;
      # showHiddenFiles = false;
      # linkLightAndDarkWallpapers = true;
    };
  };
}
