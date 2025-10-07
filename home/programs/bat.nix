{ ... }:

{
  # Set MANPAGER to use bat for viewing man pages with color.
  home.sessionVariables = {
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
  };

  programs.bat = {
    enable = true;

    # For a full list of options, see 'bat --help' or the bat documentation.
    # The theme is managed by stylix.
    config = {
      # When to use the pager. "auto" is the default.
      # "never": never use the pager.
      # "always": always use the pager.
      paging = "auto";

      # Set the width of tab stops.
      tabs = "4";

      # Map specific file extensions or names to a syntax.
      # Example:
      # "map-syntax" = [ "*.conf:INI" ];
    };
  };
}
