{
  programs.zoxide = {
    enable = true;
    # enableNushellIntegration = true;  # Disabled: no longer using Nushell
    enableBashIntegration = true;        # Enabled: using bash shell
    options = [
      "--cmd z"
      # "--cmd j"  # Alternative: use 'j' instead of 'z' (uncomment if preferred)
    ];
  };
}
