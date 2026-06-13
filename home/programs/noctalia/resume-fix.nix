{ config, pkgs, lib, ... }:

{
  # Restart Noctalia after system resume to fix stale IPC socket.
  # Noctalia stays in niri's spawn-at-startup (systemd can't manage
  # Wayland-native processes without graphical-session.target).
  # This oneshot runs after suspend/hibernate and restarts Noctalia
  # so IPC keybinds (session menu, launcher, volume) work again.

  systemd.user.services.noctalia-resume = {
    Unit = {
      Description = "Restart Noctalia after resume";
      After = [ "suspend.target" "hibernate.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'sleep 2 && ${pkgs.procps}/bin/pkill noctalia || true'";
      # Noctalia is in niri's spawn-at-startup, so niri respawns it
      # automatically after we kill the stale process.
    };
    Install = {
      WantedBy = [ "suspend.target" "hibernate.target" ];
    };
  };
}
