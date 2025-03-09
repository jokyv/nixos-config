{ config, pkgs, lib, ... }:

{
  services.fnott = {
    enable = true;

    settings = lib.mkDefault {
      main = {
        # Position and layout
        anchor = "top-right";
        # spacing = 10;
        # max-visible = 5;

        # Timing
        default-timeout = 20;
        max-timeout = 30;

        # Display settings
        # title = true;
        # body = true;
        min-width = 300;
        max-width = 500;

        # Icon settings
        # icon = true;

        # Font settings
        title-font = "monospace:size=12";
        summary-font = "monospace:size=12";
        body-font = "monospace:size=10";
      };

      # Styling for different urgency levels
      low = {
        background = "2e3440ff";
        title-color = "eceff4ff";
        body-color = "d8dee9ff";
        border-color = "81a1c1ff";
        border-size = 5;
      };

      normal = {
        background = "2e3440ff";
        title-color = "eceff4ff";
        body-color = "d8dee9ff";
        border-color = "88c0d0ff";
        border-size = 5;
      };

      critical = {
        background = "2e3440ff";
        title-color = "eceff4ff";
        body-color = "d8dee9ff";
        border-color = "bf616aff";
        border-size = 8;
      };
    };
  };
}
