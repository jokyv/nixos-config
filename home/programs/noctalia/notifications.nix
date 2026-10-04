{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.noctalia.settings = {
    notification = {
      enable_daemon = true;
      position = "top_right";
      layer = "top";
      scale = 1.0;
      follow_focused_output = true;
      width = 380;
      border_color = "outline";
      border_width = 1;
      offset_x = 20;
      offset_y = 8;
      show_actions = true;
      show_app_name = true;
      collapse_on_dismiss = true;
      keep_dismissed_in_history = false;
      history_retention_hours = 720;
      blacklist_allow_critical = true;
      blacklist = [ ];
      allowed_urgencies = [ ];
      monitors = [ ];
    };

    osd = {
      position = "top_center";
      scale = 1.0;
      follow_focused_output = true;
      hide_delay_ms = 1600;
      border_color = "outline";
      border_width = 1;
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
