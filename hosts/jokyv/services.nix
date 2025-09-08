{ pkgs, ... }:

{
  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Display Management
  services.displayManager.ly.enable = true;

  # Desktop Integration
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-wlr
    ];
    config.common.default = [ "*" ];
  };

  # System Services
  services.dbus = {
    enable = true;
    implementation = "broker";
  };
}
