# { pkgs, ... }:

# {
#   # Enable DBUS service that allows applications to update firmware
#   services.fwupd.enable = true;

#   # Enable SSD TRIM of mounted partitions in background
#   services.fstrim.enable = true;

#   # Bluetooth
#   services.blueman.enable = true;

#   hardware.enableRedistributableFirmware = true;

#   # PipeWire + WirePlumber
#   services.pipewire = {
#     enable = true;

#     alsa.enable = true;
#     alsa.support32Bit = true;

#     pulse.enable = true;
#     jack.enable = true;

#     wireplumber.enable = true;

#     extraConfig = {
#       pipewire = {
#         "context.properties" = {
#           "default.clock.rate" = 48000;
#           "default.clock.quantum" = 256;
#           "default.clock.min-quantum" = 256;
#           "default.clock.max-quantum" = 512;

#           # Keep these
#           "api.alsa.use-acp" = true;
#           "api.alsa.use-ucm" = true;
#         };

#         "context.modules" = [
#           {
#             name = "libpipewire-module-rtkit";
#             args = ''
#               {
#                 nice.level = -11
#                 rt.prio = 88
#                 rt.prio-override = 88
#               }
#             '';
#           }
#         ];
#       };
#     };
#   };

#   # WirePlumber extra config (FIXED STRUCTURE)
#   services.pipewire.wireplumber.extraConfig."10-bluez-disable-aac" = {
#     "monitor.bluez.properties" = {
#       "bluez5.codecs" = [
#         "sbc_xq"
#         "sbc"
#         "aptx"
#         "aptx_hd"
#         "ldac"
#         "faststream"
#         "g722"
#         "opus"
#         "lc3"
#       ];
#     };
#   };

#   services.pipewire.wireplumber.extraConfig."51-force-analog" = {
#     "monitor.alsa.rules" = [
#       {
#         matches = [
#           { "device.name" = "alsa_card.pci-0000_0a_00.4"; }
#         ];
#         actions = {
#           update-props = {
#             "api.alsa.use-acp" = true;
#             "api.alsa.use-ucm" = false;
#             "device.profile" = "analog-stereo";
#           };
#         };
#       }
#     ];
#   };
#   # Display Management
#   # services.displayManager.ly.enable = true;
#   services.getty.autologinUser = "jokyv";

#   # System Services
#   services.dbus = {
#     enable = true;
#     implementation = "broker";
#   };

#   # Desktop Integration
#   xdg.portal = {
#     enable = true;
#     extraPortals = with pkgs; [
#       xdg-desktop-portal-wlr
#     ];
#     config.common.default = [ "*" ];
#   };
# }
{ pkgs, ... }:

{
  # System services
  services.fwupd.enable = true;
  services.fstrim.enable = true;

  # Bluetooth
  services.blueman.enable = true;

  # Firmware (keep this)
  hardware.enableRedistributableFirmware = true;

  # Audio (clean PipeWire setup)
  services.pipewire = {
    enable = true;

    alsa.enable = true;
    alsa.support32Bit = true;

    pulse.enable = true;
    jack.enable = true;

    wireplumber.enable = true;
  };

  # (Optional) Bluetooth codec tweak — keep only if you actually use BT headphones
  services.pipewire.wireplumber.extraConfig."10-bluez-disable-aac" = {
    "monitor.bluez.properties" = {
      "bluez5.codecs" = [
        "sbc_xq"
        "sbc"
        "aptx"
        "aptx_hd"
        "ldac"
        "faststream"
        "g722"
        "opus"
        "lc3"
      ];
    };
  };

  # Login
  services.getty.autologinUser = "jokyv";

  # DBus
  services.dbus = {
    enable = true;
    implementation = "broker";
  };

  # Portals
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
    ];
    config.common.default = [ "*" ];
  };
}
