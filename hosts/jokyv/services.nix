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
      xdg-desktop-portal-gnome
      xdg-desktop-portal-wlr
    ];
    config.common.default = [ "*" ];
  };

  # ZRAM Configuration - handled by systemd-zram-generator
  # This creates /dev/zram0 with swap automatically
  systemd.services."systemd-zram-setup@zram0" = {
    enable = true;
    description = "Create swap on /dev/zram0";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.zram-generator}/bin/zram-generator --setup-device zram0";
      ExecStop = "${pkgs.zram-generator}/bin/zram-generator --reset-device zram0";
    };
    wantedBy = [ "swap.target" ];
    before = [ "swap.target" ];
  };

}
