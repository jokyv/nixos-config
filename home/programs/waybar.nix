{ config, ... }:
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        mod = "dock";
        exclusive = true;
        gtk-layer-shell = true;
        margin-bottom = -1;
        passthrough = false;
        height = 41;

        "modules-left" = [
          "custom/os_button"
          "niri/workspaces"
          "wlr/taskbar"
        ];
        "modules-center" = [ "clock" ];
        "modules-right" = [
          "cpu"
          # "temperature"
          "memory"
          "disk"
          "tray"
          "pulseaudio"
          "network"
          "niri/language"
          "custom/off_button"
        ];

        "niri/language" = {
          format = "{}";
          format-en = "ENG";
          format-gr = "ΕΛ";
        };

        "niri/workspaces" = {
          icon-size = 32;
          spacing = 16;
          on-scroll-up = "hyprctl dispatch workspace r+1";
          on-scroll-down = "hyprctl dispatch workspace r-1";
        };

        "custom/os_button" = {
          format = "";
          on-click = "fuzzel";
          tooltip = false;
        };

        "custom/off_button" = {
          format = "";
          on-click = "${config.home.homeDirectory}/scripts/bin/my_logout.sh";
          tooltip = false;
        };

        cpu = {
          interval = 5;
          format = "󰻠 {usage}%";
          max-length = 10;
          on-click = "foot -F btop";
        };

        disk = {
          interval = 30;
          format = "󰋊 {percentage_used}%";
          path = "/";
          tooltip = true;
          unit = "GB";
          tooltip-format = "Available {free} of {total}";
          on-click = "foot -F btop";
        };

        memory = {
          interval = 10;
          format = "  {percentage}%"; # needs more space here
          max-length = 10;
          tooltip = true;
          tooltip-format = "RAM - {used:0.1f}GiB used";
          on-click = "foot -F btop";
        };

        temperature = {
          hwmon-path-abs = "/sys/class/hwmon/hwmon0";
          input-filename = "temp1_input";
          critical-threshold = 75;
          tooltip = true;
          format-critical = " {temperatureC}°C";
          format = " {temperatureC}°C";
        };

        "wlr/taskbar" = {
          format = "{icon} {title:.17}";
          icon-size = 28;
          spacing = 3;
          on-click-middle = "close";
          tooltip-format = "{title}";
          ignore-list = [ ];
          on-click = "activate";
        };

        tray = {
          icon-size = 18;
          spacing = 3;
        };

        clock = {
          format = "      {:%R\n %d.%m.%Y}";
          "tooltip-format" = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            "mode-mon-col" = 3;
            "weeks-pos" = "right";
            "on-scroll" = 1;
            "on-click-right" = "mode";
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            "on-click-right" = "mode";
            "on-click-forward" = "tz_up";
            "on-click-backward" = "tz_down";
            "on-scroll-up" = "shift_up";
            "on-scroll-down" = "shift_down";
          };
        };

        network = {
          "format-wifi" = "{icon} {signalStrength}%";
          "format-ethernet" = "󰈁 ";
          "format-disconnected" = "󰌙";
          "format-icons" = [
            "󰤯 "
            "󰤟 "
            "󰤢 "
            "󰤢 "
            "󰤨 "
          ];
        };

        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 20;
          };
          format = "{icon} {capacity}%";
          "format-charging" = " {capacity}%";
          "format-plugged" = " {capacity}%";
          "format-alt" = "{time} {icon}";
          "format-icons" = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };

        pulseaudio = {
          max-volume = 150;
          scroll-step = 10;
          format = "{icon}  {volume}%";
          # "tooltip-format" = "{volume}%";
          format-muted = "󰝟";
          format-icons = {
            default = [
              "󰕿"
              "󰖀"
              ""
            ];
          };
          on-click = "pwvucontrol";
        };
      };
    };
    style = ''
      window#waybar {
        text-shadow: none;
        box-shadow: none;
        border: none;
        border-radius: 0;
        font-family: "Segoe UI", "Ubuntu";
        font-weight: 600;
        font-size: 12.7px;
        background: @bg_main;
        color: @content_main;
      }

      tooltip {
        background: @bg_main_tooltip;
        border-radius: 5px;
        border-width: 1px;
        border-style: solid;
        border-color: @border_main;
      }

      tooltip label {
        color: @content_main;
      }

      #custom-os_button {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 32px;
        padding-left: 12px;
        padding-right: 20px;
        transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
      }

      #custom-os_button:hover {
        background: @bg_hover;
        color: @content_main;
      }

      #custom-off_button {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 24px;
        padding-left: 12px;
        padding-right: 20px;
        transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
      }

      #custom-off_button:hover {
        background: @bg_hover;
        color: @content_main;
      }

      #workspaces {
        color: transparent;
        margin-right: 1.5px;
        margin-left: 1.5px;
      }

      #workspaces button {
        padding: 3px;
        color: @content_inactive;
        transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
      }

      #workspaces button.active {
        color: @content_main;
        border-bottom: 3px solid white;
      }

      #workspaces button.focused {
        color: @bg_active;
      }

      #workspaces button.urgent {
        background: rgba(255, 200, 0, 0.35);
        border-bottom: 3px dashed @warning_color;
        color: @warning_color;
      }

      #workspaces button:hover {
        background: @bg_hover;
        color: @content_main;
      }

      #taskbar button {
        min-width: 130px;
        border-bottom: 3px solid rgba(255, 255, 255, 0.3);
        margin-left: 2px;
        margin-right: 2px;
        padding-left: 8px;
        padding-right: 8px;
        color: @content_main;
        transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
      }

      #taskbar button.active {
        border-bottom: 3px solid white;
        background: @bg_active;
      }

      #taskbar button:hover {
        border-bottom: 3px solid white;
        background: @bg_hover;
        color: @content_main;
      }

      #cpu, #disk, #memory {
        padding: 3px;
      }

      #temperature {
        color: transparent;
        font-size: 0px;
        transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
      }

      #temperature.critical {
        padding-right: 3px;
        color: @warning_color;
        font-size: initial;
        border-bottom: 3px dashed @warning_color;
        transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
      }

      #tray {
        margin-left: 5px;
        margin-right: 5px;
      }

      #tray widget.passive {
        border-bottom: none;
      }

      #tray widget.active {
        border-bottom: 3px solid white;
      }

      #tray widget.needs-attention {
        border-bottom: 3px solid @warning_color;
      }

      #tray widget {
        transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
      }

      #tray widget:hover {
        background: @bg_hover;
      }

      #pulseaudio {
        font-family: "JetBrainsMono Nerd Font";
        padding-left: 3px;
        padding-right: 3px;
        transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
      }

      #pulseaudio:hover {
        background: @bg_hover;
      }

      #network {
        padding-left: 3px;
        padding-right: 3px;
      }

      #language {
        padding-left: 5px;
        padding-right: 5px;
      }

      #clock {
        padding-right: 5px;
        padding-left: 5px;
        halign: center;
        transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
      }

      #clock:hover {
        background: @bg_hover;
      }
    '';
  };
}
