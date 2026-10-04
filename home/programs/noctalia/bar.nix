_: {
  programs.noctalia.settings = {
    bar = {
      order = [ "widgets" ];

      widgets = {
        enabled = true;
        position = "left";
        thickness = 48;
        reserve_space = true;
        scale = 0.9;
        start = [
          "active_window"
          "spacer"
          "network_rx"
          "network_tx"
          "spacer"
          "output_volume"
          "keyboard_layout"
          "spacer"
          "lock_keys"
          "bluetooth"
        ];
        center = [ "workspaces" ];
        end = [
          "temp"
          "cpu"
          "ram"
          "spacer"
          "media"
          "notifications"
          "control-center"
          "brightness"
          "spacer"
          "tray"
          "spacer"
          "date"
          "spacer"
          "session"
        ];
        background_opacity = 0.85;
        border = "outline";
        border_width = 0.0;
        capsule = true;
        capsule_border = "outline";
        capsule_border_width = 1.0;
        radius = 0;
        shadow = true;
        contact_shadow = false;
        padding = 4;
        widget_spacing = 3;
        margin_edge = 0;
        margin_ends = 0;
        auto_hide = false;
        font_weight = 500;
      };
    };

    # Widget configurations
    widget = {
      active_window = {
        type = "active_window";
        icon_size = 14.0;
        max_length = 180.0;
        min_length = 80.0;
        title_scroll = "none";
      };

      spacer = {
        type = "spacer";
      };

      output_volume = {
        type = "volume";
        device = "output";
      };

      keyboard_layout = {
        type = "keyboard_layout";
        cycle_command = "";
        hide_when_single_layout = false;
      };

      lock_keys = {
        type = "lock_keys";
        display = "short";
        hide_when_off = false;
        show_caps_lock = true;
        show_num_lock = true;
        show_scroll_lock = false;
      };

      media = {
        type = "media";
        art_size = 24.0;
        rotate_album_art = true;
        max_length = 220.0;
        min_length = 80.0;
        title_scroll = "none";
      };

      date = {
        type = "clock";
        format = "{:%H:%M · %a %d %b}";
      };

      # System monitor — separate widgets for cpu, temp, ram, network
      temp = {
        type = "sysmon";
        stat = "cpu_temp";
        custom_label = "TEMP";
        show_glyph = false;
      };

      cpu = {
        type = "sysmon";
        stat = "cpu_usage";
        custom_label = "CPU";
        show_glyph = false;
      };

      ram = {
        type = "sysmon";
        stat = "ram_used";
        custom_label = "RAM";
        show_glyph = false;
      };

      network_rx = {
        type = "sysmon";
        stat = "net_rx";
        custom_label = "RX";
        show_glyph = false;
      };

      network_tx = {
        type = "sysmon";
        stat = "net_tx";
        custom_label = "TX";
        show_glyph = false;
      };
    };
  };
}
