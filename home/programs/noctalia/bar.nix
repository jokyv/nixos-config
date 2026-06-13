{ ... }:
{
  programs.noctalia.settings = {
    bar = {
      order = [ "widgets" ];

      widgets = {
        enabled = true;
        position = "left";
        thickness = 38;
        reserve_space = true;
        scale = 1.0;
        start = [
          "active_window"
          "spacer"
          "network_rx"
          "network_tx"
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
        radius = 0;
        shadow = true;
        contact_shadow = false;
        padding = 6;
        widget_spacing = 4;
        margin_edge = 0;
        margin_ends = 0;
        auto_hide = false;
        font_weight = 500;
      };
    };

    # Widget configurations
    widget.active_window = {
      type = "active_window";
      icon_size = 14.0;
      max_length = 180.0;
      min_length = 80.0;
      title_scroll = "none";
    };

    widget.spacer = {
      type = "spacer";
    };

    widget.output_volume = {
      type = "volume";
      device = "output";
    };

    widget.keyboard_layout = {
      type = "keyboard_layout";
      cycle_command = "";
      hide_when_single_layout = false;
    };

    widget.lock_keys = {
      type = "lock_keys";
      display = "short";
      hide_when_off = false;
      show_caps_lock = true;
      show_num_lock = true;
      show_scroll_lock = false;
    };

    widget.media = {
      type = "media";
      art_size = 16.0;
      max_length = 220.0;
      min_length = 80.0;
      title_scroll = "none";
    };

    widget.date = {
      type = "clock";
      format = "{:%H:%M  %a %d %b}";
    };

    # System monitor — separate widgets for cpu, temp, ram, network
    widget.temp = {
      type = "sysmon";
      stat = "cpu_temp";
    };

    widget.cpu = {
      type = "sysmon";
      stat = "cpu_usage";
    };

    widget.ram = {
      type = "sysmon";
      stat = "ram_used";
    };

    widget.network_rx = {
      type = "sysmon";
      stat = "net_rx";
    };

    widget.network_tx = {
      type = "sysmon";
      stat = "net_tx";
    };
  };
}
