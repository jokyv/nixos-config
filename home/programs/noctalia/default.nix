{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./noctalia-widgets.nix
  ];

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
        fontScale = 1.05;
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
              labelMode = "icon";
              showNumbers = false;
              wrapWorkspaces = true;
              # Active workspace styling
              activeColor = "#00d9ff";
              activeBackground = "#1a3a4a";
              # Show indicators for occupied workspaces
              showOccupied = true;
              occupiedColor = "#888888";
              occupiedBackground = "#2a2a2a";
              # Urgent workspace styling
              urgentColor = "#ff5555";
              urgentBackground = "#3a1a1a";
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
              width = 4;
            }
            {
              id = "Docker";
              displayMode = "always";
              showContainers = true;
              showImages = false;
              showVolumes = false;
              showRunningOnly = true;
              iconColor = "none";
              textColor = "none";
            }
            {
              id = "Spacer";
              width = 4;
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
              id = "Spacer";
              width = 4;
            }
            {
              id = "Clock";
              formatHorizontal = "HH:mm ddd, MMM dd";
              formatVertical = "HH mm - MMM dd";
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

      # Docker/Container widget settings
      docker = {
        displayMode = "always";
        showContainers = true;
        showImages = false;
        showVolumes = false;
        showRunningOnly = true;
        iconColor = "none";
        textColor = "none";
        # Optional: custom format
        # format = "🐳 {count}";
      };

      # Calendar widget settings
      calendar = {
        displayMode = "always";
        showDate = true;
        showTime = false;
        format = "ddd, MMM dd";
        iconColor = "none";
        textColor = "none";
        # Show next calendar event if integrated with calendar provider
        showNextEvent = true;
        eventFormat = "%title% - %start%";
        eventIcon = "📅";
        # Optional: calendar provider (if supported)
        # provider = "evolution";
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

      # Dock settings
      dock = {
        enabled = true;
        position = "bottom";
        dockType = "floating";
        displayMode = "auto_hide";

        backgroundOpacity = 0.9;
        floatingRatio = 0.85;
        size = 0.95;

        showLauncherIcon = true;
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

      # Night Light (wlsunset)
      nightLight = {
        enabled = true;
        autoSchedule = true;
        nightTemp = "3400";
        dayTemp = "6500";
      };

      # Wallpaper settings (Noctalia handles wallpapers)
      wallpaper = {
        enabled = true;
        overviewEnabled = true;
        directory = "${config.home.homeDirectory}/pics/wallpapers";
        automationEnabled = true;
        wallpaperChangeMode = "random";
        randomIntervalSec = 600;
        skipStartupTransition = true;
        fillMode = "crop";
        sortOrder = "name";
        # Optional:
        # enableMultiMonitorDirectories = false;
        # showHiddenFiles = false;
        # linkLightAndDarkWallpapers = true;
      };

      # Desktop widgets (clock widget on wallpaper)
      desktopWidgets = {
        enabled = true;
        overviewEnabled = true;
        gridSnap = false;
        gridSnapScale = false;
      };
    };
  };
}
