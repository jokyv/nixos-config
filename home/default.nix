{ config, pkgs, lib, ... }:

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

    # ./programs/obsidian.nix # home-manager does not support it yet
    
    ./programs/nh.nix

  ];

  nixpkgs.config = {
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        # Add unfree package names here
        "obsidian"
        "discord"
        "keymapp"
      ];
    # permittedInsecurePackages = [ "electron-24" ];
  };

  home.username = "jokyv";
  home.homeDirectory = "/home/jokyv";
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    OBSIDIAN_USE_WAYLAND = "1";
    DISCORD_USE_WAYLAND = "1";
    # ELECTRON_OZONE_PLATFORM = "wayland";
    # OZONE_PLATFORM = "wayland";
    # MOZ_ENABLE_WAYLAND = "1";
    # MOZ_DBUS_REMOTE = "1";
    # ELECTRON_FALLBACK_TO_X11 = "1";
  };

  # SOPS configuration
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

  # install packages with their default configs
  home.packages = with pkgs; [
    alacritty
    base16-schemes
    btop
    cowsay
    dconf
    ddgr # duckduckgo on the terminal
    delta
    discord
    electron
    eza
    fzf
    git-cliff
    gh
    jq
    just
    keymapp
    libreoffice-qt-fresh # no space left for this app
    nautilus
    newsraft
    nh
    obsidian
    psst
    pwvucontrol
    tabiew
    trashy
    unimatrix
    uv
    virtualenv # need this for python virtual env
    xonsh
    zathura

    # talk to AI
    # aider-chat
    # playwright-driver

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
    # dprint
    # ltex-ls-plus # more strict than typos
    markdown-oxide # https://oxide.md/v0/Articles/Markdown-Oxide+v0
    # marksman # using markdown-oxide currently
    nixd
    nixpkgs-fmt
    nufmt
    shfmt
    taplo
    typos
    typos-lsp
    vscode-langservers-extracted
    yaml-language-server

    # Secrets
    age
    gitleaks
    git-crypt
    sops
  ];

  # ---------------------------------------------
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
