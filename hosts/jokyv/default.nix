{ inputs, pkgs, ... }:

{
  imports = [
    # disko configuration
    inputs.disko.nixosModules.disko
    ../../disks/universal-config.nix
    # zsa keyboard configuration
    ./zsa-udev-rules.nix
    # security configuration
    ./security.nix
    # services configuration
    ./services.nix
    # btrfs configuration
    ./btrfs.nix
    # maintenance automation
    ./maintenance.nix
    # import niri module
    inputs.niri.nixosModules.niri
    # CPU-specific optimizations
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
  ];

  # Set your time zone.
  time.timeZone = "Asia/Singapore";

  # ---------------------------------------------
  # Bootloader Configuration
  # ---------------------------------------------
  # Use systemd-boot as the bootloader, alternatively use GRUB
  boot.loader.systemd-boot.enable = true;
  # Limit the number of previous generations to keep
  boot.loader.systemd-boot.configurationLimit = 10;
  # Allow systemd-boot to manage EFI variables
  boot.loader.efi.canTouchEfiVariables = true;

  # Performance kernel parameters
  boot.kernelParams = [
    "nowatchdog" # Disable watchdog timer - reduces interrupts
    "split_lock_detect=off" # Improve performance on some workloads
    # "mitigations=off" # Disable security mitigations for performance (NOT recommended for production)
    # "preempt=full" # Full preemption for desktop responsiveness
  ];

  # Performance-oriented sysctl (security hardening in security.nix)
  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642; # Required for some games (Star Citizen, etc.)
    "vm.swappiness" = 10; # Prefer RAM over swap
    "kernel.sched_autogroup_enabled" = 1; # Better interactive task grouping
    "vm.vfs_cache_pressure" = 50; # Controls tendency to reclaim VFS cache
    "vm.dirty_bytes" = 268435456; # Start writeback at 256MB
    "vm.dirty_background_bytes" = 67108864; # Background writeback at 64MB
    "vm.dirty_writeback_centisecs" = 1500; # Writeback interval 15 seconds
    "vm.transhuge" = "madvise"; # Transparent Huge Pages madvise mode
    "net.ipv4.tcp_congestion_control" = "bbr"; # BBR TCP congestion control
    "kernel.nmi_watchdog" = 0; # Disable NMI watchdog (hard lockup detector)
    "kernel.unprivileged_userns_clone" = 1; # Allow unprivileged containers
    "kernel.printk" = "3 3 3 3"; # Kernel printk settings
    "net.core.netdev_max_backlog" = 4096; # Increase network device backlog
    "fs.file-max" = 2097152; # Increase file handles and inode cache
  };

  # ---------------------------------------------
  # Gaming Optimizations
  # ---------------------------------------------
  programs.gamemode = {
    enable = true;
    settings = {
      gamemode.start_reason = "GameMode activated";
      gamemode.end_reason = "GameMode deactivated";
      gamemode.enable_render_boost = true;
      gamemode.enable_soft_realtime = true;
      gamemode.io_rebalance_ioprio = true;
    };
  };

  hardware.steam-hardware.enable = true;
  # boot.kernelPackages = pkgs.LinuxPackages_hardened;

  # ---------------------------------------------
  # Audio Configuration
  # ---------------------------------------------
  boot.extraModprobeConfig = ''
    options snd_hda_intel model=generic
  '';
  # ---------------------------------------------
  # Networking Configuration
  # ---------------------------------------------
  networking = {
    # Hostname is now configured in install-config.nix and applied via universal-config.nix
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

  # Graphics support for Steam/games
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

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
  # programs.nix-ld.libraries = with pkgs; [
  #   stdenv.cc.cc.lib # Required for most Rust/Python binaries
  #   zlib # Common dependency
  # ];

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
      "plugdev"
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
    sniffnet

    # Development Tools
    clang
    cmake
    gcc
    gdb
    git

    # Network Utilities
    curl
    wget
    openssh

    # Multimedia
    ffmpeg
    mesa

    # Wayland
    xwayland
    xwayland-satellite
    wayland

    # Graphics and Vulkan
    vulkan-tools
    mesa-demos

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
  # Performance Settings
  # ---------------------------------------------
  # Use ZRAM for compressed RAM-based swap. It's much faster than disk-based swap.
  # The system will use this first and only fall back to the disk swap partition if ZRAM fills up.
  zramSwap.enable = true;
  zramSwap.memoryPercent = 50; # Default is 50% already
  zramSwap.algorithm = "zstd"; # Use zstd compression
  zramSwap.priority = 100; # Higher priority than disk swap

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
