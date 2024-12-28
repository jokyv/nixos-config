{ config, lib, pkgs, ... }:

{
  # Ensure swww is installed as it's the chosen backend
  home.packages = with pkgs; [
    waypaper
    swww
  ];

  # this does not work as the file is read only and
  # waypaper changing the file everytime we change wallpapaer

  # Configuration file for waypaper
  # xdg.configFile."waypaper/config.ini" =
  #   {
  #     text =
  #       ''
  #         [Settings]
  #         language = en
  #         folder = ~/projects/wallpapers
  #         monitors = All
  #         wallpaper = ~/projects/wallpapers/237185.jpg
  #         backend = swww
  #         fill = fill
  #         sort = name
  #         color = #ffffff
  #         subfolders = False
  #         show_hidden = False
  #         show_gifs_only = False
  #         post_command = 
  #         number_of_columns = 3

  #         # SWWW specific settings
  #         swww_transition_type = any
  #         swww_transition_step = 90
  #         swww_transition_angle = 0
  #         swww_transition_duration = 2
  #         swww_transition_fps = 60

  #         # XDG State setting
  #         use_xdg_state = False
  #       '';
  #     force = false;
  #   };

  # Optional: Add systemd service to start swww daemon
  systemd.user.services.swww = {
    Unit = {
      Description = "Wallpaper daemon for wayland";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.swww}/bin/swww-daemon";
      ExecReload = "${pkgs.swww}/bin/swww kill; ${pkgs.swww}/bin/swww init";
      Restart = "always";
      RestartSec = 3;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
