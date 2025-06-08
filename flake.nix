{
  description = "My Home Manager configuration";

  inputs = {
    # stable
    # nixpkgs.url = "nixpkgs/nixos-24.05";
    # home-manager.url = "github:nix-community/home-manager/release-24.05";
    # home-manager.inputs.nixpkgs.follows = "nixpkgs-stable";

    # unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, stylix, sops-nix, niri, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # NixOS system configuration
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/jokyv/default.nix
          ./hosts/jokyv/hardware-configuration.nix
          # stylix.nixosModules.stylix
          # home-manager.nixosModules.home-manager
          # {
          #   home-manager.useGlobalPkgs = true;
          #   home-manager.useUserPackages = true;
          #   home-manager.users.jokyv = import ./home/default.nix;
          # }
        ];
      };

      # Home Manager configuration (standalone)
      homeConfigurations.jokyv = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home/default.nix
          stylix.homeModules.stylix
          sops-nix.homeManagerModules.sops
          niri.homeModules.niri
          # nh.homeModules.default
        ];
      };
    };
}
