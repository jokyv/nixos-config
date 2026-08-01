{
  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642; # Required for some games (Star Citizen, etc.)
    "vm.swappiness" = 10; # Prefer RAM over swap
    "kernel.sched_autogroup_enabled" = 1; # Better interactive task grouping
    "vm.vfs_cache_pressure" = 50; # Controls tendency to reclaim VFS cache
    "vm.dirty_bytes" = 268435456; # Start writeback at 256MB
    "vm.dirty_background_bytes" = 67108864; # Background writeback at 64MB
    "vm.dirty_writeback_centisecs" = 1500; # Writeback interval 15 seconds
    "vm.transhuge" = "madvise"; # Transparent Huge Pages madvise mode
    "net.ipv4.tcp_congestion_control" = "bbr"; # BBR TCP congestion control
    "kernel.nmi_watchdog" = 0; # Disable NMI watchdog (hard lockup detector)
    "kernel.unprivileged_userns_clone" = 1; # Allow unprivileged containers
    "kernel.printk" = "3 3 3 3"; # Kernel printk settings
    "net.core.netdev_max_backlog" = 4096; # Increase network device backlog
    "fs.file-max" = 2097152; # Increase file handles and inode cache
  };

  # Use ZRAM for compressed RAM-based swap. It's much faster than disk-based swap.
  # The system will use this first and only fall back to the disk swap partition if ZRAM fills up.
  zramSwap = {
    enable = true;
    memoryPercent = 50; # Default is 50% already
    algorithm = "zstd"; # Use zstd compression
    priority = 100; # Higher priority than disk swap
  };
}
