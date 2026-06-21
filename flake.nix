{
  description = "One Flake to Rule Them All";

  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  inputs = {

    #--------------------------------------------
    # nixpkgs
    #--------------------------------------------

    # stable
    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/nixos-26.05";
    };

    # unstable
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    #--------------------------------------------
    # nixpkgs
    #--------------------------------------------

    # hm stable
    # home-manager = {
    #   url = "github:nix-community/home-manager/release-25.05";
    #   inputs.nixpkgs.follows = "nixpkgs-stable";
    # };

    # hm unstable
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #--------------------------------------------
    # desktop shell
    #--------------------------------------------

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    #--------------------------------------------
    # compositor
    #--------------------------------------------

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

    devenv = {
      url = "github:cachix/devenv/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hardware-specific optimizations (AMD P-state driver for CPU power/performance)
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      stylix,
      sops-nix,
      niri,
      devenv,
      nixos-hardware,
      noctalia,
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
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          # stylix.nixosModules.stylix
          # home-manager.nixosModules.home-manager
          # {
          #   home-manager.useGlobalPkgs = true;
          #   home-manager.useUserPackages = true;
          #   home-manager.users.jokyv = import ./home/default.nix;
          # }
        ];
      };

      nixosConfigurations.dora = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/dora/default.nix
          ./hosts/dora/hardware-configuration.nix
        ];
      };

      nixosConfigurations."jokyv-install" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          hostModule = ./hosts/jokyv/default.nix;
          installConfigFile = ./install/jokyv.nix;
        };
        modules = [
          ./install/default.nix
        ];
      };

      nixosConfigurations."dora-install" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          hostModule = ./hosts/dora/default.nix;
          installConfigFile = ./install/dora.nix;
        };
        modules = [
          ./install/default.nix
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
          noctalia.homeModules.default

          # Add devenv and direnv configuration
          {
            home.packages = with pkgs; [
              devenv
              direnv
            ];
            programs.direnv = {
              enable = true;
              enableBashIntegration = true;
              nix-direnv.enable = true;
            };
          }
        ];
      };

      # Gaming mode configuration (minimal + Steam)
      # -------------------------------------------
      homeConfigurations.gaming = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit pkgs-stable; };
        modules = [
          ./home/gaming.nix
          stylix.homeModules.stylix
          sops-nix.homeManagerModules.sops
          niri.homeModules.niri
        ];
      };
    };
}
