{ config, pkgs, lib, ... }:

{
  programs.noctalia.settings = {
    dock = {
      enabled = true;
      position = "bottom";
      auto_hide = true;
      background_opacity = 0.9;
      icon_size = 48;
      magnification = true;
      magnification_scale = 1.45;
      item_spacing = 6;
      main_axis_padding = 16;
      margin_edge = 8;
      margin_ends = 0;
      cross_axis_padding = 8;
      radius = 16;
      shadow = true;
      reserve_space = false;
      active_monitor_only = false;
      active_opacity = 1.0;
      active_scale = 1.0;
      inactive_opacity = 0.85;
      inactive_scale = 0.85;
      show_running = true;
      show_instance_count = true;
      show_dots = true;
      launcher_position = "start";
      launcher_icon = "grid-dots";
      pinned = [
        "firefox"
        "foot"
        "nautilus"
        "discord"
        "obsidian"
      ];
    };
  };
}