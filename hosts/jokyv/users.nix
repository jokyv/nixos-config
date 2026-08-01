{ pkgs, ... }:

{
  # Don't forget to set a password with 'passwd'.
  users.users.jokyv = {
    isNormalUser = true;
    description = "jokyv";
    # initialPassword = "";
    shell = pkgs.bashInteractive;
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "input"
      "bluetooth"
      "plugdev"
    ];
  };

  # Disable root account entirely for security
  users.users.root = {
    hashedPassword = "!"; # Lock root account (exclamation mark prevents login)
    shell = "${pkgs.shadow}/bin/nologin"; # Disable root shell access
  };
}
