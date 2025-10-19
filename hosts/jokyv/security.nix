{ lib, ... }:

{

  # ---------------------------------------------
  # General security settings
  # ---------------------------------------------
  security = {
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

  # ---------------------------------------------
  # Network security settings
  # ---------------------------------------------
  networking.firewall = {
    enable = true;

    # Basic settings
    allowPing = false; # Block ping requests (stealth mode)
    rejectPackets = false; # false = DROP (silent), true = REJECT (respond)

    # Essential desktop ports
    allowedTCPPorts = [
      5353 # mDNS/Bonjour - for network discovery (printers, file sharing)
    ];

    allowedUDPPorts = [
      5353 # mDNS/Bonjour
    ];

    # Important for desktop functionality
    checkReversePath = false; # Better compatibility with VPNs and complex networks
  };

  # sudo configuration
  security.sudo = {
    enable = true;
    execWheelOnly = true; # Only wheel group can use sudo
    extraConfig = ''
      # Security settings
      Defaults        timestamp_timeout=15      # Sudo timeout after 15 minutes
      Defaults        passwd_timeout=1          # Password prompt timeout
      Defaults        lecture=once              # Show security warning one time
      Defaults        logfile=/var/log/sudo.log # Log all sudo commands
      Defaults        log_input,log_output      # Log input/output of commands
      Defaults        requiretty                # Require TTY for sudo
      Defaults        use_pty                   # Always use pseudo-terminal

      # Security restrictions
      Defaults        secure_path="/run/wrappers/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
      Defaults        env_reset
      Defaults        mail_badpass
      Defaults        always_set_home

      # User specifications
      %wheel ALL=(ALL:ALL) ALL
    '';
  };

  # Session management
  security.pam.loginLimits = [
    # Limit user resources
    {
      domain = "*";
      type = "hard";
      item = "nofile";
      # value = "4096";
      value = "2048";
    }
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "512";
    }
  ];

  # SSH configuration (for GitHub)
  services.openssh = {
    enable = true; # Enable SSH client (for git push/pull)
    settings = {
      PasswordAuthentication = false; # Disable password auth (use keys only)
      PermitRootLogin = "no"; # Disable root login over SSH
    };
    openFirewall = false; # Important: Don't open SSH server port!
  };

  # Antivirus engine
  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
  };

  # ---------------------------------------------
  # Kernel security settings
  # ---------------------------------------------
  boot.kernel.sysctl = {
    "dev.tty.ldisc_autoload" = 0;
    "fs.suid_dumpable" = 0; # Restrict core dumps (0 = false)
    "fs.protected_fifos" = 2; # Protect FIFOs
    "fs.protected_regular" = 2; # Protect regular files
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
    "net.ipv6.conf.all.accept_redirects" = false;
    "net.ipv4.conf.default.accept_redirects" = false;
    "net.ipv6.conf.default.accept_redirects" = false;
    "net.ipv4.conf.all.log_martians" = true;
    "net.ipv6.conf.all.log_martians" = true;
    "net.ipv4.conf.default.log_martians" = true;
    "net.ipv6.conf.default.log_martians" = true;
    "net.ipv4.conf.all.rp_filter" = true;
    "net.ipv6.conf.all.rp_filter" = true;
    "net.ipv4.conf.all.send_redirects" = false;
    "net.ipv6.conf.all.send_redirects" = false;
    # "vm.swappiness" = 10; # Prefer RAM memory over swap memory (defined in hardware-configuration.nix)
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
