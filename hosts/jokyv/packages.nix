{ pkgs, ... }:

{
  # To search, run: 'nix search wget'
  environment.systemPackages = with pkgs; [
    # System Utilities
    aide
    brightnessctl
    ddcutil
    killall
    lshw
    logrotate
    lynis
    smartmontools
    usbutils
    pciutils
    file
    which
    rng-tools
    clamav
    sniffnet

    # Development Tools
    clang
    cmake
    gcc
    gdb
    git

    # Network Utilities
    curl
    wget
    openssh

    # Multimedia
    ffmpeg
    mesa

    # Wayland
    xwayland
    xwayland-satellite
    wayland

    # Graphics and Vulkan
    vulkan-tools
    mesa-demos

    # Archive Tools
    unzip
    p7zip

    # Other
    libnotify
    libglibutil
  ];
}
