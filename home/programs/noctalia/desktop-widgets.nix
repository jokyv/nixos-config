{ config, pkgs, lib, ... }:

{
  programs.noctalia-shell.settings = {
    # Desktop widgets (wallpaper widgets)
    desktopWidgets = {
      enabled = true;
      overviewEnabled = true;
      gridSnap = true;
      gridSnapScale = true;
      monitorWidgets = [
        {
          name = "HDMI-A-1";
          widgets = [
            {
              id = "Clock";
              x = 820;
              y = 40;
              scale = 1.0;
            }
            {
              id = "Weather";
              x = 730;
              y = 230;
              scale = 1.0;
            }
            {
              id = "SystemStat";
              statType = "CPU";
              x = 770;
              y = 330;
              scale = 1.0;
            }
          ];
        }
        {
          name = "DP-1";
          widgets = [
            {
              id = "Clock";
              x = 820;
              y = 40;
              scale = 1.0;
            }
            {
              id = "Weather";
              x = 720;
              y = 250;
              scale = 1.0;
            }
            {
              id = "SystemStat";
              statType = "CPU";
              x = 780;
              y = 350;
              scale = 1.0;
            }
          ];
        }
      ];
    };
  };
}
