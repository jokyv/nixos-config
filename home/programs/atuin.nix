{ pkgs, ... }:

{
  programs.atuin = {
    enable = true;
    settings = {
      # Date format
      dialect = "us";

      # Sync settings
      auto_sync = false;

      # Search configuration
      search_mode = "fuzzy";

      # UI/UX settings
      style = "auto";
      exit_mode = "return-query";
      inline_height = 20;
      enter_accept = true;

    };

    enableBashIntegration = true;
    enableNushellIntegration = true;
    # enableZshIntegration = true;
    # enableFishIntegration = true;
  };
}
