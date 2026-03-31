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
        density = "comfortable";
        position = "left";
        showCapsule = false;
        enabled = true;
        backgroundOpacity = lib.mkForce 0.85;
        capsuleOpacity = lib.mkForce 0.9;
        fontScale = 1.2;
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
              id = "Network";
            }
            {
              id = "Volume";
              displayMode = "onhover";
              iconColor = "none";
              textColor = "none";
              middleClickCommand = "pwvucontrol || pavucontrol";
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
              id = "Tray";
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
              clockColor = "primary";
            }
            {
              id = "SessionMenu";
            }
          ];
        };
      };

      # Volume widget settings
      volume = {
        displayMode = "onhover";
        iconColor = "none";
        textColor = "none";
        middleClickCommand = "pwvucontrol || pavucontrol";
      };

      # Tray widget settings
      tray = {
        blacklist = [];
        colorizeIcons = false;
        chevronColor = "none";
        pinned = [];
        drawerEnabled = true;
        hidePassive = false;
      };

      # SessionMenu widget settings
      sessionMenu = {
        iconColor = "error";
      };

      # Network widget settings
      network = {
        displayMode = "onhover";
        iconColor = "none";
        textColor = "none";
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
