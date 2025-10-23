{ inputs, pkgs, ... }:

let
  userHome = builtins.getEnv "HOME";
in
{
  imports = [
    # disko configuration
    inputs.disko.nixosModules.disko
    ./disk/disk-config-btrfs.nix
    # zsa keyboard configuration
    ./zsa-udev-rules.nix
    # security configuration
    ./security.nix
    # services configuration
    ./services.nix
    # btrfs configuration
    ./btrfs.nix
    # import niri module
    inputs.niri.nixosModules.niri
  ];

  # Set your time zone.
  time.timeZone = "Asia/Singapore";

  # ---------------------------------------------
  # Bootloader Configuration
  # ---------------------------------------------
  boot.loader = {
    # Use systemd-boot as the bootloader
    systemd-boot = {
      enable = true;
      # Limit the number of previous generations to keep
      configurationLimit = 10;
    };
    # Allow systemd-boot to manage EFI variables
    efi.canTouchEfiVariables = true;
  };
  # boot.kernelPackages = pkgs.LinuxPackages_hardened;

  # ---------------------------------------------
  # Networking Configuration
  # ---------------------------------------------
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ]; # Reliable DNS
    enableIPv6 = true; # Keep IPv6 enabled
  };

  # ---------------------------------------------
  # Hardware Configuration
  # ---------------------------------------------

  # update the CPU microcode for AMD processors
  hardware.cpu.amd.updateMicrocode = true;

  # Enable Bluetooth hardware support with security settings
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Enable profiles
        Enable = "Source,Sink,Media,Socket";
        # Security and privacy
        DiscoverableTimeout = 180; # Stop being discoverable after 3 minutes
        PairableTimeout = 0; # Stay pairable indefinitely
        Privacy = "device"; # Use device mode for better privacy
        ControllerMode = "dual"; # Support both BR/EDR and LE
        # Experimental features
        Experimental = true; # Enable experimental features if needed
      };
      Policy = {
        AutoEnable = true; # Auto-enable when devices are connected
        ReconnectAttempts = 7; # Number of reconnect attempts
        ReconnectIntervals = "1, 2, 3"; # Intervals between attempts in seconds
        # Class = "0x200414"; # Restrict to specific device class if desired
      };
    };
  };

  # ---------------------------------------------
  # System Programs
  # ---------------------------------------------
  programs.niri.enable = true;
  programs.niri.package = pkgs.niri;

  programs.nix-ld.enable = true; # needs this for python uv

  # ---------------------------------------------
  # User Configuration
  # ---------------------------------------------
  # Don't forget to set a password with 'passwd'.
  users.users.jokyv = {
    isNormalUser = true;
    description = "jokyv";
    # initialPassword = "";
    shell = pkgs.bashInteractive;
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "input"
      "bluetooth"
    ];
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
    aider-chat-full
    clang
    cmake
    gcc
    gdb
    git
    (python313.withPackages (ps: with ps; [
        pyyaml
        rich
        # add other python packages you need here
    ]))

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

  # check by running 'systemctl list-timers'

  nix = {
    # auto optimisation
    optimise = {
      automatic = true;
      dates = "weekly";
      persistent = true;
    };

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
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "jokyv"
      ];
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
    # flake = "github:jokyv/nixos-config";
    flake = "${userHome}/nixos-config";
    flags = [
      "--update-input"
      "nixpkgs"
      "--commit-lock-file"
    ];
    persistent = true;
  };

  # ---------------------------------------------
  # Performance Settings
  # ---------------------------------------------
  # Use ZRAM for compressed RAM-based swap. It's much faster than disk-based swap.
  # The system will use this first and only fall back to the disk swap partition if ZRAM fills up.
  zramSwap.enable = true;
  zramSwap.memoryPercent = 50; # Default is 50% already

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
