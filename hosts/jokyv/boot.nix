{
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        # Disable boot menu command-line editing for physical-access hardening.
        editor = false;
        # Limit the number of previous generations to keep
        configurationLimit = 10;
      };
      # Allow systemd-boot to manage EFI variables
      efi.canTouchEfiVariables = true;
    };

    kernelParams = [
      "nowatchdog" # Disable watchdog timer - reduces interrupts
      "split_lock_detect=off" # Improve performance on some workloads
      # "mitigations=off" # Disable security mitigations for performance (NOT recommended for production)
      # "preempt=full" # Full preemption for desktop responsiveness
    ];

    extraModprobeConfig = ''
      options snd_had_intel model=generic
    '';
  };
}
