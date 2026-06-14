{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.noctalia.settings = {
    shell = {
      avatar_path = "${config.home.homeDirectory}/.face";
      ui_scale = 1.0;
      corner_radius_scale = 0.2;
      time_format = "{:%I:%M %p}";
      date_format = "%A, %x";
      font_family = "sans-serif";
      telemetry_enabled = false;
      setup_wizard_enabled = false;
      disable_mipmaps = false;
      shared_gl_context = true;
      show_location = true;

      animation = {
        enabled = true;
        speed = 1.0;
      };

      shadow = {
        alpha = 0.55;
        direction = "down";
      };

      screen_corners = {
        enabled = false;
        size = 32;
      };

      panel = {
        transparency_mode = "solid";
        borders = true;
        shadow = true;
        launcher_placement = "centered";
        clipboard_placement = "centered";
        control_center_placement = "attached";
        session_placement = "attached";
        wallpaper_placement = "attached";
      };
    };

    theme = {
      source = "builtin";
      builtin = "Kanagawa";
      mode = "dark";
      wallpaper_scheme = "m3-content";
      community_palette = "";
      custom_palette = "";
    };

    nightlight = {
      enabled = true;
      force = false;
      temperature_day = 6500;
      temperature_night = 3400;
    };

    location = {
      address = "";
      auto_locate = true;
      sunrise = "";
      sunset = "";
    };

    weather = {
      enabled = true;
      effects = true;
      refresh_minutes = 30;
      unit = "metric";
    };

    backdrop = {
      enabled = false;
      blur_intensity = 0.5;
      tint_intensity = 0.3;
    };

    lockscreen = {
      enabled = true;
      blurred_desktop = false;
      blur_intensity = 0.5;
      tint_intensity = 0.3;
      wallpaper = "";
      monitors = [ ];
    };

    keybinds = {
      up = [ "Up" ];
      down = [ "Down" ];
      left = [ "Left" ];
      right = [ "Right" ];
      validate = [
        "Return"
        "KP_Enter"
      ];
      cancel = [ "Escape" ];
    };

    battery = {
      warning_threshold = 20;
    };

    brightness = {
      enable_ddcutil = false;
      ignore_mmids = [ ];
    };

    calendar = {
      enabled = true;
      refresh_minutes = 15;
    };

    control_center = {
      sidebar = "compact";
      sidebar_section = "compact";
      shortcuts = [
        { type = "wifi"; }
        { type = "bluetooth"; }
        { type = "caffeine"; }
        { type = "nightlight"; }
        { type = "notification"; }
        { type = "power_profile"; }
      ];
    };

    system.monitor = {
      enabled = true;
      cpu_poll_seconds = 2.0;
      cpu_usage_activity_threshold = 50.0;
      cpu_usage_critical_threshold = 90.0;
      cpu_temp_activity_threshold = 60.0;
      cpu_temp_critical_threshold = 85.0;
      ram_pct_activity_threshold = 60.0;
      ram_pct_critical_threshold = 90.0;
      memory_poll_seconds = 2.0;
      network_poll_seconds = 3.0;
      net_rx_activity_threshold = 1.0;
      net_rx_critical_threshold = 50.0;
      net_tx_activity_threshold = 1.0;
      net_tx_critical_threshold = 50.0;
    };

    # Session actions for the session menu
    shell.session.actions = [
      {
        action = "lock";
        enabled = true;
        shortcut = "1";
      }
      {
        action = "logout";
        enabled = true;
        shortcut = "2";
      }
      {
        action = "lock_and_suspend";
        enabled = true;
        shortcut = "3";
      }
      {
        action = "reboot";
        enabled = true;
        shortcut = "4";
      }
      {
        action = "shutdown";
        enabled = true;
        shortcut = "5";
        variant = "destructive";
      }
    ];
  };
}
