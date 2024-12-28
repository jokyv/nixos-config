{ config, stylix, ... }:

{
  programs.zathura = {
    enable = true;
    options = {
      # Use Stylix colors
      # default-bg = "${config.stylix.colors.base00}";
      # default-fg = "${config.stylix.colors.base05}";
      # statusbar-bg = "${config.stylix.colors.base01}";
      # statusbar-fg = "${config.stylix.colors.base04}";
      # inputbar-bg = "${config.stylix.colors.base00}";
      # inputbar-fg = "${config.stylix.colors.base07}";
      # notification-error-bg = "${config.stylix.colors.base08}";
      # notification-error-fg = "${config.stylix.colors.base00}";
      # notification-warning-bg = "${config.stylix.colors.base0A}";
      # notification-warning-fg = "${config.stylix.colors.base00}";
      # highlight-color = "${config.stylix.colors.base0A}";
      # highlight-active-color = "${config.stylix.colors.base0D}";
      # completion-highlight-bg = "${config.stylix.colors.base0D}";
      # completion-highlight-fg = "${config.stylix.colors.base07}";
      # completion-bg = "${config.stylix.colors.base02}";
      # completion-fg = "${config.stylix.colors.base05}";
      # notification-bg = "${config.stylix.colors.base0B}";
      # notification-fg = "${config.stylix.colors.base00}";

      # # Recolor settings
      # recolor = true;
      # recolor-lightcolor = "${config.stylix.colors.base00}";
      # recolor-darkcolor = "${config.stylix.colors.base05}";
      # recolor-reverse-video = true;
      # recolor-keephue = true;

      # Font settings
      font = "${config.stylix.fonts.sansSerif.name} 11";

      # UI settings
      statusbar-home-tilde = true;
      statusbar-h-padding = 0;
      statusbar-v-padding = 0;
      page-padding = 1;

      # Behavior settings
      adjust-open = "best-fit";
      pages-per-row = 1;
      scroll-page-aware = true;
      # scroll-full-overlap = 0.01;
      scroll-step = 100;
      zoom-min = 10;
      guioptions = "";
    };

    # Mappings
    mappings = {
      u = "scroll half-up";
      d = "scroll half-down";
      D = "toggle_page_mode";
      r = "reload";
      R = "rotate";
      K = "zoom in";
      J = "zoom out";
      i = "recolor";
      p = "print";
    };
  };
}
