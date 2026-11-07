{
  inputs,
  lib,
  pkgs,
  ...
}:

{
  _module.args.primaryUser = "dora";
  imports = [
    ../jokyv/security.nix
    ../jokyv/maintenance.nix
    ../jokyv/btrfs.nix
    ../users/jokyv.nix
    ../users/dora.nix
    inputs.home-manager.nixosModules.home-manager
    ./desktop.nix
  ];

  time.timeZone = "Asia/Singapore";

  # Bootloader
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };
  };

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

  # Activate both users' Home Manager profiles with the system.
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.jokyv = {
      imports = [ ../../home/users/jokyv.nix ];
      home.stateVersion = "24.05";
    };
    users.dora = {
      imports = [ ../../home/users/dora.nix ];
      home.stateVersion = "24.05";
    };
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

  # The shared maintenance module assumes a working host output and checkout.
  # Enable these only after the GNOME machine and its repository are provisioned.
  system.autoUpgrade.enable = lib.mkForce false;
  systemd.timers.prefetch-system-closure.enable = lib.mkForce false;
  systemd.paths.prefetch-system-closure.enable = lib.mkForce false;

  # Memory
  zramSwap.enable = false;

  system.stateVersion = "24.05";
}
