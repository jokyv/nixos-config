{ config, pkgs, lib, ... }:

{
  programs.noctalia-shell.settings = {
    dock = {
      enabled = true;
      position = "bottom";
      dockType = "floating";
      displayMode = "auto_hide";

      backgroundOpacity = 0.9;
      floatingRatio = 0.85;
      size = 0.95;

      showLauncherIcon = false;
      launcherPosition = "start";
      launcherUseDistroLogo = true;

      pinnedApps = [
        "firefox"
        "foot"
        "nautilus"
        "discord"
        "obsidian"
      ];
      pinnedStatic = true;
      inactiveIndicators = true;

      groupApps = true;
      showDockIndicator = true;
      indicatorThickness = 6;
      indicatorColor = "primary";
      indicatorOpacity = 0.7;
      onlySameOutput = false;
    };
  };
}
