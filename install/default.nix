{ inputs, hostModule, installConfigFile, ... }:

{
  imports = [
    inputs.disko.nixosModules.disko
    ../disks/universal-config.nix
    hostModule
  ];
}
