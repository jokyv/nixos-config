# Installation Guide

- Plug in USB stick with minimal NixOS ISO
- Enable internet
- Next run `git clone https://github.com/YOUR-USER/nixos-config.git /tmp/nixos-config`
- Use `lsblk` to identify the name of the disk of the target computer, you might need to modify the file `hosts/jokyv/disk/disk-config-btrfs-luks.nix`
- nix run `nix run --experimental-features "nix-command flakes" github:nix-community/disko -- --mode disko --flake .#nixos` format and partition the disk.
- Add user's password in the system config (then delete it, do not push it to git)
  - Alternatively you can store passwords safely with sops-nix
  - How? `import = [ inputs.sops-nix.nixosModules.sops ]`
  - `sops.secret."pass_new_user" = { };`
  - `passwordFile = config.sops.secrets."pass_new_user".path`
- Next run `sudo nixos-install --no-root-password --flake .#nixos`
- Next run `reboot` and remove the USB stick when computer turns off
- Next run `git clone git@github.com/nixos-config.git` into `/home/`
- Next run `cd nixos-config`
- Next run `just home` NOTE: home-manager might not have been installed yet
  - If so run `nix shell home-manager`
  - Or you can have `home-manager` integrated into system and `nixos-install` everything

## check if partition is correct

- Run `findmnt /tmp`
- Run `findmnt /var`
- Run `sudo btrfs subvolume list /`

## Post-installation script

- symlink configuration for `aider-chat`
- Symlink configurations to `.config` for example ruff.toml
