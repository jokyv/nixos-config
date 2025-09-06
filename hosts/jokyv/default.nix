{ inputs, pkgs, ... }:

{
  imports =
    [
      # hardware configuration
      ./hardware-configuration.nix
      ./zsa-udev-rules.nix
      inputs.niri.nixosModules.niri
      # security configuration
      ./security.nix
    ];

  # ---------------------------------------------
  # Bootloader
  # ---------------------------------------------

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 20;
  boot.loader.efi.canTouchEfiVariables = true;

  # ---------------------------------------------
  # Kernel
  # ---------------------------------------------


  # Enable networking
  networking =
    {
      hostName = "nixos";
      networkmanager.enable = true;
      # Firewall is now managed in security.nix
      # Open ports in the firewall.
      # networking.firewall.allowedTCPPorts = [ ... ];
      # networking.firewall.allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      # networking.firewall.enable = false;
    };

  # Set your time zone.
  time.timeZone = "Asia/Singapore";

  # Enable sound with PipeWire.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.displayManager.ly.enable = true;
  # X server is likely not needed when using niri (Wayland compositor)
  # services.xserver.enable = true;

  services.dbus = {
    enable = true;
    implementation = "broker";
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      # xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
      xdg-desktop-portal-wlr
    ];
    config.common.default = [ "*" ];
  };

  programs.niri.enable = true;
  programs.nix-ld.enable = true; # needs this for python uv

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jokyv = {
    isNormalUser = true;
    description = "jokyv";
    shell = pkgs.bashInteractive;
    extraGroups = [ "networkmanager" "wheel" "video" "input" ];
  };


  # List packages installed in system profile.
  # To search, run: 'nix search wget'
  environment.systemPackages = with pkgs; [
    # System utilities
    brightnessctl
    killall
    lshw
    lynis
    smartmontools
    usbutils
    pciutils
    htop
    file
    which

    # Development tools
    clang
    cmake
    gcc
    gdb
    git
    python312

    # Text editors
    helix

    # Network utilities
    curl
    wget
    openssh

    # Multimedia
    ffmpeg
    mesa

    # Wayland
    xwayland
    wayland

    # Graphics and vulkan
    vulkan-tools
    glxinfo

    # Archive tools
    unzip
    p7zip

    # Other
    libnotify
    libglibutil
  ];

  # ---------------------------------------------
  # Internationalisation properties.
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
  # Systemd
  # ---------------------------------------------

  # Systemd service security hardening
  systemd.services.systemd-rfkill = {
    serviceConfig = {
      ProtectSystem = "strict";
      ProtectHome = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      ProtectClock = true;
      ProtectProc = "invisible";
      ProcSubset = "pid";
      PrivateTmp = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      LockPersonality = true;
      RestrictRealtime = true;
      SystemCallArchitectures = "native";
      UMask = "0077";
      IPAddressDeny = "any";
    };
  };

  systemd.services.systemd-journald = {
    serviceConfig = {
      UMask = "0077";
      PrivateNetwork = true;
      ProtectHostname = true;
      ProtectKernelModules = true;
    };
  };

  # Additional security for other systemd services
  # systemd.services.NetworkManager = {
  #   serviceConfig = {
  #     ProtectSystem = "strict";
  #     ProtectHome = true;
  #     PrivateTmp = true;
  #   };
  # };

  # ---------------------------------------------
  # Automation
  # ---------------------------------------------

  # check with 'systemctl list-timers'

  nix = {
    # Garbage collection settings
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    # General nix settings
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "jokyv" ];
      warn-dirty = false;
      # Enable binary caches for faster builds
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
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05";
}
