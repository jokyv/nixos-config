{ pkgs, pkgs-stable, ... }:

{
  home.packages = with pkgs;
    [
      # GUI Applications
      discord
      keymapp
      nautilus
      psst # A spotify client

      # GNOME Apps
      gnome-calendar
      evince
      gnome-maps
      gnome-clocks
      gnome-contacts
      gnome-calculator
    ]
    ++ (with pkgs-stable; [
      libreoffice-qt-fresh
    ]);
}
