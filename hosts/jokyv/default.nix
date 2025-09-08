{ inputs, pkgs, ... }:

{
  imports =
    [
      # hardware configuration
      ./hardware-configuration.nix
      # zsa keyboard configuration
      ./zsa-udev-rules.nix
      inputs.niri.nixosModules.niri
      # security configuration
      ./security.nix
    ];

  # ---------------------------------------------
  # Bootloader Configuration
  # ---------------------------------------------
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # ---------------------------------------------
  # Networking Configuration
  # ---------------------------------------------
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" "8.8.8.8" ]; # Reliable DNS
    enableIPv6 = true; # Keep IPv6 enabled
    # Firewall is now managed in security.nix
    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;
  };

  # Set your time zone.
  time.timeZone = "Asia/Singapore";

  # ---------------------------------------------
  # System Services
  # ---------------------------------------------


  # ---------------------------------------------
  # System Programs
  # ---------------------------------------------
  programs.niri.enable = true;
  programs.nix-ld.enable = true; # needs this for python uv

  # ---------------------------------------------
  # User Configuration
  # ---------------------------------------------
  # Don't forget to set a password with ‘passwd’.
  users.users.jokyv = {
    isNormalUser = true;
    description = "jokyv";
    shell = pkgs.bashInteractive;
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "input" ];
  };

  # Disable root account entirely for security
  users.users.root = {
    hashedPassword = "!"; # Lock root account (exclamation mark prevents login)
    shell = "${pkgs.shadow}/bin/nologin"; # Disable root shell access
  };


  # ---------------------------------------------
  # System Packages
  # ---------------------------------------------

  # To search, run: 'nix search wget'

  environment.systemPackages = with pkgs; [
    # System Utilities
    aide
    brightnessctl
    killall
    lshw
    logrotate
    lynis
    smartmontools
    usbutils
    pciutils
    htop
    file
    which
    rng-tools
    clamav

    # Development Tools
    clang
    cmake
    gcc
    gdb
    git
    python312

    # Network Utilities
    curl
    wget
    openssh

    # Multimedia
    ffmpeg
    mesa

    # Wayland
    xwayland
    wayland

    # Graphics and Vulkan
    vulkan-tools
    glxinfo

    # Archive Tools
    unzip
    p7zip

    # Other
    libnotify
    libglibutil
  ];

  # ---------------------------------------------
  # Internationalization Settings
  # ---------------------------------------------
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocales = [
      "en_US.UTF-8/UTF-8" # English US locale
      "el_GR.UTF-8/UTF-8" # Greek locale
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


  # ---------------------------------------------
  # System Automation
  # ---------------------------------------------

  # check with 'systemctl list-timers'

  nix = {
    # Garbage Collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
      persistent = true;
    };

    # Nix Configuration
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "jokyv" ];
      warn-dirty = false;

      # Binary caches for faster builds
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    # Enable nix-direnv for development environments
    package = pkgs.nixVersions.stable;
  };

  # Automatic system updates
  system.autoUpgrade = {
    enable = true;
    dates = "daily";
    allowReboot = false;
    flake = "github:jokyv/nixos-config";
    flags = [ "--update-input" "nixpkgs" "--commit-lock-file" ];
    persistent = true;
  };

  # ---------------------------------------------
  # System Version
  # ---------------------------------------------
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05";
}
