{ ... }:

{
  imports = [
    ./packages/dev.nix
    ./packages/apps.nix
    ./packages/system.nix
    ./packages/languages.nix
    ./packages/security.nix
  ];
}
