{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bottom
    cliphist
    font-awesome
    gogcli # Google APIs CLI (gmail)
    grim
    herdr-desktop
    just
    noto-fonts
    noto-fonts-color-emoji
    pre-commit
    slurp
    swappy
    wl-clipboard
    wtype
    xdg-utils
  ];
}
