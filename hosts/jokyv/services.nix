{ pkgs, ... }:

{
  # Enable DBUS service that allows applications to update firmware
  services.fwupd.enable = true;

  # Enable SSD TRIM of mounted partitions in background
  services.fstrim.enable = true;

  # Bluetooth
  services.blueman.enable = true;

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
