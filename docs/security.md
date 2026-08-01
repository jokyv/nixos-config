# Security Baseline

## Scope

This is a security baseline for current `nixos` host. It records current capabilities and rollout constraints for #35. It is not a compliance claim.

## Threat model

| Threat                   | Current protection                                                                                         | Gap or recovery requirement                                                                                                                                        |
| ------------------------ | ---------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Stolen disk              | EFI partition and root Btrfs filesystem are unencrypted.                                                   | Full-disk encryption is required before stolen-disk protection can be claimed. Keep backups and recovery material outside target disk.                             |
| Physical access          | UEFI boot with systemd-boot; Secure Boot disabled.                                                         | An attacker with physical access can boot alternate media or alter unsigned boot artifacts. Secure Boot requires tested recovery media and backed-up signing keys. |
| Malicious update         | Flake lock pins inputs; Nix builds are declarative.                                                        | Pinning does not establish source trust or prevent compromised inputs. Review updates before applying them and retain known-good boot generations.                 |
| Local unprivileged user  | Kernel hardening sysctls, firewall, AppArmor kernel support, and bounded auditd configuration are present. | AppArmor has no loaded policies yet, so it confines no applications. Auditd activation and rule output need reboot-time validation.                                |
| Lost security credential | Password-based boot and login remain available.                                                            | Future FIDO2, TPM, and Secure Boot credentials need independent backup and tested recovery paths.                                                                  |

## Hardware and boot compatibility

| Capability      | Current state                       | Consequence                                                                             |
| --------------- | ----------------------------------- | --------------------------------------------------------------------------------------- |
| Architecture    | x86_64                              | Supported by current flake outputs.                                                     |
| Firmware        | UEFI 2.70                           | Secure Boot can be evaluated.                                                           |
| Secure Boot     | Disabled; firmware in setup mode    | Do not enroll keys before recovery USB test.                                            |
| Bootloader      | systemd-boot                        | Current boot path is unsigned.                                                          |
| TPM 2.0         | Not detected                        | TPM-backed SSH and TPM-bound disk unlock cannot be configured on this hardware.         |
| Root encryption | Not configured                      | FIDO2 LUKS requires an encryption migration or future encrypted installation.           |
| CPU             | AMD Ryzen 7 3700X                   | IOMMU status still needs privileged boot-log inspection before any IOMMU policy.        |
| GPU             | NVIDIA RTX 2060 SUPER using nouveau | Do not enable module lockdown or IOMMU policies without graphics and gaming validation. |
| Network         | Intel Wi-Fi 6 AX200                 | Test recovery media network support before relying on online recovery.                  |

## Current controls to preserve

- AppArmor kernel support is enabled, but no application policies are loaded.
- `kernel.yama.ptrace_scope = 1`.
- `kernel.perf_event_paranoid = 2`.
- `kernel.randomize_va_space = 2`.
- Firewall is enabled.
- `kernel.unprivileged_userns_clone = 1` is configured for application/container compatibility.
- `split_lock_detect=off` is configured for performance and needs a later security review.
- Auditd is configured with 50 MiB files, ten-file rotation, low-space thresholds, and sudo-entry monitoring. It must be validated after deployment.

## Rollout order

1. Test and record recovery USB procedure.
2. Add low-risk control verification and rationale.
3. Configure audit logging with bounded retention.
4. Tune targeted AppArmor profiles.
5. Evaluate FIDO2 login with password fallback.
6. Plan encrypted-root migration before FIDO2 LUKS.
7. Evaluate Secure Boot only after recovery testing.
8. Skip TPM-backed SSH unless hardware gains TPM 2.0 support.

Review placeholders, verify commands, add missing examples.
