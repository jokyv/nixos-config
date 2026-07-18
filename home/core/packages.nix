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
    pre-commit
    slurp
    swappy
    wl-clipboard
    wtype
    xdg-utils
  ];
}
