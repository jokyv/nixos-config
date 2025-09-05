{ inputs, pkgs, ... }:

{
  imports =
    [
      # hardware configuration
      ./hardware-configuration.nix
      ./zsa-udev-rules.nix
      inputs.niri.nixosModules.niri
    ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 20;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel security settings
  boot.kernel.sysctl = {
    "fs.protected_fifos" = 2;
    "fs.protected_regular" = 2;
    "fs.suid_dumpable" = false;
    "kernel.kptr_restrict" = 2;
    "kernel.sysrq" = false;
    "kernel.unprivileged_bpf_disabled" = true;

    "net.core.bpf_jit_harden" = 2;

    "net.ipv4.conf.all.accept_redirects" = false;
    "net.ipv4.conf.default.accept_redirects" = false;

    "net.ipv6.conf.all.accept_redirects" = false;
    "net.ipv6.conf.default.accept_redirects" = false;

    "net.ipv4.conf.all.log_martians" = true;
    "net.ipv4.conf.default.log_martians" = true;

    "net.ipv4.conf.all.rp_filter" = true;
    "net.ipv4.conf.all.send_redirects" = false;
  };

  # Blacklist unnecessary kernel modules
  boot.blacklistedKernelModules = [
    "dccp"
    "sctp"
    "rds"
    "tipc"
  ];

  # File systems
  fileSystems."/proc" = {
    device = "proc";
    fsType = "proc";
    options = [ "defaults" "hidepid=2" ];
    # unclear if this is actually needed
    neededForBoot = true;
  };

  # Enable networking
  networking =
    {
      hostName = "nixos";
      networkmanager.enable = true;
      firewall.enable = true;
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

  services.displayManager.ly.enable = true;
  services.xserver.enable = true;
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
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
    shell = pkgs.bash;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Security settings
  security.sudo.execWheelOnly = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    brightnessctl # Screen brightness
    clang
    cmake # Often used with C++ projects
    curl
    gcc
    gdb # Debugger
    git
    helix
    killall
    libnotify
    libglibutil
    lshw # Hardware info
    lynis
    mesa
    openssh
    pciutils # lspci
    python312
    ffmpeg
    smartmontools # disk health
    usbutils # lsusb
    wget

    # wayland
    xwayland
    wayland
  ];

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocales = [
      "en_US.UTF-8/UTF-8"
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05";

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
    };
  };

  # Automatic system updates
  system.autoUpgrade = {
    enable = true;
    dates = "daily";
    allowReboot = false;
    flake = "github:jokyv/nixos-config";
    flags = [ "--update-input" "nixpkgs" "--commit-lock-file" ];
  };
}
