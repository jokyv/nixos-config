{ config, pkgs, ... }:

{
  # Install swww
  home.packages = [ pkgs.swww ];

  # Start swww on login
  systemd.user.services.swww-init = {
    Unit = {
      Description = "Start swww daemon";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.swww}/bin/swww init";
      Type = "oneshot";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # Set a wallpaper after the daemon starts
  systemd.user.services.swww-set = {
    Unit = {
      Description = "Set wallpaper with swww";
      After = [ "swww-init.service" ];
      Requires = [ "swww-init.service" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.swww}/bin/swww img ${config.home.homeDirectory}/pics/wallpapers/gankar_1.png \
          --transition-type=any \
          --transition-fps=60
      '';
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
