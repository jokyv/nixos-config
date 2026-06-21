{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Security Tools
    age
    gitleaks
    git-crypt
    sops
  ];
}
