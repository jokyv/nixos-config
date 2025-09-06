{ pkgs, ... }:

{
  # ---------------------------------------------
  # Kernel security settings
  # ---------------------------------------------
  boot.kernel.sysctl = {
    "fs.protected_fifos" = 2;
    "fs.protected_regular" = 2;
    "fs.suid_dumpable" = false;
    "kernel.kptr_restrict" = 2;
    "kernel.sysrq" = false;
    "kernel.unprivileged_bpf_disabled" = true;

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

  # Enable firewall
  networking.firewall.enable = true;

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
  };

  # ---------------------------------------------
  # Systemd service security hardening
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

  # Nix security settings
  nix.settings = {
    trusted-users = [ "root" "jokyv" ];
  };
}
