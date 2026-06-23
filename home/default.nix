{ ... }:

{
  imports = [
    ./core/defaults.nix
    ./core/env.nix
    ./core/sops.nix
    ./core/desktop.nix
    ./core/prefetch.nix
    ./core/packages.nix
    ./core/programs.nix
    ./profiles/work
  ];
}
