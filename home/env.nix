{ config, pkgs, ... }:

{
  home.sessionVariables = {
    # Defaults
    EDITOR = "hx";
    VISUAL = "hx";
    BROWSER = "firefox";
    TERMINAL = "kitty";
    WM = "niri";
    TERM = "xterm-256color";
    COLORTERM = "truecolor";

    # XDG Paths
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";

    # LESS history
    LESSHISTFILE = "-";

    # Program paths
    CARGO_HOME = "${config.home.sessionVariables.XDG_DATA_HOME}/cargo";
    RUSTUP_HOME = "${config.home.sessionVariables.XDG_DATA_HOME}/rustup";
    HISTFILE = "${config.home.sessionVariables.XDG_DATA_HOME}/bash/history";
    GNUPGHOME = "${config.home.sessionVariables.XDG_DATA_HOME}/gnupg";
    # RIPGREP_CONFIG_PATH = "${config.home.sessionVariables.XDG_CONFIG_HOME}/ripgrep/.ripgreprc";

    # Man pages
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";

    # Python settings
    PYTHONIOENCODING = "UTF-8";
    # PYTHONPATH = "$PYTHONPATH:$HOME/projects/python_path";

    # Locale settings
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };
}
