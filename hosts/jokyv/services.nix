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
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    extraConfig.pipewire = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 256;
        "default.clock.min-quantum" = 256;
        "default.clock.max-quantum" = 512;
      };

      "context.modules" = [
        {
          name = "libpipewire-module-rtkit";
          args = ''
            {
              nice.level = -11
              rt.prio = 88
              rt.prio-override = 88
            }
          '';
        }
      ];
    };
  };

  # Display Management
  # services.displayManager.ly.enable = true;
  services.getty.autologinUser = "jokyv";

  # System Services
  services.dbus = {
    enable = true;
    implementation = "broker";
  };

  # Desktop Integration
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
    ];
    config.common.default = [ "*" ];
  };

}
