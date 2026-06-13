{ config, pkgs, lib, ... }:

{
  programs.noctalia.settings = {
    wallpaper = {
      enabled = true;
      directory = "${config.home.homeDirectory}/pics/wallpapers";
      fill_mode = "crop";
      fill_color = "";
      transition = [ "fade" "wipe" "disc" "stripes" "zoom" "honeycomb" ];
      transition_duration = 1500.0;
      transition_on_startup = false;
      edge_smoothness = 0.3;
      per_monitor_directories = false;
      directory_dark = "";
      directory_light = "";

      automation = {
        enabled = true;
        interval_seconds = 600;
        order = "random";
        recursive = true;
      };
    };
  };
}