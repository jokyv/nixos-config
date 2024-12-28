{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    # Theme configuration
    # theme = "Everforest Dark Hard";

    # Font configuration
    # font = {
    #   name = "FiraCode Nerd Font Mono";
    #   size = 15.0;
    # };

    # Advanced settings
    settings = {
      # Scrollback and display
      scrollback_lines = 10000;
      # dim_opacity = "0.75";
      # background_opacity = "0.95";

      # Word selection
      select_by_word_characters = ":@-./_~?&=%+#";

      # URL handling
      open_url_with = "default";

      # Terminal type
      term = "xterm-kitty";

      # Window appearance and behavior
      hide_window_decorations = "titlebar-only";
      window_margin_width = 10;

      # Window size
      remember_window_size = true;
      initial_window_width = 640;
      initial_window_height = 400;

      # Layouts
      enabled_layouts = "horizontal";
    };

    # Additional font settings
    extraConfig = ''
      bold_font auto
      italic_font auto
      bold_italic_font auto
    '';
  };
}
