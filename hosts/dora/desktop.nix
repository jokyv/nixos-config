{ pkgs, ... }:

{
  services = {
    # GNOME desktop
    xserver.enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    gnome.gnome-keyring.enable = true;

    # Desktop plumbing
    dbus = {
      enable = true;
      implementation = "broker";
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    fwupd.enable = true;
    fstrim.enable = true;
    blueman.enable = true;
  };

  programs.dconf.enable = true;

  hardware = {
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
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
