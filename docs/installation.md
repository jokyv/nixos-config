# Installation Guide

## Option 1: Universal Installer (Recommended)

- Plug in USB stick with minimal NixOS ISO
- Enable internet!
- Clone this repository: `git clone https://github.com/jokyv/nixos-config.git /tmp/nixos-config`
- Edit `install-config.nix` at the root to configure your system:
  ```nix
  {
    hostname = "nixos";
    disk = {
      filesystem = "btrfs";  # or "ext4"
      useLuks = true;        # encryption
      swapSize = "32G";
      efiSize = "512M";
    };
  }
  ```
- Run the universal installer (auto-detects first disk):
  ```bash
  sudo nix run --experimental-features "nix-command flakes" github:nix-community/disko -- --mode disko --flake .#nixos
  ```
- The installer will automatically format and partition the first available disk

## Option 2: Legacy Manual Configuration

- Use `lsblk` to identify the disk name
- Modify the appropriate disk config file in `disks/` directory
- Run the same disko command above

The universal installer eliminates the need to manually identify disk names!
- Add user's password in the system config (then delete it, do not push it to git)
  - Edit `hosts/jokyv/default.nix` and add:\
    `users.users.jokyv.initialPassword = "changeme";`
  - Alternatively you can store passwords safely with sops-nix
  - How? `import = [ inputs.sops-nix.nixosModules.sops ]`
  - `sops.secret."pass_new_user" = { };`
  - `passwordFile = config.sops.secrets."pass_new_user".path`
- Next run `sudo nixos-install --no-root-password --flake .#nixos`
- Next run `reboot` and remove the USB stick when computer turns off
- Next run `git clone git@github.com:jokyv/nixos-config.git` into `home` dir
- Next run `cd nixos-config`
- Next run `nix shell -p home-manager` to install home-manager temporary
- Next run `just home`
  - Or you can have `home-manager` integrated into system and `nixos-install` everything

## check if disko has done a good job

- Run `findmnt /tmp`
- Run `findmnt /var`
- Run `sudo btrfs subvolume list /`

## Post-installation script

- symlink configuration for `aider-chat`
- Symlink configurations to `.config` for example ruff.toml
