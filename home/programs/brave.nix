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
      "--ozone-platform-hint=auto"
      "--enable-features=WaylandWindowDecorations"
      "--enable-wayland-ime"
    ];
  };
}
