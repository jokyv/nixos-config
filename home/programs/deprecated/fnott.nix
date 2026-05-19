{
  config,
  pkgs,
  lib,
  ...
}:

{
  services.fnott = {
    enable = true;

    settings = lib.mkDefault {
      main = {
        # Position and layout
        anchor = "top-right";
        # spacing = 10;

        # Monitor output (uncomment and change as needed)
        # Available outputs can be listed with: swaymsg -t get_outputs
        # output = "DP-1";  # Example: force notifications to appear on DP-1

        # Display settings
        # title = true;
        min-width = 300;
        max-width = 500;

        # Icon settings
        max-icon-size = 32;

        # Action selection helper
        selection-helper = "fuzzel --dmenu";
        selection-helper-uses-null-separator = false;

        # Font settings
        title-font = "monospace:size=12";
        summary-font = "monospace:size=12";
        body-font = "monospace:size=10";
      };

      # Styling for different urgency levels
      low = {
        background = "2e3440cc";
        title-color = "eceff4ff";
        body-color = "d8dee9ff";
        border-color = "81a1c1ff";
        border-size = 5;
        default-timeout = 5; # 5 seconds for low urgency
      };

      normal = {
        background = "2e3440cc";
        title-color = "eceff4ff";
        body-color = "d8dee9ff";
        border-color = "88c0d0ff";
        border-size = 5;
        default-timeout = 10; # 10 seconds for normal urgency
      };

      critical = {
        background = "2e3440cc";
        title-color = "eceff4ff";
        body-color = "d8dee9ff";
        border-color = "bf616aff";
        border-size = 8;
        default-timeout = 30; # 30 seconds for critical urgency
      };

      # Application-specific configurations
      # Example: Never timeout song change notifications
      # [app-name="spotify"]
      # default-timeout = 0

      # Click behavior:
      # - Left click: dismiss single notification (built-in)
      # - Right click: dismiss all notifications (fnottctl dismiss-all)
      #   Bind right-click to your script in scripts/bin/fnott-dismiss-all.sh
      #   Note: This may require compositor-specific configuration
      # - URLs: Handled by xdg-open when applications include URL metadata
    };
  };
}
