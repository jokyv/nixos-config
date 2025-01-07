{ config, pkgs, ... }:

{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        # term = "xterm-256color";
        # font = "FiraCode Nerd Font Mono:size=11";
        # initial-window-size-pixels = "1920x1080";
        # initial-window-size-pixels = "700x500";
        # Set the initial window mode (windowed, maximized, fullscreen)
        # initial-window-mode = "maximized";
        # pad = "10x10";
        resize-by-cells = "no";
        # resize-keep-grid = "yes";
      };
      mouse = {
        hide-when-typing = "yes";
        alternate-scroll-mode = "yes";
      };
      colors = {
        # Set alpha (transparency)
        alpha = 0.9;
      };
      csd = {
        # Configure client-side decorations
        # preferred = "client";
        # preferred = "server";
        # color = "000000"; # Black background
        # button-color = "ffffff"; # White buttons
        # button-minimize-color = "ffffff";
        # button-maximize-color = "ffffff";
        # button-close-color = "ffffff";
      };
      key-bindings = {
        # Custom key bindings
        scrollback-up-page = "Shift+Page_Up";
        scrollback-down-page = "Shift+Page_Down";
        # clipboard-copy = "Control+Shift+c XF86Copy";
        # clipboard-paste = "Control+Shift+v XF86Paste";
      };
      search-bindings = {
        # Search-specific key bindings
        cancel = "Control+g Control+c Escape";
        commit = "Return";
        find-prev = "Control+r";
        find-next = "Control+s";
      };
      url = {
        # URL settings
        launch = "xdg-open \${url}";
        label-letters = "sadfjklewcmpgh";
        osc8-underline = "url-mode";
        protocols = "http, https, ftp, ftps, file, gemini, gopher";
        uri-characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.,~:;/?#@!$&%*+='()[]";
      };
      cursor = {
        # Cursor settings
        style = "block";
        blink = "yes";
        beam-thickness = 1.5;
      };
      tweak = {
        # Various tweaks
        font-monospace-warn = "no";
        overflowing-glyphs = "yes";
      };
      scrollback = {
        # Scrollback settings
        lines = 10000;
        indicator-position = "none";
      };
      text-bindings = {
        # Custom text bindings
        # "\x1b[13;2u" = "\\x1b[13;2~";
      };
      mouse-bindings = {
        # Custom mouse bindings
        selection-override-modifiers = "Shift";
        primary-paste = "BTN_MIDDLE";
      };
      touch = {
        # Touch-related settings
        long-press-delay = 400;
      };
      # environment = {
      #   # Set environment variables
      #   "ENV_VAR" = "value";
      # };
      bell = {
        # Configure the bell
        urgent = "yes";
        notify = "yes";
        command = "notify-send \"Bell in terminal $FOOT_WINDOW_TITLE\"";
      };
      # bold-text-in-bright = {
      #   # Configure how bold text is rendered
      #   palette-based = "yes";
      # };
      # Include additional configuration files
      # include = "/path/to/additional/config.ini";
    };
  };
}
