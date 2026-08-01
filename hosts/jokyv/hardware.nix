{ inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
  ];

  hardware = {
    # Update the CPU microcode for AMD processors
    cpu.amd.updateMicrocode = true;

    # Graphics support for Steam/games
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    # Enable Bluetooth hardware support with security settings
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          # Enable profiles
          Enable = "Source,Sink,Media,Socket";
          # Security and privacy
          DiscoverableTimeout = 180; # Stop being discoverable after 3 minutes
          PairableTimeout = 0; # Stay pairable indefinitely
          Privacy = "device"; # Use device mode for better privacy
          ControllerMode = "dual"; # Support both BR/EDR and LE
          # Experimental features
          Experimental = true; # Enable experimental features if needed
        };
        Policy = {
          AutoEnable = true; # Auto-enable when devices are connected
          ReconnectAttempts = 7; # Number of reconnect attempts
          ReconnectIntervals = "1, 2, 3"; # Intervals between attempts in seconds
          # Class = "0x200414"; # Restrict to specific device class if desired
        };
      };
    };
  };
}
