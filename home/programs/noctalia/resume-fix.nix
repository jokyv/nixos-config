{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Run Noctalia as a user service so systemd owns its lifecycle.
  # niri imports Wayland session variables before this service starts.
  systemd.user.services.noctalia = {
    Unit = {
      Description = "Noctalia desktop shell";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStartPre = "${pkgs.bash}/bin/bash -c '${pkgs.procps}/bin/pkill -x noctalia || true'";
      ExecStart = "${config.programs.noctalia.package}/bin/noctalia";
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
