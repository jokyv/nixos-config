{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # System Utilities
    base16-schemes
    cowsay
    dconf
    delta
    dysk
    eza
    newsraft
    pwvucontrol
    tabiew
    trashy
    unimatrix
  ];
}
