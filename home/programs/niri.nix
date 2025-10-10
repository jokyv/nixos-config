# Niri wiki: https://github.com/YaLTeR/niri/wiki
# Niri flake wiki: https://github.com/sodiboo/niri-flake/blob/main/docs.md
# Niri flake example: https://github.com/sodiboo/system/blob/main/niri.mod.nix

{
  config,
  lib,
  pkgs,
  ...
}:

let
  # Constants and reusable values
  home_dir = config.home.homeDirectory;
  screenshots_dir = "${home_dir}/pics/screenshots";
  wallpaper_dir = "${home_dir}/pics/wallpapers";
  scripts_dir = "${home_dir}/scripts/bin";

  # Reusable spawn commands
  spawn_script = script: spawn "sh" "-c" "${scripts_dir}/${script}";
  spawn_cmd = cmd: spawn "sh" "-c" cmd;
in
{
  programs.niri.enable = true;
  programs.niri.package = pkgs.niri;

  programs.niri.settings = {
    cursor = {
      hide-when-typing = true;
      hide-after-inactive-ms = 1000;
    };
    overview.zoom = 0.35;
    hotkey-overlay.skip-at-startup = true;
    # hotkey-overlay.hide-not-bound = true;
    prefer-no-csd = true;
    screenshot-path = "${screenshots_dir}/screenshot from %Y-%m-%d %H-%M-%S.png";

    input = {
      warp-mouse-to-focus.enable = true;
      focus-follows-mouse.enable = true;
      workspace-auto-back-and-forth = true;
      keyboard = {
        xkb = {
          layout = "us, gr"; # US and Greek layouts
          model = "pc105";
          options = "grp:alt_ctrl_shift_toggle";
        };
      };
      mouse = {
        # off = false;
        # natural-scroll = false;
        # accel-speed = 0.2;
        # accel-profile = "flat";
        # scroll-method = "no-scroll";
      };
    };

    outputs = {
      "HDMI-A-1" = {
        mode.width = 1920;
        mode.height = 1080;
        mode.refresh = 60.0;
        scale = 1;
        # transform = "normal";
        position = {
          x = 0;
          y = 0;
        };
      };
      "DP-1" = {
        mode.width = 1920;
        mode.height = 1080;
        mode.refresh = 60.0;
        scale = 1;
        # transform = "normal";
        position = {
          x = 1920;
          y = 0;
        };
      };
    };

    layout = {
      gaps = 15;
      center-focused-column = "never";
      always-center-single-column = true;
      # shadow.enable = "true";
      preset-column-widths = [
        # { proportion = 1.0 / 3.0; }
        { proportion = 1.0 / 2.0; }
        # { proportion = 2.0 / 3.0; }
        { proportion = 3.0 / 3.0; }
      ];
      default-column-width = {
        proportion = 1.0 / 2.0;
      };

      # focus-ring = {
      #   width = 6;
      #   active-color = "#e6c1d3";
      #   inactive-color = "#805b6d";
      # };

      # border.enable = true;

      struts = {
        top = 15;
        bottom = 15;
        left = 15;
        right = 15;
      };
    };

    spawn-at-startup = [
      { argv = [ "swww-daemon" ]; }
      { argv = [ "foot" ]; }
      { argv = [ "xwayland-satellite" ]; }
      { argv = [ "xdg-desktop-portal" ]; }
      # { argv = [ "qs" "-c" "noctalia-shell" ]; }
      { argv = [ "waybar" ]; }
      {
        argv = [
          "swww"
          "img"
          "${wallpaper_dir}/gankar_1.png"
        ];
      }
      # my copy and paste setup
      {
        argv = [
          "wl-paste"
          "--watch"
          "cliphist"
          "store"
        ];
      }
      # open terminal and run command
      {
        argv = [
          "foot"
          "sh"
          "-c"
          "cd ${home_dir}/nixos-config && git pull && echo 'Press Enter to close' && read"
        ];
      }
    ];

    # config-notification-open-close.spring = {
    #   damping-ratio = 0.6;
    #   stiffness = 1000;
    #   epsilon = 0.001;
    # };

    binds =
      with config.lib.niri.actions;
      let
        # term = args: "foot sh -c '${lib.escape [ "'" ] args}'";
      in
      lib.attrsets.mergeAttrsList [
        {
          "Mod+Shift+Slash".action.show-hotkey-overlay = { };

          # Terminal apps
          "Mod+T".action.spawn = "foot";
          "Mod+T".cooldown-ms = 500;
          "Mod+Shift+T".action.spawn = "kitty";

          # Browser apps
          "Mod+B".action.spawn = "firefox";
          "Mod+B".repeat = false;
          "Mod+Shift+B".action.spawn = "brave";

          # Launch app launcher
          "Mod+D".action.spawn = "fuzzel";

          # Launch file manager
          "Mod+E".action.spawn = "nautilus";
          # "Mod+Shift+E".action = term "yy ${home_dir}/downloads/";

          # Change wallpaper
          "Mod+W".action = spawn_script "update_wall.sh";

          # Launch obsidian
          "Mod+O".action = spawn_cmd "obsidian --enable-features=UseOzonePlatform --ozone-platform=wayland";

          # Launrch newsraft
          "Mod+N".action = spawn_cmd "foot -e newsraft";

          # Scripts
          "Mod+Shift+W".action = spawn_script "define_word.sh";
          "Mod+Shift+M".action = spawn_script "my_logout.sh";
          # Clipboard history custom script
          "Mod+Shift+C".action = spawn_script "clip_hist.py add";
          "Mod+Shift+V".action = spawn_script "clip_hist.py paste";
          "Mod+Shift+S".action = spawn_script "clip_hist.py sel";
          "Mod+Shift+D".action = spawn_script "clip_hist.py del";

          # System actions
          # "Mod+Z".action = toggle-overview;
          "Mod+Q".action = close-window;
          "Mod+Shift+Q".action = quit;
          "Mod+Shift+P".action = power-off-monitors;

          # Alt commands
          "Mod+Alt+L".action = spawn_cmd "swaylock";
          "Mod+Alt+F".action = toggle-window-floating;
          "Mod+Shift+Alt+F".action = switch-focus-between-floating-and-tiling;

          # Window management
          "Mod+R".action = switch-preset-column-width;
          "Mod+F".action = maximize-column;
          "Mod+Shift+F".action = fullscreen-window;

          # Audio controls
          "Mod+F7".action = spawn_cmd "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
          "Mod+F8".action = spawn_cmd "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
          "Mod+F9".action = spawn_cmd "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

          # Focus movement
          "Mod+H".action = focus-column-left;
          "Mod+J".action = focus-window-down;
          "Mod+K".action = focus-window-up;
          "Mod+L".action = focus-column-right;

          # Window movement
          "Mod+Ctrl+H".action = move-column-left;
          "Mod+Ctrl+J".action = move-window-down;
          "Mod+Ctrl+K".action = move-window-up;
          "Mod+Ctrl+L".action = move-column-right;

          # Monitor focus
          "Mod+Shift+H".action = focus-monitor-left;
          "Mod+Shift+L".action = focus-monitor-right;

          # Monitor movement
          "Mod+Shift+Ctrl+H".action = move-column-to-monitor-left;
          "Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
          "Mod+Shift+Ctrl+K".action = move-column-to-monitor-up;
          "Mod+Shift+Ctrl+L".action = move-column-to-monitor-right;

          "Mod+Shift+Ctrl+Left".action = move-column-to-monitor-left;
          "Mod+Shift+Ctrl+Down".action = move-column-to-monitor-down;
          "Mod+Shift+Ctrl+Up".action = move-column-to-monitor-up;
          "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;

          # Workspace movement
          "Mod+U".action = focus-workspace-down;
          "Mod+I".action = focus-workspace-up;
          "Mod+Ctrl+U".action = move-column-to-workspace-down;
          "Mod+Ctrl+I".action = move-column-to-workspace-up;
          "Mod+Shift+U".action = move-workspace-down;
          "Mod+Shift+I".action = move-workspace-up;

          # Workspace number bindings
          "Mod+1".action.focus-workspace = 1;
          "Mod+2".action.focus-workspace = 2;
          "Mod+3".action.focus-workspace = 3;
          "Mod+4".action.focus-workspace = 4;
          "Mod+5".action.focus-workspace = 5;
          "Mod+6".action.focus-workspace = 6;
          "Mod+7".action.focus-workspace = 7;
          "Mod+8".action.focus-workspace = 8;
          "Mod+9".action.focus-workspace = 9;

          "Mod+Ctrl+1".action.move-column-to-workspace = 1;
          "Mod+Ctrl+2".action.move-column-to-workspace = 2;
          "Mod+Ctrl+3".action.move-column-to-workspace = 3;
          "Mod+Ctrl+4".action.move-column-to-workspace = 4;
          "Mod+Ctrl+5".action.move-column-to-workspace = 5;
          "Mod+Ctrl+6".action.move-column-to-workspace = 6;
          "Mod+Ctrl+7".action.move-column-to-workspace = 7;
          "Mod+Ctrl+8".action.move-column-to-workspace = 8;
          "Mod+Ctrl+9".action.move-column-to-workspace = 9;

          # Window manipulation
          "Mod+Comma".action = consume-window-into-column;
          "Mod+Period".action = expel-window-from-column;

          # Window sizing
          "Mod+Minus".action = set-column-width "-10%";
          "Mod+Equal".action = set-column-width "+10%";
          "Mod+Shift+Minus".action = set-window-height "-10%";
          "Mod+Shift+Equal".action = set-window-height "+10%";

          # Screenshots
          "Mod+Y".action = spawn_script "take_screenshot.sh";
          # "Mod+Shift+Y".action = screenshot-screen;
          # "Mod+Ctrl+Y".action = screenshot-window;
        }
      ];

    window-rules =
      let
        colors = config.lib.stylix.colors.withHashtag;
      in
      [
        {
          geometry-corner-radius =
            let
              r = 8.0;
            in
            {
              top-left = r;
              top-right = r;
              bottom-left = r;
              bottom-right = r;
            };
          clip-to-geometry = true;
        }
        {
          matches = [ { app-id = "^firefox$"; } ];
          open-maximized = true;
          # making scrolling for firefox little slower
          scroll-factor = 0.90;
        }
        {
          matches = [
            {
              app-id = "^firefox$";
              title = "^Picture-in-Picture$";
            }
          ];
          open-floating = true;
        }
        {
          matches = [
            {
              app-id = "^firefox$";
              title = "^Private Browsing$";
            }
          ];
          open-floating = true;
          # border.active-color = "#7d0d2d";
        }
        {
          matches = [ { app-id = "^obsidian$"; } ];
          open-maximized = true;
        }
        {
          matches = [ { is-active = false; } ];
          opacity = 0.75;
        }
      ];
  };
}
