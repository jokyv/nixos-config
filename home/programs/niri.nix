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
  spawn_script = script: config.lib.niri.actions.spawn "sh" "-c" "${scripts_dir}/${script}";
  spawn_cmd = cmd: config.lib.niri.actions.spawn "sh" "-c" cmd;

  # Output configuration
  # run `niri msg outputs` to get your monitor details
  outputs = {
    "HDMI-A-1" = {
      mode = {
        width = 1920;
        height = 1080;
        refresh = 120.0;
      };
      scale = 1;
      position = {
        x = 0;
        y = 0;
      };
    };
    "DP-1" = {
      mode = {
        width = 1920;
        height = 1080;
        refresh = 120.0;
      };
      scale = 1;
      position = {
        x = 1920;
        y = 0;
      };
    };
  };

  # Window rules with better organization
  window_rules = [
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

    # Workspace 1: Development (Helix)
    {
      matches = [ { app-id = "^helix$"; } ];
      # open-on-workspace = 1;
      open-maximized = true;
    }
    # Workspace 2: Web Browsing (Firefox)
    {
      matches = [ { app-id = "^firefox$"; } ];
      # open-on-workspace = 2;
      open-maximized = true;
      scroll-factor = 0.90;
    }

    # Workspace 3: Notes & Documentation (Obsidian)
    {
      matches = [ { app-id = "^obsidian$"; } ];
      # open-on-workspace = 3;
      open-maximized = true;
    }

    # Workspace 4: Communication (Discord)
    {
      matches = [ { app-id = "^discord$"; } ];
      # open-on-workspace = 4;
      open-floating = true;
    }

    # Firefox special windows
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
    }

    # Inactive window opacity
    {
      matches = [ { is-active = false; } ];
      opacity = 0.75;
    }
  ];

  # Startup applications
  startup_apps = [
    { argv = [ "swww-daemon" ]; }
    { argv = [ "foot" ]; }
    { argv = [ "xwayland-satellite" ]; }
    { argv = [ "xdg-desktop-portal" ]; }
    # { argv = [ "qs" "-c" "noctalia-shell" ]; }
    { argv = [ "waybar" ]; }
    { argv = [ "gammastep-indicator" ]; }
    { argv = [ "fnott" ]; }
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

  # Keybindings organized by category
  keybinds =
    with config.lib.niri.actions;
    let
      mod = "Mod";
      shift = "Shift";
      ctrl = "Ctrl";
      alt = "Alt";

      # Application launchers
      apps = {
        "${mod}+T" = {
          action = spawn "foot";
          cooldown-ms = 500;
        };
        "${mod}+${shift}+T" = {
          action = spawn "kitty";
          cooldown-ms = 500;
        };
        "${mod}+B" = {
          action = spawn "firefox";
          repeat = false;
        };
        "${mod}+${shift}+B" = {
          action = spawn "brave";
          repeat = false;
        };
        "${mod}+D" = {
          action = spawn "fuzzel";
        };
        "${mod}+E" = {
          action = spawn "nautilus";
        };
        "${mod}+O" = {
          action = spawn_cmd "obsidian --enable-features=UseOzonePlatform --ozone-platform=wayland";
        };
        "${mod}+N" = {
          action = spawn_cmd "foot -e newsraft";
        };
      };

      # System actions
      system = {
        "${mod}+Escape" = {
          action = toggle-overview;
        };
        "${mod}+${shift}+Slash" = {
          action = show-hotkey-overlay;
        };
        "${mod}+Q" = {
          action = close-window;
        };
        "${mod}+${shift}+Q" = {
          action = quit;
        };
        "${mod}+${shift}+P" = {
          action = power-off-monitors;
        };
        "${mod}+${alt}+L" = {
          action = spawn_cmd "swaylock";
        };
        "${mod}+${alt}+F" = {
          action = toggle-window-floating;
        };
        "${mod}+${shift}+${alt}+F" = {
          action = switch-focus-between-floating-and-tiling;
        };
      };

      # Window management
      windows = {
        "${mod}+R" = {
          action = switch-preset-column-width;
        };
        "${mod}+F" = {
          action = maximize-column;
        };
        "${mod}+${shift}+F" = {
          action = fullscreen-window;
        };
        "${mod}+Comma" = {
          action = consume-window-into-column;
        };
        "${mod}+Period" = {
          action = expel-window-from-column;
        };
      };

      # Focus and movement
      focus = {
        "${mod}+H" = {
          action = focus-column-left;
        };
        "${mod}+J" = {
          action = focus-window-down;
        };
        "${mod}+K" = {
          action = focus-window-up;
        };
        "${mod}+L" = {
          action = focus-column-right;
        };

        "${mod}+${shift}+H" = {
          action = focus-monitor-left;
        };
        "${mod}+${shift}+L" = {
          action = focus-monitor-right;
        };

        "${mod}+${ctrl}+H" = {
          action = move-column-left;
        };
        "${mod}+${ctrl}+J" = {
          action = move-window-down;
        };
        "${mod}+${ctrl}+K" = {
          action = move-window-up;
        };
        "${mod}+${ctrl}+L" = {
          action = move-column-right;
        };
      };

      # Workspace management
      workspaces = {
        "${mod}+U" = {
          action = focus-workspace-down;
        };
        "${mod}+I" = {
          action = focus-workspace-up;
        };
        "${mod}+${ctrl}+U" = {
          action = move-column-to-workspace-down;
        };
        "${mod}+${ctrl}+I" = {
          action = move-column-to-workspace-up;
        };
        "${mod}+${shift}+U" = {
          action = move-workspace-down;
        };
        "${mod}+${shift}+I" = {
          action = move-workspace-up;
        };
      };

      # Scripts and custom commands
      scripts = {
        "${mod}+W" = {
          action = spawn_script "update_wall.sh";
        };
        "${mod}+${shift}+W" = {
          action = spawn_script "update_wall.sh --toggle-loop";
        };
        # "${mod}+${shift}+W" = {
        #   action = spawn_script "define_word.sh";
        # };
        "${mod}+${shift}+M" = {
          action = spawn_script "my_logout.sh";
        };
        "${mod}+Y" = {
          action = spawn_script "take_screenshot.sh";
        };

        # Clipboard management
        "${mod}+${shift}+C" = {
          action = spawn_script "clip_hist.py add";
        };
        "${mod}+${shift}+V" = {
          action = spawn_script "clip_hist.py paste";
        };
        "${mod}+${shift}+S" = {
          action = spawn_script "clip_hist.py sel";
        };
        "${mod}+${shift}+D" = {
          action = spawn_script "clip_hist.py del";
        };
      };

      # Audio controls
      audio = {
        "${mod}+F7" = {
          action = spawn_cmd "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
        };
        "${mod}+F8" = {
          action = spawn_cmd "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
        };
        "${mod}+F9" = {
          action = spawn_cmd "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };
      };

      # Window sizing
      sizing = {
        "${mod}+Minus" = {
          action = set-column-width "-10%";
        };
        "${mod}+Equal" = {
          action = set-column-width "+10%";
        };
        "${mod}+${shift}+Minus" = {
          action = set-window-height "-10%";
        };
        "${mod}+${shift}+Equal" = {
          action = set-window-height "+10%";
        };
      };

      # Workspace number bindings (generated programmatically)
      workspace_numbers =
        # mod+number focus on workspace
        lib.listToAttrs (
          map (num: {
            name = "${mod}+${toString num}";
            value = {
              action.focus-workspace = num;
            };
          }) (lib.range 1 9)
        )
        # mod+ctrl+number move window to workspace
        // lib.listToAttrs (
          map (num: {
            name = "${mod}+${ctrl}+${toString num}";
            value = {
              action.move-column-to-workspace = num;
            };
          }) (lib.range 1 9)
        );

      # Monitor movement
      monitor_movement = {
        "${mod}+${shift}+${ctrl}+H" = {
          action = move-column-to-monitor-left;
        };
        "${mod}+${shift}+${ctrl}+J" = {
          action = move-column-to-monitor-down;
        };
        "${mod}+${shift}+${ctrl}+K" = {
          action = move-column-to-monitor-up;
        };
        "${mod}+${shift}+${ctrl}+L" = {
          action = move-column-to-monitor-right;
        };

        "${mod}+${shift}+${ctrl}+Left" = {
          action = move-column-to-monitor-left;
        };
        "${mod}+${shift}+${ctrl}+Down" = {
          action = move-column-to-monitor-down;
        };
        "${mod}+${shift}+${ctrl}+Up" = {
          action = move-column-to-monitor-up;
        };
        "${mod}+${shift}+${ctrl}+Right" = {
          action = move-column-to-monitor-right;
        };
      };

    in
    # Combine all categories using foldl
    # This recursively merges all the keybinding category maps into one combined map
    lib.foldl lib.recursiveUpdate { } [
      apps
      system
      windows
      focus
      workspaces
      scripts
      audio
      sizing
      workspace_numbers
      monitor_movement
    ];

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
    layer-rules = [
      {
        matches = [ { namespace = "^swww-daemon$"; } ];
        place-within-backdrop = true;
      }
    ];

    #  layer-rules = {
    #   swww-wallpaper = {
    #     match.namespace = "swww-daemon";
    #     place-within-backdrop = true;
    #   };
    # };

    # Animation configurations for smoother visuals
    animations = {
      window-open = {
        kind = {
          spring = {
            damping-ratio = 0.6;
            stiffness = 1000;
            epsilon = 0.001;
          };
        };
      };
      window-close = {
        kind = {
          spring = {
            damping-ratio = 0.6;
            stiffness = 1000;
            epsilon = 0.001;
          };
        };
      };

      # Workspace switch animations
      workspace-switch = {
        kind = {
          spring = {
            damping-ratio = 0.6;
            stiffness = 800;
            epsilon = 0.001;
          };
        };
      };

      # window resize animations
      window-resize = {
        kind = {
          spring = {
            damping-ratio = 0.7;
            stiffness = 600;
            epsilon = 0.001;
          };
        };
      };

      config-notification-open-close = {
        kind = {
          spring = {
            damping-ratio = 0.6;
            stiffness = 1000;
            epsilon = 0.001;
          };
        };
      };

    };

    input = {
      warp-mouse-to-focus.enable = true;
      # focus-follows-mouse.enable = true;
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

    # Use 'inherit' when variable name matches setting name exactly
    inherit outputs;

    # Workspace configuration
    workspaces = {
      # Enable workspace wrapping (when you go past the last workspace, wrap to first)
      # wrap-around = true;

      # Number of workspaces (default is 10, but you can customize)
      # count = 10;

      # Remove the names section entirely - it's causing configuration errors
      # The workspace-specific functionality will work without names
    };

    # Enhanced layout settings
    layout = {
      gaps = 15;
      center-focused-column = "never";
      always-center-single-column = true;

      preset-column-widths = [
        { proportion = 1.0 / 2.0; }
        { proportion = 3.0 / 3.0; }
      ];

      default-column-width = {
        proportion = 1.0 / 2.0;
      };

      struts = {
        top = 15;
        bottom = 15;
        left = 15;
        right = 15;
      };
    };

    spawn-at-startup = startup_apps;

    binds = keybinds;

    # Use explicit assignment when variable name differs from setting name
    # for this save check `-` vs `_`
    window-rules = window_rules;
  };
}
