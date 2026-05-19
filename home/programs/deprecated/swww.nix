{ config, pkgs, ... }:

{
  home.packages = [ pkgs.swww ];
  services.swww.enable = true;

  # systemd.user.services.swww = {
  #   settings = {
  #     "output HDMI-A-1" = {
  #       image = "${config.home.homeDirectory}/pics/wallpapers/gankar_1.png";
  #       transition = {
  #         type = "any";
  #         fps = 60;
  #       };
  #     };
  #     "output DP-1" = {
  #       image = "${config.home.homeDirectory}/pics/wallpapers/gankar_1.png";
  #       transition = {
  #         type = "any";
  #         fps = 60;
  #       };
  #     };
  #   };
  # };
}
