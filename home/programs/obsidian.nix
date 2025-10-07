{ pkgs, ... }:
{

  programs.obsidian = {
    enable = true;
    # Specific configuration for Obsidian to work with Wayland
    # package = pkgs.obsidian.override {
    #   electron = pkgs.electron.override {
    #     commandLineArgs = [
    #       "--ozone-platform=wayland"
    #       "--enable-features=UseOzonePlatform"
    #       "--enable-features=WaylandWindowDecorations"
    #       "--enable-wayland-ime"
    #     ];
    #   };
    # };
  };
}
