{ config, pkgs, lib, ... }:

{
  programs.noctalia.settings = {
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
      showLogout = true;
      showReboot = true;
      showShutdown = true;
      showSuspend = true;
      countdownDuration = 5000;
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

    # Brightness widget + brightness control settings
    brightness = {
      displayMode = "onhover";
      iconColor = "none";
      textColor = "none";
      applyToAllMonitors = false;
      brightnessStep = 5;
      enforceMinimum = true;
      enableDdcSupport = true;
      backlightDeviceMappings = [ ];
    };

    # System monitor settings
    systemMonitor = {
      cpuWarningThreshold = 80;
      cpuCriticalThreshold = 90;
      tempWarningThreshold = 80;
      tempCriticalThreshold = 90;
      gpuWarningThreshold = 80;
      gpuCriticalThreshold = 90;
      memWarningThreshold = 80;
      memCriticalThreshold = 90;
      swapWarningThreshold = 80;
      swapCriticalThreshold = 90;
      diskWarningThreshold = 80;
      diskCriticalThreshold = 90;
      diskAvailWarningThreshold = 20;
      diskAvailCriticalThreshold = 10;
      batteryWarningThreshold = 20;
      batteryCriticalThreshold = 5;
      enableDgpuMonitoring = false;
      useCustomColors = false;
      warningColor = "";
      criticalColor = "";
      externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
    };
  };
}
