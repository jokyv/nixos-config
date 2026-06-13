{ config, pkgs, lib, ... }:

{
  programs.noctalia.settings = {
    # Widgets configured in their own [widget.*] sections
    # (defined in bar.nix)
    #
    # Desktop widgets placed via UI (settings are stored in
    # ~/.local/state/noctalia/settings.toml, not config.toml)
    #
    # Docker container widget: not available in v5
    # NotificationHistory: built into bar's "notifications" string
    # SessionMenu: built into bar's "session" string
    # ControlCenter: built into bar's "control-center" string
    # Tray: built into bar's "tray" string
    # Bluetooth: built into bar's "bluetooth" string
    # Brightness: built into bar's "brightness" string
  };
}