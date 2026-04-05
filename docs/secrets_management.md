## How to generate an age key

```nix
# generate a new age key
nix shell nixpkgs#age -c age-keygen -o ~/.config/sops/age/secrets.key

# generate new key from private ssh key
nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/private > ~/.config/sops/age/secrets.key
```

## flake.nix

```nix
{
  description = "nixos config example";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    inputs.sops-nix.url = "github:Mic92/sops-nix";
    inputs.sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {

      nixosConfigurations = {
        your-hostname = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./configuration.nix ];
        };
      };

    };
}
```

## configuration.nix

```nix
{ pkgs, inputs, config, ... }:

{

  imports =
    [
      inputs.sops-nix.nixosModules.sops
    ];

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  
  sops.age.keyFile = "/home/user/.config/sops/age/secrets.key";

  sops.secrets.example-key = { };
  sops.secrets."myservice/my_subdir/my_secret" = {
    owner = "jokyv"; # add another owner, otherwise use sudo
  };

  # example with systemd service
  systemd.services."sometestservice" = {
    script = ''
        echo "
        Hey bro! I'm a service, and imma send this secure password:
        $(cat ${config.sops.secrets."myservice/my_subdir/my_secret".path})
        located in:
        ${config.sops.secrets."myservice/my_subdir/my_secret".path}
        to database and hack the mainframe
        " > /var/lib/sometestservice/testfile
      '';
    serviceConfig = {
      User = "sometestservice";
      WorkingDirectory = "/var/lib/sometestservice";
    };
  };

  users.users.sometestservice = {
    home = "/var/lib/sometestservice";
    createHome = true;
    isSystemUser = true;
    group = "sometestservice";
  };
  users.groups.sometestservice = { };

}
```

## .sops.yaml (in repo root)

```yaml
creation_rules:
  - path_regex: secrets(\\.enc)?\\.(yaml|json)$
    age: '{{YOUR PUBLIC KEY HERE}}'
```

> **Note**: You can also put this at `~/.config/sops/config.yaml` for global use.

## Commands

```bash
# Edit secrets interactively (decrypts, opens editor, re-encrypts on save)
sops secrets.enc.yaml

# Decrypt to stdout
sops -d secrets.enc.yaml

# Encrypt a plaintext file
sops -e secrets.yaml > secrets.enc.yaml
```

> The `.sops.yaml` config handles key selection automatically — no need for `--age` flags.
