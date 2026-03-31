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
              id = "ActiveWindow";
              hideMode = "hidden";
              maxWidth = 180;
              showIcon = false;
              textColor = "none";
            }
            {
              id = "Spacer";
              width = 8;
            }
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
            {
              id = "KeyboardLayout";
              displayMode = "onhover";
              showIcon = true;
              iconColor = "none";
              textColor = "none";
            }
            {
              id = "Spacer";
              width = 8;
            }
            {
              id = "LockKeys";
              showCapsLock = true;
              showNumLock = true;
              showScrollLock = false;
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
              id = "SystemMonitor";
              compactMode = true;
              showCpuUsage = true;
              showCpuTemp = true;
              showMemoryUsage = true;
              showNetworkStats = false;
              showDiskUsage = false;
              iconColor = "none";
              textColor = "none";
            }
            {
              id = "Spacer";
              width = 8;
            }
            {
              id = "MediaMini";
              hideMode = "hidden";
              showAlbumArt = true;
              showArtistFirst = true;
              showVisualizer = false;
              displayMode = "onhover";
            }
            {
              id = "NotificationHistory";
              showUnreadBadge = true;
              iconColor = "none";
            }
            {
              id = "ControlCenter";
              useDistroLogo = false;
              icon = "settings";
              iconColor = "none";
            }
            {
              id = "Brightness";
              displayMode = "onhover";
              iconColor = "none";
              textColor = "none";
              applyToAllMonitors = false;
            }
            {
              id = "Spacer";
              width = 4;
            }
            { id = "Tray"; }
            {
              id = "Clock";
              formatHorizontal = "HH:mm";
              formatVertical = "HH mm";
              clockColor = "primary";
            }
            { id = "SessionMenu"; }
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
        blacklist = [ ];
        colorizeIcons = false;
        chevronColor = "none";
        pinned = [ ];
        drawerEnabled = true;
        hidePassive = false;
      };

      # SessionMenu widget settings
      sessionMenu = {
        iconColor = "error";
        # Control which actions appear in the session menu
        showLogout = true;
        showReboot = true;
        showShutdown = true;
        showSuspend = true;
      };

      # Network widget settings
      network = {
        displayMode = "onhover";
        iconColor = "none";
        textColor = "none";
      };

      # ActiveWindow widget settings
      activeWindow = {
        hideMode = "hidden";
        maxWidth = 180;
        showIcon = false;
        textColor = "none";
      };

      # KeyboardLayout widget settings
      keyboardLayout = {
        displayMode = "onhover";
        showIcon = true;
        iconColor = "none";
        textColor = "none";
      };

      # LockKeys widget settings
      lockKeys = {
        showCapsLock = true;
        showNumLock = true;
        showScrollLock = false;
      };

      # SystemMonitor widget settings
      systemMonitor = {
        compactMode = true;
        iconColor = "none";
        textColor = "none";
        showCpuUsage = true;
        showCpuTemp = true;
        showMemoryUsage = true;
        showNetworkStats = false;
        showDiskUsage = false;
      };

      # MediaMini widget settings
      mediaMini = {
        hideMode = "hidden";
        showAlbumArt = true;
        showArtistFirst = true;
        showVisualizer = false;
        displayMode = "onhover";
      };

      # NotificationHistory widget settings
      notificationHistory = {
        showUnreadBadge = true;
        iconColor = "none";
      };

      # ControlCenter widget settings
      controlCenter = {
        useDistroLogo = false;
        icon = "settings";
        iconColor = "none";
      };

      # Brightness widget settings
      brightness = {
        displayMode = "onhover";
        iconColor = "none";
        textColor = "none";
        applyToAllMonitors = false;
      };

      colorSchemes = {
        predefinedScheme = "Monochrome";
      };

      general = {
        avatarImage = "${config.home.homeDirectory}/.face";
        radiusRatio = 0.2;
        scaleRatio = 1.3;
      };

      location = {
        monthBeforeDay = true;
        name = "Singapore, Singapore";
      };

      # Wallpaper settings (Noctalia handles wallpapers)
      wallpaper = {
        enabled = true;
        directory = "${config.home.homeDirectory}/pics/wallpapers";
        automationEnabled = false;
        wallpaperChangeMode = "random";
        fillMode = "crop";
        sortOrder = "name";
        # Optional:
        # enableMultiMonitorDirectories = false;
        # showHiddenFiles = false;
        # linkLightAndDarkWallpapers = true;
      };
    };
  };
}
