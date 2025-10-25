{
  description = "One Flake to Rule Them All";

  inputs = {

    # nixpkgs stable
    nixpkgs-stable = {
      url = "github:NixOS/nixpkgs/nixos-25.05";
    };

    # nixpkgs unstable
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    # home manager stable
    # home-manager = {
    #   url = "github:nix-community/home-manager/release-25.05";
    #   inputs.nixpkgs.follows = "nixpkgs-stable";
    # };

    # home manager unstable
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # quickshell = {
    #   url = "github:outfoxxed/quickshell";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # noctalia = {
    #   url = "github:noctalia-dev/noctalia-shell";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.quickshell.follows = "quickshell";
    # };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      stylix,
      sops-nix,
      niri,
      disko,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-stable = nixpkgs-stable.legacyPackages.${system};
    in
    {
      # NixOS system configuration
      # here you can create different configurations with different host names for different machines
      # -----------------------------------------------------
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system; # this is equal to system = system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/jokyv/default.nix # aka configuration.nix file
          ./hosts/jokyv/hardware-configuration.nix
          disko.nixosModules.disko
          ./hosts/jokyv/disk/disk-config-btrfs.nix
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
      # ---------------------------------------
      homeConfigurations.jokyv = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit pkgs-stable; };
        modules = [
          ./home/default.nix
          stylix.homeModules.stylix
          sops-nix.homeManagerModules.sops
          niri.homeModules.niri
          # noctalia.homeModules.default
        ];
      };
    };
}
