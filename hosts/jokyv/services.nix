{ pkgs, ... }:

{
  # Bluetooth
  services.blueman.enable = true;
  # Configure Bluetooth service with security settings
  services.bluetooth = {
    enable = true;
    settings = {
      General = {
        # Enable profiles
        Enable = "Source,Sink,Media,Socket";
        # Security and privacy
        DiscoverableTimeout = 180; # Stop being discoverable after 3 minutes
        PairableTimeout = 0; # Stay pairable indefinitely
        Privacy = "device"; # Use device mode for better privacy
        ControllerMode = "dual"; # Support both BR/EDR and LE
        # Experimental features
        Experimental = true; # Enable experimental features if needed
      };
      Policy = {
        AutoEnable = true; # Auto-enable when devices are connected
        ReconnectAttempts = 7; # Number of reconnect attempts
        ReconnectIntervals = "1, 2, 3"; # Intervals between attempts in seconds
        # Class = "0x200414"; # Restrict to specific device class if desired
      };
    };
  };

  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Display Management
  services.displayManager.ly.enable = true;

  # System Services
  services.dbus = {
    enable = true;
    implementation = "broker";
  };

  # Desktop Integration
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-wlr
    ];
    config.common.default = [ "*" ];
  };

}
