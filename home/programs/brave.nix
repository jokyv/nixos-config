{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.brave = {
    enable = true;
    commandLineArgs = [
      # --- Wayland & Display ---
      "--ozone-platform-hint=auto"
      "--enable-features=WaylandWindowDecorations"
      "--enable-wayland-ime"

      # --- Performance & Hardware Acceleration ---
      "--enable-gpu-rasterization"
      "--disable-gpu-driver-bug-workarounds"

      # --- Privacy & Security ---
      "--disable-background-networking"
      "--disable-default-apps"
      "--disable-features=TranslateUI"
      "--no-report-upload"
      "--disable-logging"

      # --- UI/UX & Features ---
      "--force-dark-mode"
      "--enable-features=TabScrolling"
    ];
  };
}
