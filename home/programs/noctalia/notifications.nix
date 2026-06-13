{ config, pkgs, lib, ... }:

{
  programs.noctalia.settings = {
    notification = {
      enable_daemon = true;
      position = "top_right";
      layer = "top";
      background_opacity = 1.0;
      scale = 1.0;
      offset_x = 20;
      offset_y = 8;
      show_actions = true;
      show_app_name = true;
      collapse_on_dismiss = true;
      blacklist_allow_critical = true;
      blacklist = [ ];
      allowed_urgencies = [ ];
      monitors = [ ];
    };

    osd = {
      position = "top_center";
      background_opacity = 1.0;
      scale = 1.0;
      offset_x = 20;
      offset_y = 8;
      orientation = "horizontal";
      monitors = [ ];

      kinds = {
        volume = true;
        brightness = true;
        bluetooth = true;
        wifi = true;
        keyboard_layout = true;
        lock_keys = true;
        caffeine = true;
        dnd = true;
        power_profile = true;
      };
    };
  };
}