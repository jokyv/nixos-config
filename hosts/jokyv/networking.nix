{
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ]; # Reliable DNS
    enableIPv6 = true; # Keep IPv6 enabled
  };

  # Do not block boot waiting for network; desktop can connect after login.
  # Services that need network should depend on network-online.target explicitly.
  systemd.services.NetworkManager-wait-online.enable = false;
}
