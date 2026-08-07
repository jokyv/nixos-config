# Niri configuration: https://niri-wm.github.io/niri/Configuration%3A-Introduction.html

{
  config,
  pkgs,
  ...
}:

let
  screenshots_dir = "${config.home.homeDirectory}/pics/screenshots";
  scripts_dir = "${config.home.homeDirectory}/scripts/bin";
in
{
  wayland.windowManager.niri = {
    enable = true;
    package = pkgs.niri;

    # Native Home Manager currently exposes generic KDL serialization. Keep this
    # validated KDL to preserve Niri's typed nodes, flags, repeated rules, and binds.
    extraConfig = ''
      input {
          keyboard {
              xkb {
                  layout "us, gr"
                  model "pc105"
                  rules ""
                  variant ""
                  options "grp:alt_ctrl_shift_toggle"
              }
              repeat-delay 600
              repeat-rate 25
              track-layout "global"
          }
          touchpad {
              tap
              natural-scroll
          }
          warp-mouse-to-focus
          workspace-auto-back-and-forth
      }
      output "DP-1" {
          scale 1
          transform "normal"
          position x=1920 y=0
          mode "1920x1080@120.000000"
      }
      output "HDMI-A-1" {
          scale 1
          transform "normal"
          position x=0 y=0
          mode "1920x1080@120.000000"
      }
      screenshot-path "${screenshots_dir}/screenshot from %Y-%m-%d %H-%M-%S.png"
      prefer-no-csd
      overview {
          zoom 0.400000
          backdrop-color "#777777"
          workspace-shadow {
              offset x=0 y=10
              softness 40
              spread 10
              color "#00000070"
          }
      }
      layout {
          gaps 15
          struts {
              left 15
              right 15
              top 15
              bottom 15
          }
          focus-ring { width 4; }
          border { off; }
          shadow {
              on
              offset x=0.000000 y=5.000000
              softness 30.000000
              spread 5.000000
              draw-behind-window false
              color "#00000070"
          }
          default-column-width { proportion 0.500000; }
          preset-column-widths {
              proportion 0.500000
              proportion 1.000000
          }
          center-focused-column "never"
          always-center-single-column
      }
      cursor {
          xcursor-theme "default"
          xcursor-size 24
          hide-when-typing
          hide-after-inactive-ms 1000
      }
      hotkey-overlay {
          skip-at-startup
          hide-not-bound
      }
      binds {
          Mod+1 { focus-workspace 1; }
          Mod+2 { focus-workspace 2; }
          Mod+3 { focus-workspace 3; }
          Mod+4 { focus-workspace 4; }
          Mod+5 { focus-workspace 5; }
          Mod+6 { focus-workspace 6; }
          Mod+7 { focus-workspace 7; }
          Mod+8 { focus-workspace 8; }
          Mod+9 { focus-workspace 9; }
          Mod+A cooldown-ms=500 { spawn "noctalia" "msg" "panel-toggle" "control-center"; }
          Mod+Alt+F { toggle-window-floating; }
          Mod+B hotkey-overlay-title="Firefox" repeat=false { spawn "firefox"; }
          Mod+Comma { consume-window-into-column; }
          Mod+Ctrl+1 { move-column-to-workspace 1; }
          Mod+Ctrl+2 { move-column-to-workspace 2; }
          Mod+Ctrl+3 { move-column-to-workspace 3; }
          Mod+Ctrl+4 { move-column-to-workspace 4; }
          Mod+Ctrl+5 { move-column-to-workspace 5; }
          Mod+Ctrl+6 { move-column-to-workspace 6; }
          Mod+Ctrl+7 { move-column-to-workspace 7; }
          Mod+Ctrl+8 { move-column-to-workspace 8; }
          Mod+Ctrl+9 { move-column-to-workspace 9; }
          Mod+Ctrl+H { move-column-left; }
          Mod+Ctrl+I { move-column-to-workspace-up; }
          Mod+Ctrl+J { move-window-down; }
          Mod+Ctrl+K { move-window-up; }
          Mod+Ctrl+L { move-column-right; }
          Mod+Ctrl+U { move-column-to-workspace-down; }
          Mod+D repeat=false { spawn "discord"; }
          Mod+E { spawn "nautilus"; }
          Mod+Equal { set-column-width "+10%"; }
          Mod+Escape { toggle-overview; }
          Mod+F { maximize-column; }
          Mod+F7 { spawn "noctalia" "msg" "volume-down"; }
          Mod+F8 { spawn "noctalia" "msg" "volume-up"; }
          Mod+F9 { spawn "noctalia" "msg" "volume-mute"; }
          Mod+H { focus-column-left; }
          Mod+I { focus-workspace-up; }
          Mod+J { focus-window-down; }
          Mod+K { focus-window-up; }
          Mod+L { focus-column-right; }
          Mod+Minus { set-column-width "-10%"; }
          Mod+N repeat=false { spawn "footclient" "newsraft"; }
          Mod+O repeat=false { spawn "obsidian" "--enable-features=UseOzonePlatform" "--ozone-platform=wayland"; }
          Mod+Period { expel-window-from-column; }
          Mod+Q repeat=false { close-window; }
          Mod+R { switch-preset-column-width; }
          Mod+S repeat=false { spawn "footclient" "-F" "cbonsai" "--screensaver"; }
          Mod+Shift+Alt+F { switch-focus-between-floating-and-tiling; }
          Mod+Shift+B repeat=false { spawn "brave"; }
          Mod+Shift+C { spawn "${scripts_dir}/clip_hist.py" "add"; }
          Mod+Shift+Ctrl+F { maximize-window-to-edges; }
          Mod+Shift+Ctrl+H { move-column-to-monitor-left; }
          Mod+Shift+Ctrl+J { move-column-to-monitor-down; }
          Mod+Shift+Ctrl+K { move-column-to-monitor-up; }
          Mod+Shift+Ctrl+L { move-column-to-monitor-right; }
          Mod+Shift+D { spawn "${scripts_dir}/clip_hist.py" "del"; }
          Mod+Shift+Equal { set-window-height "+10%"; }
          Mod+Shift+Escape cooldown-ms=500 { spawn "noctalia" "msg" "panel-toggle" "session"; }
          Mod+Shift+F { fullscreen-window; }
          Mod+Shift+H { focus-monitor-left; }
          Mod+Shift+I { move-workspace-up; }
          Mod+Shift+L { focus-monitor-right; }
          Mod+Shift+M { spawn "${scripts_dir}/my_logout.py"; }
          Mod+Shift+Minus { set-window-height "-10%"; }
          Mod+Shift+P { power-off-monitors; }
          Mod+Shift+Q { quit; }
          Mod+Shift+S { spawn "${scripts_dir}/clip_hist.py" "sel"; }
          Mod+Shift+Slash { show-hotkey-overlay; }
          Mod+Shift+Space cooldown-ms=500 { spawn "noctalia" "msg" "panel-toggle" "launcher" "clipboard"; }
          Mod+Shift+T cooldown-ms=500 { spawn "kitty"; }
          Mod+Shift+U { move-workspace-down; }
          Mod+Shift+V { spawn "${scripts_dir}/clip_hist.py" "paste"; }
          Mod+Space cooldown-ms=500 { spawn "noctalia" "msg" "panel-toggle" "launcher"; }
          Mod+T cooldown-ms=500 { spawn "footclient"; }
          Mod+U { focus-workspace-down; }
          Mod+W cooldown-ms=500 { spawn "noctalia" "msg" "wallpaper-random"; }
          Mod+Y { spawn "${scripts_dir}/take_screenshot.py"; }
      }
      workspace "1"
      workspace "2"
      workspace "3"
      workspace "4"
      spawn-at-startup "foot" "--server"
      spawn-at-startup "xdg-desktop-portal"
      spawn-at-startup "${pkgs.systemd}/bin/systemctl" "--user" "import-environment" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP" "NIRI_SOCKET"
      window-rule {
          draw-border-with-background false
          geometry-corner-radius 8.000000 8.000000 8.000000 8.000000
          clip-to-geometry true
      }
      window-rule {
          match app-id="^helix$"
          open-maximized true
      }
      window-rule {
          match app-id="^firefox$"
          open-maximized true
          scroll-factor 0.900000
      }
      window-rule {
          match app-id="^obsidian$"
          open-on-workspace "3"
          open-maximized true
      }
      window-rule {
          match app-id="^discord$"
          open-floating true
      }
      window-rule {
          match app-id="^firefox$" title="^Picture-in-Picture$"
          open-floating true
      }
      window-rule {
          match app-id="^firefox$" title="^Private Browsing$"
          open-floating true
      }
      window-rule {
          match is-active=false
          opacity 0.850000
      }
      animations {
          config-notification-open-close { spring damping-ratio=0.600000 epsilon=0.001000 stiffness=1000; }
          window-close { spring damping-ratio=0.600000 epsilon=0.001000 stiffness=1000; }
          window-open { spring damping-ratio=0.600000 epsilon=0.001000 stiffness=1000; }
          window-resize { spring damping-ratio=0.700000 epsilon=0.001000 stiffness=600; }
          workspace-switch { spring damping-ratio=0.600000 epsilon=0.001000 stiffness=800; }
      }
      debug { deactivate-unfocused-windows true; }
    '';
  };
}
