{
  inputs,
  hostModule,
  installerHardwareModule,
  ...
}:

{
  imports = [
    inputs.disko.nixosModules.disko
    ../disks/universal-config.nix
    hostModule
    installerHardwareModule
  ];
}
