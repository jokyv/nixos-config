{ pkgs, ... }:

{
  imports = [
    ../jokyv/security.nix
    ../jokyv/maintenance.nix
    ../jokyv/btrfs.nix
    ./desktop.nix
  ];

  time.timeZone = "Asia/Singapore";

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking = {
    hostName = "dora";
    networkmanager.enable = true;
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    enableIPv6 = true;
  };

  # User
  users.users.dora = {
    isNormalUser = true;
    description = "dora";
    shell = pkgs.bashInteractive;
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "input"
      "bluetooth"
      "plugdev"
    ];
  };

  users.users.root = {
    hashedPassword = "!";
    shell = "${pkgs.shadow}/bin/nologin";
  };

  # Locale
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocales = [
      "en_US.UTF-8/UTF-8"
      "el_GR.UTF-8/UTF-8"
    ];
  };

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_SG.UTF-8";
    LC_IDENTIFICATION = "en_SG.UTF-8";
    LC_MEASUREMENT = "en_SG.UTF-8";
    LC_MONETARY = "en_SG.UTF-8";
    LC_NAME = "en_SG.UTF-8";
    LC_NUMERIC = "en_SG.UTF-8";
    LC_PAPER = "en_SG.UTF-8";
    LC_TELEPHONE = "en_SG.UTF-8";
    LC_TIME = "en_SG.UTF-8";
  };

  # Memory
  zramSwap.enable = false;

  system.stateVersion = "24.05";
}
