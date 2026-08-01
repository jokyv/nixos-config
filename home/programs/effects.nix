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

  # Niri 26.04 supports blur, but current niri-flake settings schema lacks
  # `blur` and `background-effect`. Add Niri blur and layer rules here once
  # the input exposes those settings.
}
