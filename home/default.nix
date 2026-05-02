{
  config,
  pkgs,
  pkgs-stable,
  lib,
  ...
}:

let
  newClaudeVersion = "2.1.92"; # Latest available as of 2026-04-04

  # Override claude-code-bin to a newer version because 2.1.88 binary URLs are dead
  claudeCodeBinOverlay = final: prev: {
    claude-code-bin = prev.claude-code-bin.overrideAttrs (old: {
      version = newClaudeVersion;
      src = prev.fetchurl {
        url = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/${newClaudeVersion}/linux-x64/claude";
        # hash will be computed on first build with --impure, then fill in the correct value
        # For now use a placeholder - the build will fail and show the expected hash
        hash = "sha256-4iMkUUln/y1en5Hw7jfkZ1v4tt/sJ/r7GcslzFsj/K8=";
      };
    });
  };

in
{
  nixpkgs.overlays = [ claudeCodeBinOverlay ];
  imports = [

    # SHELL
    ./programs/bash.nix
    # ./programs/nu.nix
    # ./programs/xonsh.nix

    # TERMINAL
    ./programs/foot.nix
    ./programs/kitty.nix

    # BROWSER
    ./programs/brave.nix
    ./programs/firefox.nix

    # AI
    ./programs/claude.nix
    # ./programs/pi-agent.nix

    # APP LAUNCHERS
    # ./programs/vicinae.nix
    # ./programs/fuzzel.nix # need it for my personal scripts

    # OTHER
    ./programs/atuin.nix
    ./programs/bat.nix
    ./programs/fastfetch.nix
    ./programs/fd.nix
    # ./programs/fnott.nix
    ./programs/fzf.nix
    ./programs/ruff.nix
    ./programs/ty.nix
    # ./programs/gammastep.nix
    ./programs/wlsunset.nix
    ./programs/git.nix
    ./programs/helix.nix
    ./programs/niri.nix
    ./programs/nh.nix
    ./programs/obsidian.nix
    ./programs/ripgrep.nix
    ./programs/starship.nix
    ./programs/stylix.nix
    # ./programs/swaylock.nix
    # ./programs/waybar.nix
    # ./programs/swww.nix
    ./programs/yazi.nix
    ./programs/zathura.nix
    ./programs/zoxide.nix

    ./programs/git-sync-notes.nix
    ./env.nix

    ./programs/noctalia/default.nix
  ];

  home.username = "jokyv";
  home.homeDirectory = "/home/jokyv";
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    OBSIDIAN_USE_WAYLAND = "1";
    DISCORD_USE_WAYLAND = "1";
    ELECTRON_OZONE_PLATFORM = "wayland";
    OZONE_PLATFORM = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    # Suppress Nix 2.24+ deprecation warnings (e.g., 'nix profile install' is deprecated)
    NIX_IGNORE_DEPRECATIONS = "1";
  };

  # Desktop widgets handled via noctalia.nix (desktopWidgets section)

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
      tasks_path = { };
      tasks_remote = { };
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
        # Add unfree package names here
        "obsidian"
        "discord"
        "keymapp"
        "claude-code"
        "claude-code-bin" # using binary version to avoid npm build issues
      ];
  };

  # ---------------------------------------------
  # Install packages with their default configs
  # ---------------------------------------------
  home.packages =
    with pkgs;
    [
      # -----------------------------------------
      # Unstable Packages (from pkgs)
      # -----------------------------------------

      # NPM
      bun

      # Shells & Terminals
      alacritty

      # Development Tools
      neovim
      git-cliff
      gh
      jaq
      just
      jq
      gum
      uv
      virtualenv # need this for python virtual env

      # Rust and tools
      rustc
      cargo
      clippy
      rustfmt
      rust-analyzer
      cargo-watch
      cargo-edit

      # Python with packages
      (python313.withPackages (
        ps: with ps; [
          requests
          pyyaml
          rich
        ]
      ))

      # GUI Applications
      discord
      keymapp
      nautilus
      psst # A spotify client

      # GNOME Apps
      gnome-calendar
      evince
      gnome-maps
      gnome-clocks
      gnome-contacts
      gnome-calculator

      # System Utilities
      base16-schemes
      btop
      cbonsai
      cowsay
      dconf
      ddgr # duckduckgo on the terminal
      delta
      dysk
      eza
      newsraft
      pwvucontrol
      tabiew
      trashy
      unimatrix

      # Screen Capture & Clipboard
      grim
      slurp
      swappy
      cliphist
      wl-clipboard
      wtype # need this for my script clip_hist.py

      # Fonts
      # maple-mono.Normal-NF
      font-awesome
      liberation_ttf
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji

      # Language Servers
      bash-completion
      bash-language-server
      dprint
      # ltex-ls-plus # more strict than typos
      markdown-oxide # https://oxide.md/v0/Articles/Markdown-Oxide+v0
      # marksman # using markdown-oxide currently
      nixd
      nixfmt # official nix formatter, formats one file at a time.
      nixfmt-tree # official nix formatter, formats whole project.
      nufmt
      # python313Packages.python-lsp-server
      # ty  # Managed by home-manager module (./programs/ty.nix)
      shfmt
      taplo
      typos
      typos-lsp
      vscode-langservers-extracted
      yaml-language-server
      just-lsp

      # Security Tools
      age
      gitleaks
      git-crypt
      sops

      # XDG utilities
      xdg-utils

    ]

    # -------------------------------------------
    # Stable Packages (from pkgs-stable)
    # -------------------------------------------
    ++ (with pkgs-stable; [

      # GUI Applications
      libreoffice-qt-fresh
    ]);

  # ---------------------------------------------
  # systemd
  # ---------------------------------------------

  # Only reload system units when changing configs [EXPERIMENT]
  systemd.user.startServices = "sd-switch";

  # ---------------------------------------------
  # Set XDG user directories
  # ---------------------------------------------
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true; # Keep legacy behavior for 24.05 stateVersion
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
  # GTK configuration (to silence warnings)
  # ---------------------------------------------
  gtk = {
    gtk4 = {
      theme = null; # Adopt new default (was config.gtk.theme)
    };
  };

  # ---------------------------------------------
  # Font configuration
  # ---------------------------------------------
  fonts.fontconfig.enable = true;

  # ---------------------------------------------
  # State Version
  # ---------------------------------------------
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
