{ inputs, config, pkgs, ... }:

{
  imports =
    [
      # hardware configuration
      ./hardware-configuration.nix
      inputs.niri.nixosModules.niri
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 20;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking =
    {
      hostName = "nixos";
      networkmanager.enable = true;
      # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    };

  # Set your time zone.
  time.timeZone = "Asia/Singapore";

  services.displayManager.ly.enable = true;
  services.xserver.enable = true;
  services.openssh.enable = true;

  programs.niri.enable = true;
  programs.nix-ld.enable = true; # for python uv

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jokyv = {
    isNormalUser = true;
    description = "jokyv";
    shell = pkgs.nushell;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    brightnessctl # Screen brightness
    btop
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
    mesa
    openssh
    pciutils # lspci
    pulseaudio # Audio control
    (python312.withPackages (ps: with ps; [
      python-lsp-server
      rich
      ruff
      pyyaml
      pygame
      pytube
      yt-dlp
    ]))
    ffmpeg
    smartmontools # disk health
    usbutils # lsusb
    waybar
    wayland
    wget
  ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_SG.UTF-8";

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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

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
    flake = "github:username/system";
    flags = [ "--update-input" "nixpkgs" "--commit-lock-file" ];
  };
}
