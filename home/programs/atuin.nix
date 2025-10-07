{ ... }:

{
  programs.atuin = {
    enable = true;
    settings = {
      # Use American date formats (MM/DD/YYYY).
      dialect = "us";

      # Do not automatically sync shell history with a server.
      auto_sync = false;

      # Use "fuzzy" matching for searches, allowing for approximate queries.
      search_mode = "fuzzy";

      # Automatically detect the best color scheme (light/dark).
      style = "auto";

      # When exiting Atuin, return the selected command to the prompt instead of executing it.
      exit_mode = "return-query";

      # Set the maximum height of the inline history view to 20 lines.
      inline_height = 20;

      # Pressing 'Enter' will accept the selection and return it to the prompt.
      enter_accept = true;

      # Example of how to customize key bindings.
      # key_bindings = {
      #   "ctrl-r" = "search";
      # };

    };

    # Enable shell history integration for the shells you use.
    enableBashIntegration = true;
    # enableNushellIntegration = true;
    # enableZshIntegration = true;
    # enableFishIntegration = true;
  };
}
