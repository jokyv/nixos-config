{ config, pkgs, ... }:

{
  imports = [

    # SHELL
    ./programs/bash.nix
    ./programs/nu.nix
    # ./programs/xonsh.nix

    # TERMINAL
    ./programs/foot.nix
    ./programs/kitty.nix

    # BROWSER
    # ./programs/brave.nix
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
    ./programs/ripgrep.nix
    ./programs/starship.nix
    ./programs/stylix.nix
    ./programs/swaylock.nix
    ./programs/waybar.nix
    ./programs/waypaper.nix
    ./programs/yazi.nix
    ./programs/zathura.nix
    ./programs/zoxide.nix

    ./env.nix

    # ./programs/ly.nix # home-manager does not support it yet
    # ./programs/nh.nix # errors....

  ];


  home.username = "jokyv";
  home.homeDirectory = "/home/jokyv";

  # SOPS configuration
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/secrets.key";
    # age.keyFile = "${userConfig.home}/.config/sops/age/nix-secrets.key";
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

  # install packages with their default configs
  home.packages = with pkgs; [
    alacritty
    base16-schemes
    brave
    btop
    cowsay
    dconf
    ddgr # duckduckgo on the terminal
    delta
    eza
    fzf
    git-cliff
    just
    jq
    libreoffice-qt-fresh # no space left for this app
    nautilus
    nh
    psst
    pwvucontrol
    tabiew
    trashy
    typos
    unimatrix
    uv
    virtualenv # need this for python virtual env
    xonsh
    zathura

    # Take screenshot
    grim
    slurp
    swappy

    # Clipboard
    cliphist
    wl-clipboard
    wtype # need this for my script clip_hist.py

    # Fonts
    font-awesome
    liberation_ttf
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji

    # Language servers
    bash-completion
    bash-language-server
    dprint
    markdown-oxide
    marksman
    nixd
    nixpkgs-fmt
    nufmt
    shfmt
    taplo
    vscode-langservers-extracted
    yaml-language-server

    # Secrets
    age
    gitleaks
    git-crypt
    sops
  ];


  nixpkgs.config.allowUnfreePredicate =
    pkg: builtins.elem (pkgs.lib.getName pkg) [
      "discord"
    ];


  # install packages AND specify their configs
  # environment variables
  # environment.variables = {
  #   SECRET_KEY = "";
  #   PATH = [ "" ];
  #   EDITOR = "hx"
  # };
  #
  # syncs automatically the repo with github
  # services.git-sync = {
  #  enable = true;
  #  repositories = {
  #    "my-repo" = {
  #      path = "/home/jokyv/xxx/xxxx";
  #      uri = "https://github.com/user/repo.git";
  #     interval = "300"; # Sync every 5 minutes
  #    };
  #  };
  #};

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
  # programs.home-manager.backupFileExtension = "backup"; # error option does not exist
  # programs.home-manager.useGlobalPkgs = true;
  # programs.home-manager.useUserPackages = true;

  # ---------------------------------------------
  # Create specific folders in home directory
  # ---------------------------------------------

  # home.file = {
  #   "downloads".source = config.lib.file.mkOutOfStoreSymlink "/home/${config.home.username}/downloads";
  #   "projects".source = config.lib.file.mkOutOfStoreSymlink "/home/${config.home.username}/projects";
  #   "pics".source = config.lib.file.mkOutOfStoreSymlink "/home/${config.home.username}/pics";
  # };

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
}
