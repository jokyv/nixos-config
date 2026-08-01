{ lib, pkgs, ... }:

{

  # ---------------------------------------------
  # General security settings
  # ---------------------------------------------
  security = {
    rtkit.enable = true;

    # Protect against kernel exploits
    protectKernelImage = true;
    # Enable lockdown for VMs/containers
    virtualisation.flushL1DataCache = "always";
    # Enable AppArmor for application confinement
    apparmor.enable = true;

    # Audit events relevant to local privilege escalation and system changes.
    audit = {
      enable = true;
      failureMode = "printk";
      backlogLimit = 8192;
      rules = [
        "-w /etc/passwd -p wa -k identity"
        "-w /etc/shadow -p wa -k identity"
        "-w /etc/group -p wa -k identity"
        "-w /etc/sudoers -p wa -k sudoers"
        "-w /etc/pam.d -p wa -k authentication"
        "-a always,exit -F arch=b64 -S mount,umount2 -F auid>=1000 -F auid!=unset -k mounts"
        "-a always,exit -F arch=b64 -S init_module,finit_module,delete_module -F auid>=1000 -F auid!=unset -k kernel-modules"
      ];
    };

    auditd = {
      enable = true;
      settings = {
        log_format = "ENRICHED";
        max_log_file = 50;
        num_logs = 10;
        max_log_file_action = "rotate";
        space_left = 1024;
        space_left_action = "syslog";
        admin_space_left = 512;
        admin_space_left_action = "suspend";
        disk_full_action = "suspend";
        disk_error_action = "syslog";
      };
    };
  };

  # ---------------------------------------------
  # Kernel security hardening (sysctl)
  # ---------------------------------------------
  boot.kernel.sysctl = {
    "kernel.kptr_restrict" = 2; # Hide kernel pointers from /proc
    "dev.tty.ldisc_autoload" = 0; # Prevent loading TTY line disciplines (security hardening)
    "fs.suid_dumpable" = 0; # Restrict core dumps (0 = false)
    "fs.protected_fifos" = 2; # Protect FIFOs
    "fs.protected_regular" = 2; # Protect regular files
    "fs.protected_hardlinks" = 1; # Disallow following hardlinks outside current filesystem
    "fs.protected_symlinks" = 1; # Disallow following symlinks outside current filesystem
    "kernel.sysrq" = false; # Disable Magic SysRq key (security precaution)
    "kernel.unprivileged_bpf_disabled" = true; # Disallow unprivileged BPF (prevents BPF-based attacks)
    "kernel.dmesg_restrict" = 1; # Restrict dmesg to privileged users (prevents information leakage)
    "kernel.core_uses_pid" = 1; # Include PID in core dump filename for better tracking
    "kernel.ctrl-alt-del" = 0; # Disable Ctrl+Alt+Del reboot (prevent accidental reboots)
    "net.core.bpf_jit_harden" = 2; # Enable BPF JIT hardening (anti-ROP/JIT spraying)
    "net.ipv4.conf.all.accept_redirects" = false; # Disable ICMP redirects (prevent MITM)
    "net.ipv6.conf.all.accept_redirects" = false; # Disable IPv6 ICMP redirects
    "net.ipv4.conf.default.accept_redirects" = false; # Disable default ICMP redirects
    "net.ipv6.conf.default.accept_redirects" = false; # Disable default IPv6 ICMP redirects
    "net.ipv4.conf.all.log_martians" = true; # Log suspicious packets (martians) for detection
    "net.ipv6.conf.all.log_martians" = true; # Log IPv6 suspicious packets
    "net.ipv4.conf.default.log_martians" = true; # Log martians by default
    "net.ipv6.conf.default.log_martians" = true; # Log IPv6 martians by default
    "net.ipv4.conf.all.rp_filter" = true; # Enable source path validation (anti-spoofing)
    "net.ipv6.conf.all.rp_filter" = true; # Enable IPv6 source path validation
    "net.ipv4.conf.all.send_redirects" = false; # Prevent sending ICMP redirects (avoid network attacks)
    "net.ipv6.conf.all.send_redirects" = false; # Prevent sending IPv6 ICMP redirects
  };

  # ---------------------------------------------
  # Network security settings
  # ---------------------------------------------
  networking.firewall = {
    enable = true;

    # Basic settings
    allowPing = false; # Block ping requests (stealth mode)
    rejectPackets = false; # false = DROP (silent), true = REJECT (respond)

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

  services = {
    logrotate.settings."/var/log/sudo.log" = {
      frequency = "daily";
      maxsize = "10M";
      rotate = 14;
      compress = true;
      missingok = true;
      create = "0600 root root";
    };

    # SSH server (disabled until inbound SSH is needed).
    # Git push/pull only needs the openssh client package.
    openssh = {
      enable = false;
      settings = {
        PasswordAuthentication = false; # Disable password auth (use keys only)
        PermitRootLogin = "no"; # Disable root login over SSH
      };
      openFirewall = false; # Don't open SSH server port.
    };

    # Antivirus engine
    clamav = {
      daemon.enable = true;
      updater.enable = true;
    };
  };

  # Weekly vulnerability audit for the current system closure.
  # Reports are stored in /var/log/audit-reports; inspect with `just vulnix-report`.
  # ---------------------------------------------
  # Kernel security settings
  # ---------------------------------------------

  # Blacklist unnecessary kernel modules
  boot.blacklistedKernelModules = [
    "dccp"
    "sctp"
    "rds"
    "tipc"
  ];

  systemd = {
    tmpfiles.rules = [
      "d /var/log/audit-reports 0750 root root - -"
    ];

    services = {
      vulnix-audit = {
        description = "Run Vulnix system vulnerability audit";
        serviceConfig.Type = "oneshot";
        environment.LANG = "C.UTF-8";
        script = ''
          report="/var/log/audit-reports/vulnix-$(date +%s).json"
          ${pkgs.vulnix}/bin/vulnix --system --json > "$report" || true
          ln -sfn "$report" /var/log/audit-reports/vulnix-latest.json
        '';
      };

      systemd-rfkill = {
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

      systemd-journald = {
        serviceConfig = {
          UMask = "0077";
          PrivateNetwork = true;
          ProtectHostname = true;
          ProtectKernelModules = true;
        };
      };
    };

    timers = {
      vulnix-audit = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "weekly";
          Persistent = true;
          RandomizedDelaySec = "1h";
        };
      };

      clamav-freshclam = {
        timerConfig = {
          OnCalendar = lib.mkForce "daily";
          Persistent = lib.mkForce true;
          RandomizedDelaySec = "1h";
        };
      };
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
