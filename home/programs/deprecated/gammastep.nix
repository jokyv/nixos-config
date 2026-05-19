{
  services.gammastep = {
    enable = true;

    # Location provider and coordinates.
    # 'manual' requires setting latitude/longitude.
    # 'geoclue2' can be used for automatic location detection.
    provider = "manual";
    latitude = 1.0;
    longitude = 103.0;

    # Color temperature in Kelvin.
    # Lower values are warmer (more red), higher values are cooler (more blue).
    temperature = {
      day = 5000;
      night = 4000;
    };

    # Enable a system tray icon for easy control.
    tray = true;

    # Advanced configuration options.
    settings = {
      general = {
        # Use 'wayland' for Wayland compositors like Niri.
        adjustment-method = "wayland";
        # Duration of the smooth transition between temperatures (in milliseconds).
        fade = 1000;
      };
    };
  };
}
