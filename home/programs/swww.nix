{ config, pkgs, ... }:

{
  services.swww = {
    enable = true;
    systemd.enable = true;
    settings = {
      "output HDMI-A-1" = {
        image = "${config.home.homeDirectory}/pics/wallpapers/gankar_1.png";
        transition = {
          type = "any";
          fps = 60;
        };
      };
      "output DP-1" = {
        image = "${config.home.homeDirectory}/pics/wallpapers/gankar_1.png";
        transition = {
          type = "any";
          fps = 60;
        };
      };
    };
  };
}
