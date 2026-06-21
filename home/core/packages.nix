{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bottom
    cliphist
    font-awesome
    grim
    just
    noto-fonts
    noto-fonts-color-emoji
    slurp
    swappy
    wl-clipboard
    wtype
    xdg-utils
  ];
}
