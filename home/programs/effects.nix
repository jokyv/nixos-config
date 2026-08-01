{
  stylix.opacity = {
    terminal = 0.96;
    applications = 0.9;
    popups = 0.9;
    desktop = 0.9;
  };

  programs.noctalia.settings = {
    backdrop = {
      enabled = false;
      blur_intensity = 0.5;
      tint_intensity = 0.3;
    };

    lockscreen = {
      enabled = true;
      blurred_desktop = false;
      blur_intensity = 0.5;
      tint_intensity = 0.3;
      wallpaper = "";
      monitors = [ ];
    };
  };

  # Add Niri blur and layer rules in home/programs/niri.nix.
}
