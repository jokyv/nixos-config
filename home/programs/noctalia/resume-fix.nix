{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Keep retrying after compositor suspend disconnects Noctalia cleanly.
  # niri imports Wayland session variables before this service starts.
  systemd.user.services.noctalia = {
    Unit = {
      Description = "Noctalia desktop shell";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      # Noctalia package wrapper process is named ".noctalia-wrap", not
      # "noctalia"; match executable path so stale shell instances cannot
      # prevent systemd from starting its managed instance.
      ExecStartPre = "${pkgs.bash}/bin/bash -c '${pkgs.procps}/bin/pkill -f \"/bin/noctalia$\" || true'";
      ExecStart = "${config.programs.noctalia.package}/bin/noctalia";
      Restart = "always";
      RestartSec = 2;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
