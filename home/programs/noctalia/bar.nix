{ config, pkgs, lib, ... }:

{
  programs.noctalia-shell.settings = {
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
      # Keep 1px gap for compositor window placement
      enableExclusionZoneInset = true;
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
          { id = "ActiveWindow"; }
          {
            id = "Spacer";
            width = 8;
          }
          {
            id = "Network";
          }
          { id = "Volume"; }
          { id = "KeyboardLayout"; }
          {
            id = "Spacer";
            width = 8;
          }
          { id = "LockKeys"; }
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
          { id = "Docker"; }
          {
            id = "Spacer";
            width = 4;
          }
          { id = "MediaMini"; }
          { id = "NotificationHistory"; }
          { id = "ControlCenter"; }
          { id = "Brightness"; }
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
  };
}
