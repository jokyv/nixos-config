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

## .sops.yaml inside your nixos-config repo

```nix
keys:
  # name of the key is primary
  - &primary {{YOUR KEY HERE}}
creation_rules:
  - path_regex: secrets/secrets.yaml$
    key_groups:
    - age:
      - *primary
```

## Commands

```bash
# encrypt / decrypt secrets.yaml file
sops secrets.yaml
```
