{ config, pkgs, lib, ... }:

{
  programs.noctalia-shell.settings = {
    # Idle timeouts (replaces swayidle)
    idle = {
      enabled = true;
      screenOffTimeout = 300; # 5 min
      lockTimeout = 360; # 6 min (60s after screen off)
      suspendTimeout = 1800; # 30 min
      fadeDuration = 3;
      # lockCommand = "";        # uses noctalia lock screen by default
      # screenOffCommand = "";   # uses DPMS by default
      # suspendCommand = "";     # uses systemctl suspend by default
    };
  };
}