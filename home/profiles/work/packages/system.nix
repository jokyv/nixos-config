{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # System Utilities
    base16-schemes
    cowsay
    dconf
    ddgr # duckduckgo on the terminal
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
