{ lib, pkgs, ... }:
{

  programs.fuzzel = {
    enable = true;

    settings = {
      main = {
        line-height = 20;
        # terminal = "foot"; # Specify your preferred terminal
        terminal = "${pkgs.foot}/bin/foot";
        layer = "overlay"; # Wayland layer
        # Interface behavior
        width = 30; # Width in percentage or characters
        x-margin = 10;
        y-margin = 10;

        # Performance and display
        dpi-aware = true;
        tabs = 4; # Tab width

        # Sorting and matching
        match-mode = "fzf"; # exact, fzf, fuzzy
        # case-sensitive = false;
        list-executables-in-path = true;
      };

      border = {
        width = 4;
        radius = 16;
      };
    };
  };
}
