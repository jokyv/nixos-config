{ config, pkgs, ... }:

{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        # Font and colors are managed by Stylix.
        # Do not set 'font' or any color values here.
        term = "xterm-256color";
        initial-window-size-pixels = "800x600";
        pad = "5x5 center";
        resize-by-cells = "no";
        login-shell = "no";
        dpi-aware = "yes";
      };
      mouse = {
        hide-when-typing = "yes";
        alternate-scroll-mode = "yes";
      };
      # The 'colors' section is completely managed by Stylix.
      # Stylix will also set the 'alpha' value based on 'stylix.opacity.terminal'.
      key-bindings = {
        scrollback-up-page = "Shift+Page_Up";
        scrollback-down-page = "Shift+Page_Down";
        clipboard-copy = "Control+Shift+c XF86Copy";
        clipboard-paste = "Control+Shift+v XF86Paste";
      };
      search-bindings = {
        cancel = "Control+g Control+c Escape";
        commit = "Return";
        find-prev = "Control+r";
        find-next = "Control+s";
      };
      url = {
        launch = "xdg-open \${url}";
        label-letters = "sadfjklewcmpgh";
        osc8-underline = "url-mode";
      };
      cursor = {
        # Cursor style is a functional preference, not a theme color.
        style = "block";
        blink = "yes";
        beam-thickness = 1.5;
      };
      tweak = {
        font-monospace-warn = "no";
        overflowing-glyphs = "yes";
      };
      scrollback = {
        lines = 10000;
        indicator-position = "none";
      };
      mouse-bindings = {
        selection-override-modifiers = "Shift";
        primary-paste = "BTN_MIDDLE";
      };
      touch = {
        long-press-delay = 400;
      };
      bell = {
        urgent = "yes";
        notify = "yes";
        command = "notify-send \"Bell in terminal $FOOT_WINDOW_TITLE\"";
      };
    };
  };
}
