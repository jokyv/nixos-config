{ pkgs, ... }:

{
  # GNOME desktop
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.gnome.gnome-keyring.enable = true;
  programs.dconf.enable = true;

  # Desktop plumbing
  services.dbus = {
    enable = true;
    implementation = "broker";
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  services.fwupd.enable = true;
  services.fstrim.enable = true;
  services.blueman.enable = true;
  hardware.enableRedistributableFirmware = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gnome ];
    config.common.default = [ "gnome" ];
  };

  environment.systemPackages = with pkgs; [
    firefox
    evince
    gnome-calculator
    gnome-text-editor
    loupe
    nautilus
  ];
}
