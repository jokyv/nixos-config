{ ... }:

{
  _module.args.primaryUser = "jokyv";

  imports = [
    ./boot.nix
    ./networking.nix
    ./users.nix
    ./hardware.nix
    ./desktop.nix
    ./packages.nix
    ./locale.nix
    ./performance.nix
    ./zsa-udev-rules.nix
    ./security.nix
    ./services.nix
    ./btrfs.nix
    ./maintenance.nix
  ];

  system.stateVersion = "24.05";
}
