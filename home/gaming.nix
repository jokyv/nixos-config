{
  config,
  pkgs,
  pkgs-stable,
  lib,
  ...
}:

{
  imports = [
    # SHELL
    ./programs/bash.nix

    # TERMINAL
    ./programs/foot.nix
    ./programs/kitty.nix

    # BROWSER
    ./programs/firefox.nix
    ./programs/brave.nix

    # WINDOW MANAGER & UI
    ./programs/niri.nix
    ./programs/waybar.nix
    ./programs/swww.nix
    ./programs/fnott.nix
    ./programs/gammastep.nix
    ./programs/swaylock.nix

    # THEMING
    ./programs/stylix.nix
    ./programs/starship.nix

    # UTILITIES
    ./programs/git.nix

    # ENVIRONMENT
    ./env.nix
  ];

  home.username = "jokyv";
  home.homeDirectory = "/home/jokyv";
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  # ---------------------------------------------
  # SOPS configuration
  # ---------------------------------------------
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/secrets.key";
    defaultSopsFile = ../secrets.enc.yaml;
    defaultSopsFormat = "yaml";

    secrets = {
      base_path = { };
      notes_path = { };
      notes_remote = { };
      name = { };
      email = { };
    };
  };

  # ---------------------------------------------
  # Allow certain unfree packages
  # ---------------------------------------------
  nixpkgs.config = {
    allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-original"
        "steam-unwrapped"
        "steam-run"
      ];
  };

  # ---------------------------------------------
  # Install packages
  # ---------------------------------------------
  home.packages =
    with pkgs;
    [
      # Gaming
      steam

      # Screen Capture & Clipboard (needed for niri)
      grim
      slurp
      swappy
      cliphist
      wl-clipboard
      wtype

      # Fonts
      font-awesome
      noto-fonts
      noto-fonts-color-emoji

      # System utilities
      btop
      just

      # XDG utilities
      xdg-utils
    ];

  # ---------------------------------------------
  # systemd
  # ---------------------------------------------
  systemd.user.startServices = "sd-switch";

  # ---------------------------------------------
  # Set XDG user directories
  # ---------------------------------------------
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "${config.home.homeDirectory}";
    download = "${config.home.homeDirectory}/downloads";
    pictures = "${config.home.homeDirectory}/pics";
    templates = "${config.home.homeDirectory}";
    publicShare = "${config.home.homeDirectory}";
    documents = "${config.home.homeDirectory}";
    music = "${config.home.homeDirectory}";
    videos = "${config.home.homeDirectory}";
    extraConfig = {
      PROJECTS = "${config.home.homeDirectory}/projects";
    };
  };

  # ---------------------------------------------
  # State Version
  # ---------------------------------------------
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
