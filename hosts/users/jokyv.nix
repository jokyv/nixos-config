{ pkgs, ... }:

{
  users.users.jokyv = {
    isNormalUser = true;
    description = "jokyv";
    shell = pkgs.bashInteractive;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
}
