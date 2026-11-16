# Configuration structure

The repository separates system configurations from standalone Home Manager configurations. Names such as `nixos-niri` describe a configuration; they do not change the machine's network hostname.

## Home Manager outputs

| Output                          | User  | Platform            | Status                                                                       |
| ------------------------------- | ----- | ------------------- | ---------------------------------------------------------------------------- |
| `jokyv@nixos-niri`              | jokyv | x86_64 Linux, Niri  | Existing development configuration; alias of the PC Niri development profile |
| `jokyv@nixos-niri-development`  | jokyv | This PC, Niri       | Development profile (`just dev-niri`)                                        |
| `jokyv@nixos-niri-gaming`       | jokyv | This PC, Niri       | Gaming profile (`just game-niri`)                                            |
| `jokyv@nixos-gnome-development` | jokyv | This PC, GNOME      | Development profile (`just dev-gnome`)                                       |
| `jokyv@nixos-gnome-gaming`      | jokyv | This PC, GNOME      | Gaming profile (`just game-gnome`)                                           |
| `jokyv@nixos-gnome`             | jokyv | x86_64 Linux, GNOME | Portable CLI settings; no GNOME-specific settings yet                        |
| `dora@nixos-gnome`              | dora  | x86_64 Linux, GNOME | Minimal scaffold; no GNOME settings or user packages yet                     |
| `jokyv@mac-hm`                  | jokyv | Apple Silicon macOS | Portable CLI settings; no Mac-specific settings yet                          |
| `gaming`                        | jokyv | x86_64 Linux        | Existing gaming configuration                                                |

The two new `jokyv` profiles share the existing Git, Helix, fd, ripgrep, fzf, zoxide and Starship modules through `home/users/jokyv.nix`. This includes John's Git identity and its existing credential-helper and external-script settings. They do not include Niri or secrets. Jokyv's portable profiles configure `~/.bun/bin` for Bash, but Bun, Pi, and OMP remain manually installed; Pi also needs Node.js. Home Manager manages the shell startup files, which may conflict with existing files. Dora's profile (`home/users/dora.nix`) is intentionally minimal; it does not inherit John's Git identity or tools. Do not switch an existing Home Manager installation to these incomplete profiles without reviewing what it would remove. The Mac architecture is an assumption and must be confirmed on the machine.

Home Manager does not create operating-system user accounts. The GNOME host imports `hosts/users/jokyv.nix` and `hosts/users/dora.nix`: `jokyv` is in `wheel` for sudo, and `dora` is not. Dora retains the pre-existing `input` and other device groups; review these permissions before installation. The GNOME host integrates Home Manager and activates both users' home profiles during NixOS activation; Jokyv's account uses the same portable Bun shell setup. The standalone GNOME outputs remain available for evaluation, but should not also manage the same homes without a migration plan. The configuration does not set passwords. During installation, set a password for each account (for example, with `nixos-enter --root /mnt -c 'passwd jokyv'` and then `passwd dora`) before relying on password login.

## System outputs and hardware

- `nixos-niri`: existing system with both Niri and GNOME sessions; hostname remains `nixos`. ReGreet remains the login manager and Niri the default. Noctalia's Niri development-profile service is restricted to Niri. The four PC profiles have been built but neither the system nor the desktop combinations have been tested by logging in.
- `jokyv-install`: existing installer.
- GNOME host policy is exposed as `nixosModules.nixos-gnome` from `hosts/dora`, but **there is no deployable `nixos-gnome` system output**. It enables `nix-ld` system-wide for compatible manually installed Linux binaries. It enables GNOME and explicitly installs Firefox, Evince, GNOME Calculator, GNOME Text Editor, Loupe, and Nautilus; NixOS GNOME defaults may add other apps. The target hardware configuration is missing. The shared Btrfs module no longer creates Jokyv's UID-specific cache mounts for Dora, but its remaining Btrfs scrub policy still needs review against the target filesystem. Add the machine's own hardware configuration before creating a system output. Never reuse the Niri machine's disk identifiers.
- The GNOME policy also imports the existing maintenance module. Automatic upgrades and the prefetch timer/path are disabled on GNOME until provisioning is complete: the prefetch command assumes a checkout at `/home/dora/nixos-config` and selects an output matching the hostname `dora`, which is not currently defined. Review maintenance and Nix trusted-user settings for the machine before enabling those services.
- `mac-hm` is a Home Manager target, not a NixOS system or a nix-darwin configuration.

## Migration aliases

`nixosConfigurations.nixos` aliases `nixosConfigurations.nixos-niri`, and `homeConfigurations.jokyv` aliases `homeConfigurations."jokyv@nixos-niri"`. Existing `gaming` and `jokyv-install` outputs remain unchanged. The existing `just` recipes still use these names.

Keep aliases until the new configurations are tested on their intended machines and all repository and external scripts have migrated. Remove them separately after confirmation; update `justfile`, prefetch scripts and documentation first.

## Building and applying

For example, for the standalone Niri profile, from a checked-out repository:

```bash
nix build --no-link '.#homeConfigurations."jokyv@nixos-niri".activationPackage'
home-manager switch --flake '.#jokyv@nixos-niri'
```

Build or evaluate first; activation changes the selected user's home. On the separate Dora GNOME machine, use its NixOS-integrated Home Manager configuration instead of running a standalone switch against the same homes. macOS builds should be tested on the actual Mac.

On this PC, select GNOME or Niri at login and run the matching `just dev-*` or `just game-*` command from that session. Profile switches do not change the desktop session, and changing sessions does not automatically switch profiles. Log out and back in after switching profiles so session variables and services are refreshed. Until the matching profile is applied, the other desktop's settings may still be active; Niri may start with its defaults if its managed configuration is absent. Existing `just home` and `just game` continue to select the Niri profiles as compatibility commands. GNOME use and switching still require runtime testing.

## Extending

The PC's development home composition lives in `home/default.nix`, `home/core`, and `home/profiles/development`; the gaming composition is `home/gaming.nix`. Both receive a `desktopSession` module argument, which controls the Niri configuration, Noctalia startup, and `WM` session variable. Portable user settings live in `home/users/`; GNOME's system accounts live in `hosts/users/`. Niri retains its original account module in `hosts/jokyv/users.nix` to avoid changing its existing configuration. Extract more portable modules only after checking their platform, user identity, secrets and external script dependencies. For an additional person, add separate system and home user modules, import them on the appropriate host, and define any needed standalone Home Manager output with the correct architecture and home directory.

The hardware-independent GNOME policy check is runnable with:

```bash
nix build --no-link '.#checks.x86_64-linux.gnome-policy'
```

It checks GNOME, both accounts, wheel membership, Home Manager user isolation, disabled scheduled upgrades/prefetching, and the absence of Jokyv's cache mounts. It does not validate disk setup, boot, graphics, logins, or installed applications.
