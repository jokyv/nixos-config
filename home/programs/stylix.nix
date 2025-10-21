{ pkgs, ... }:

let
  base16SchemesPath = "${pkgs.base16-schemes}/share/themes/";
in
{
  stylix = {
    enable = true;
    autoEnable = true;
    image = ../wallpaper.png;
    polarity = "dark";

    # https://tinted-theming.github.io/tinted-gallery/
    # base16Scheme = "${base16SchemesPath}/rose-pine.yaml";
    # base16Scheme = "${base16SchemesPath}/everforest.yaml";
    # base16Scheme = "${base16SchemesPath}/everforest-dark-hard.yaml";
    # base16Scheme = "${base16SchemesPath}/gruvbox-dark-hard.yaml";
    # base16Scheme = "${base16SchemesPath}/catppuccin-mocha.yaml";
    # base16Scheme = "${base16SchemesPath}/catppuccin-macchiato.yaml";

    # Black metal themes
    # base16Scheme = "${base16SchemesPath}/black-metal.yaml";
    # base16Scheme = "${base16SchemesPath}/black-metal-gorgoroth.yaml";
    base16Scheme = "${base16SchemesPath}/black-metal-bathory.yaml";

    override = {
      base0A = "#854a55"; # a bit of dark rose-pine
      base03 = "#2e3a47"; # usual color comments
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Amber";
      size = 28;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.martian-mono;
        name = "Martian Mono Nerd Font Mono";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      emoji = {
        package = pkgs.noto-fonts-monochrome-emoji;
        name = "Noto Emoji";
      };
      sizes = {
        terminal = 15;
        applications = 12;
        popups = 15;
        desktop = 12;
      };
    };

    opacity = {
      terminal = 0.9;
      applications = 0.9;
      popups = 0.9;
      desktop = 0.9;
    };

    # image = nix-colors-lib.nixWallpaperFromScheme {
    #   scheme = config.colorscheme;
    #   width = 1366;
    #   height = 768;
    #   logoScale = 3.0;
    # };

    targets = {

      # Configure the Fnott target
      fnott.enable = false;

      # Configure the Firefox target
      firefox = {
        enable = true;
        profileNames = [ "default" ];
      };

      # apply specific theme to GTK based apps
      # gtk = {
      #   enable = true;
      #   iconTheme = {
      #     # name = "Papirus-Dark";
      #     # package = pkgs.papirus-icon-theme;
      #     # name = "Tela";
      #     # package = pkgs.tela-icon-theme;
      #     # name = "everforest";
      #     # package = pkgs.everforest-gtk-theme;
      #     # name = "candy";
      #     # package = pkgs.candy-icons;
      #     name = "sweet";
      #     package = pkgs.sweet-folders;
      #   };
      # };

    };

    # apply specific theme to Qt based apps
    # home.packages = [
    #   pkgs.libsForQt5.qtstyleplugin-kvantum
    #   pkgs.catppuccin-qt5ct
    #   (pkgs.catppuccin-kvantum.override {
    #     variant = "mocha";
    #     accent = "maroon";
    #   })
    # ];
  };
}
