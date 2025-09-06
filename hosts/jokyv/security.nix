{ pkgs, lib, ... }:

{

  # ---------------------------------------------
  # Security settings
  # ---------------------------------------------

  security = {
    # sudo hardening: require authentication even if same user
    sudo.execWheelOnly = true;
    # Protect against kernel exploits
    protectKernelImage = true;
    # Enable lockdown for VMs/containers
    virtualisation.flushL1DataCache = "always";
    # Enable AppArmor for application confinement
    apparmor.enable = true;
    audit = {
      enable = true;
      rules = [
        # Rule 1: Monitor all execve system calls (64-bit)
        "-a always,exit -F arch=b64 -S execve"
        # Rule 2: Watch /etc/passwd for write changes and attribute changes
        "-w /etc/passwd -p wa"
        # Rule 3: Watch /etc/shadow for write changes and attribute changes  
        "-w /etc/shadow -p wa"
      ];
    };
  };

  # Enable firewall
  networking.firewall.enable = true;

  # ---------------------------------------------
  # Kernel security settings
  # ---------------------------------------------

  boot.kernel.sysctl = {
    "dev.tty.ldisc_autoload" = 0;
    "fs.protected_fifos" = 2;
    "fs.protected_regular" = 2;
    "fs.suid_dumpable" = false;
    "fs.protected_hardlinks" = 1;
    "fs.protected_symlinks" = 1;
    "kernel.kptr_restrict" = 2;
    "kernel.sysrq" = false;
    "kernel.unprivileged_bpf_disabled" = true;
    "kernel.dmesg_restrict" = 1;
    "kernel.core_uses_pid" = 1;
    "kernel.ctrl-alt-del" = 0;
    "net.core.bpf_jit_harden" = 2;
    "net.ipv4.conf.all.accept_redirects" = false;
    "net.ipv4.conf.default.accept_redirects" = false;
    "net.ipv6.conf.all.accept_redirects" = false;
    "net.ipv6.conf.default.accept_redirects" = false;
    "net.ipv4.conf.all.log_martians" = true;
    "net.ipv4.conf.default.log_martians" = true;
    "net.ipv4.conf.all.rp_filter" = true;
    "net.ipv4.conf.all.send_redirects" = false;
  };

  # Blacklist unnecessary kernel modules
  boot.blacklistedKernelModules = [
    "dccp"
    "sctp"
    "rds"
    "tipc"
  ];

  # ---------------------------------------------
  # Systemd security settings
  # ---------------------------------------------

  systemd.services.systemd-rfkill = {
    serviceConfig = {
      ProtectSystem = "strict";
      ProtectHome = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      ProtectClock = true;
      ProtectProc = "invisible";
      ProcSubset = "pid";
      PrivateTmp = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      LockPersonality = true;
      RestrictRealtime = true;
      SystemCallArchitectures = "native";
      UMask = "0077";
      IPAddressDeny = "any";
    };
  };

  systemd.services.systemd-journald = {
    serviceConfig = {
      UMask = "0077";
      PrivateNetwork = true;
      ProtectHostname = true;
      ProtectKernelModules = true;
    };
  };

  systemd.timers.clamav-freshclam = {
    timerConfig = {
      OnCalendar = lib.mkForce "daily";
      Persistent = lib.mkForce true;
      RandomizedDelaySec = lib.mkForce "1h";
    };
  };

  # systemd.services.aide = {
  #   description = "AIDE file integrity check";
  #   serviceConfig = {
  #     Type = "oneshot";
  #     ExecStart = "${pkgs.aide}/bin/aide --check";
  #   };
  #   wantedBy = [ "multi-user.target" ];
  #   startAt = "daily";
  # };

  # Additional security for other systemd services
  # systemd.services.NetworkManager = {
  #   serviceConfig = {
  #     ProtectSystem = "strict";
  #     ProtectHome = true;
  #     PrivateTmp = true;
  #   };
  # };
}
