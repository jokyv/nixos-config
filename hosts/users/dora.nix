{ pkgs, ... }:

{
  users.users.dora = {
    isNormalUser = true;
    description = "dora";
    shell = pkgs.bashInteractive;
    extraGroups = [
      "networkmanager"
      "audio"
      "video"
      "input"
      "bluetooth"
      "plugdev"
    ];
  };
}
