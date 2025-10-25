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
    # ./programs/nu.nix
    # ./programs/xonsh.nix

    # TERMINAL
    ./programs/foot.nix
    ./programs/kitty.nix

    # BROWSER
    ./programs/brave.nix
    ./programs/firefox.nix

    # OTHER
    ./programs/atuin.nix
    ./programs/bat.nix
    ./programs/fastfetch.nix
    ./programs/fd.nix
    ./programs/fnott.nix
    ./programs/fuzzel.nix
    ./programs/fzf.nix
    ./programs/gammastep.nix
    ./programs/git.nix
    ./programs/helix.nix
    ./programs/niri.nix
    ./programs/nh.nix
    ./programs/obsidian.nix
    ./programs/ripgrep.nix
    ./programs/starship.nix
    ./programs/stylix.nix
    ./programs/swaylock.nix
    ./programs/waybar.nix
    ./programs/swww.nix
    ./programs/yazi.nix
    ./programs/zathura.nix
    ./programs/zoxide.nix

    ./env.nix

    # ./programs/noctalia.nix
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

  nixpkgs.config = {
    allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        # Add unfree package names here
        "obsidian"
        "discord"
        "keymapp"
      ];
  };

  # ---------------------------------------------
  # Install packages with their default configs
  # ---------------------------------------------
  home.packages = with pkgs; [

    # Shells & Terminals
    alacritty

    # Development Tools
    neovim
    git-cliff
    gh
    jaq
    just
    gum
    uv
    virtualenv # need this for python virtual env

    # GUI Applications
    discord
    keymapp
    pkgs-stable.libreoffice-qt-fresh
    nautilus
    psst # A spotify client

    # System Utilities
    base16-schemes
    btop
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

    # AI & Automation
    # aider-chat
    # playwright-driver

    # Screen Capture & Clipboard
    grim
    slurp
    swappy
    cliphist
    wl-clipboard
    wtype # need this for my script clip_hist.py

    # Fonts
    font-awesome
    liberation_ttf
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji

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

    # quickshell
  ];

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
    desktop = "${config.home.homeDirectory}";
    download = "${config.home.homeDirectory}/downloads";
    pictures = "${config.home.homeDirectory}/pics";
    templates = "${config.home.homeDirectory}";
    publicShare = "${config.home.homeDirectory}";
    documents = "${config.home.homeDirectory}";
    music = "${config.home.homeDirectory}";
    videos = "${config.home.homeDirectory}";
    extraConfig = {
      XDG_PROJECTS_DIR = "${config.home.homeDirectory}/projects";
    };
  };

  # ---------------------------------------------
  # State Version
  # ---------------------------------------------
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
