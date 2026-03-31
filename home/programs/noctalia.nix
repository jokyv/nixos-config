{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.noctalia-shell = {
    enable = true;
    settings = {
      # Bar appearance
      barBackground = "#1a1a1a";
      barBorderRadius = 8;
      barBorderWidth = 1;
      barBorderColor = "#333333";

      bar = {
        density = "compact";
        position = "left";
        showCapsule = false;
        enabled = true;
        backgroundOpacity = lib.mkForce 0.85;
        capsuleOpacity = lib.mkForce 0.9;
        margins = {
          top = 8;
          bottom = 8;
          inner = 4;
        };
        widgetSpacing = 6;
        animateCapsuleHide = true;
        hideWhenFullscreen = false;
        autoShow = false;
        autoHide = false;
        autoHideDelay = 300;
        autoShowDelay = 300;
        capsule = {
          enabled = false;
          showAppName = true;
          showRunningApps = true;
        };
        widgets = {
          left = [
            {
              id = "SidePanelToggle";
              useDistroLogo = true;
            }
            {
              id = "Network";
              showLabel = false;
              showIp = false;
            }
            {
              id = "Audio";
              showLabel = false;
              showVolume = true;
              showDevice = false;
            }
            { id = "Bluetooth"; }
          ];
          center = [
            {
              hideUnoccupied = false;
              id = "Workspace";
              labelMode = "none";
              showNumbers = true;
              wrapWorkspaces = true;
            }
          ];
          right = [
            {
              id = "SystemTray";
              iconSize = 16;
            }
            # {
            #   id = "Battery";
            #   warningThreshold = 30;
            #   criticalThreshold = 10;
            #   showPercentage = true;
            #   showTime = false;
            # }
            {
              id = "Clock";
              formatHorizontal = "HH:mm";
              formatVertical = "HH mm";
              useMonospacedFont = true;
              usePrimaryColor = true;
              showSeconds = false;
              showDate = false;
              dateFormat = "MMM d";
            }
            {
              id = "Power";
              showLogout = true;
              showReboot = true;
              showShutdown = true;
              showSuspend = true;
            }
          ];
        };
      };

      # Workspace widget settings
      workspace = {
        showActiveOnly = false;
        showEmpty = true;
        showUrgent = true;
        markActive = true;
        markUrgent = true;
      };

      # Audio widget settings
      audio = {
        showMuted = true;
        showInput = false;
        showDeviceSelector = true;
        volumeStep = 5;
      };

      # Network widget settings
      network = {
        showSpeed = false;
        showIp = false;
        showSignalStrength = true;
        showWifiIcon = true;
      };

      colorSchemes = {
        predefinedScheme = "Monochrome";
      };

      general = {
        avatarImage = "${config.home.homeDirectory}/.face";
        radiusRatio = 0.2;
      };

      location = {
        monthBeforeDay = true;
        name = "Singapore, Singapore";
      };

      wallpaper = {
        image = "${config.home.homeDirectory}/pics/wallpapers/gankar_1.png";
        mode = "fill";
      };
    };
  };
}
