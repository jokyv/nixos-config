{ config, pkgs, lib, ... }:

{
  programs.noctalia-shell.settings = {
    colorSchemes = {
      predefinedScheme = "Monochrome";
    };

    general = {
      avatarImage = "${config.home.homeDirectory}/.face";
      radiusRatio = 0.2;
      scaleRatio = 1.3;
      enableBlurBehind = false;
    };

    # UI/popup styling
    ui = {
      panelBackgroundOpacity = lib.mkForce 1;
      translucentWidgets = lib.mkForce false;
      panelsAttachedToBar = lib.mkForce true;
      boxBorderEnabled = lib.mkForce false;
      settingsPanelMode = lib.mkForce "attached";
    };

    location = {
      monthBeforeDay = true;
      name = "";
      autoLocate = true;
    };

    # Night Light (wlsunset)
    nightLight = {
      enabled = true;
      autoSchedule = true;
      nightTemp = "3400";
      dayTemp = "6500";
    };
  };
}
