{ pkgs, lib, ... }:

{
  # home.sessionVariables = {
  #   # GTK_THEME = "Catppuccin-Mocha-Compact-Maroon-Dark";
  #   GTK_THEME = "Everforest-Dark";
  # };

  stylix = {
    enable = true;
    autoEnable = true;
    image = ../wallpaper.png;
    polarity = "dark";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest.yaml";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml";

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Amber";
      size = 28;
    };

    fonts =
      {
        monospace = {
          # htts://www.nerdfonts.com/font-downloads
          # package = pkgs.nerd-fonts.override { fonts = [ "martian-mono" "fira-code" "symbols-only" ]; };
          # package = pkgs.nerd-fonts.override [ "martian-mono" "fira-code" "symbols-only" ];
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

    # xdg.configFile."Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini { }).generate "kvantum.kvconfig" {
    #   # ls ~/.nix-profile/share/Kvantum/*/*.kvconfig
    #   General.theme = "Catppuccin-Mocha-Maroon";
    # };
    targets = {

      # Configure the Fnott target
      fnott.enable = false;

      # Configure the Firefox target  
      firefox = {
        enable = true;
        profileNames = [ "default" ];
      };

      # Configure the qt target  
      qt = {
        enable = true;
        platformTheme.name = "qtct";
        style.name = lib.mkForce "kvantum";
      };

      # Configure the gtk target  
      gtk = {
        enable = true;
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
          # name = "Tela";
          # package = pkgs.tela-icon-theme;
          # name = "everforest";
          # package = pkgs.everforest-gtk-theme;
          # name = "candy";
          # package = pkgs.candy-icons;
          # name = "sweet";
          # package = pkgs.sweet-folders;
        };
        # theme = {
        #   name = "Everforest-Dark-B";
        #   package = pkgs.everforest-gtk-theme;
        # };
        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };
        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };
      };

      # dconf.settings = {
      #   "org/gnome/nautilus/icon-view" = {
      #     default-zoom-level = "standard";
      #   };
      #   "org/gnome/desktop/interface" = {
      #     color-scheme = "prefer-dark";
      #   };
      # };
    };

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

