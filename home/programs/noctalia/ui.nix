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
      enableShadows = false;
      enableBlurBehind = false;
      animationSpeed = 1.0;
      animationDisabled = false;

      # Lock screen (replaces swaylock)
      lockScreenBlur = true;
      lockScreenTint = true;
      lockScreenMonitors = [ ];
      lockScreenCountdown = true;
      lockScreenButtons = true;
      lockScreenHibernate = false;
      lockScreenMediaControls = true;
      compactLockScreen = false;
      lockScreenAnimations = true;
      lockOnSuspend = true;

      clockStyle = "digital";
      clockFormat = "12hour";
      dimmerOpacity = 0.6;

      showChangelogOnStartup = false;
      telemetryEnabled = false;
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
