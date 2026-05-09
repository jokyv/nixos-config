{ config, pkgs, lib, ... }:

{
  programs.noctalia-shell.settings = {
    # Notification settings
    notifications = {
      enabled = true;
      enableMarkdown = false;
      density = "default";
      location = "top_right";
      overlayLayer = true;
      backgroundOpacity = lib.mkForce 1;
      respectExpireTimeout = false;
      lowUrgencyDuration = 3;
      normalUrgencyDuration = 8;
      criticalUrgencyDuration = 15;
      clearDismissed = true;
      saveToHistory = {
        low = true;
        normal = true;
        critical = true;
      };
      sounds = {
        enabled = false;
        volume = 0.5;
        separateSounds = false;
        criticalSoundFile = "";
        normalSoundFile = "";
        lowSoundFile = "";
        excludedApps = "discord,firefox,chrome,chromium,edge";
      };
      enableMediaToast = false;
      enableKeyboardLayoutToast = true;
      enableBatteryToast = true;
    };

    # OSD settings (on-screen popup for volume/brightness changes)
    osd = {
      enabled = true;
      location = "top_right";
      autoHideMs = 2000;
      overlayLayer = true;
      backgroundOpacity = lib.mkForce 1;
      enabledTypes = [
        0
        1
        2
      ];
      monitors = [ ];
    };
  };
}
