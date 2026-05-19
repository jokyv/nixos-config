{ lib, pkgs, ... }:
{

  programs.fuzzel = {
    enable = true;

    settings = {
      main = {
        # Font and colors are managed by Stylix.
        # Do not set 'font' or any color values here.
        terminal = "${pkgs.foot}/bin/foot";
        layer = "overlay";
        width = 30;
        x-margin = 10;
        y-margin = 10;
        dpi-aware = true;
        tabs = 4;
        match-mode = "fzf";
        list-executables-in-path = true;

        # --- Key Functional Additions ---
        # Enable showing and selecting emojis
        show-actions = true; # Show actions for desktop entries
        lines = 15; # Show more entries
        fields = "filename,name,generic,categories,keywords"; # Richer search fields
      };

      # --- Key Bindings for Enhanced Usability ---
      key-bindings = {
        # Use standard Vim-like navigation
        up = "Up Control+k";
        down = "Down Control+j";
        left = "Left Control+h";
        right = "Right Control+l";
        page-up = "Page_Up";
        page-down = "Page_Down";
        home = "Home";
        end = "End";
        delete = "Delete";
        delete-word = "Control+BackSpace";
        delete-line-prev = "Control+U";
        delete-line-next = "Control+K";
        abort = "Escape Control+g";
        accept = "Return Control+m";
        accept-custom = "Control+Return";
        accept-custom-alt = "Control+Enter";
        # Custom action to launch terminal in current directory
        custom-1 = "Control+Alt+t";
        custom-1-command = "foot";
      };

      # --- Styling (Non-Color) ---
      border = {
        width = 4;
        radius = 16;
      };

      # Dmenu compatibility mode for scripts
      dmenu = {
        mode = "text"; # or "instance" to run as a single instance
        exit-immediately-if-empty = true;
      };
    };
  };
}
