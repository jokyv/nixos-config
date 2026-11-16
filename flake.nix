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

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:nix-community/nh";
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

    herdr = {
      url = "github:herdrdev/herdr/v0.8.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hardware-specific optimizations (AMD P-state driver for CPU power/performance)
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      stylix,
      sops-nix,
      devenv,
      nixos-hardware,
      noctalia,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-stable = nixpkgs-stable.legacyPackages.${system};

      # User-specific tools that do not depend on the Linux desktop.
      jokyvPortableModules = [ ./home/users/jokyv.nix ];

      mkPcDevelopment =
        desktopSession:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs pkgs-stable desktopSession; };
          modules = jokyvPortableModules ++ [
            ./home/default.nix
            stylix.homeModules.stylix
            sops-nix.homeManagerModules.sops
            noctalia.homeModules.default
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

      mkPcGaming =
        desktopSession:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit pkgs-stable desktopSession; };
          modules = [
            ./home/gaming.nix
            stylix.homeModules.stylix
            sops-nix.homeManagerModules.sops
            noctalia.homeModules.default
          ];
        };

      mkHome =
        {
          username,
          system,
          modules ? [ ],
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            {
              home = {
                inherit username;
                homeDirectory = if system == "aarch64-darwin" then "/Users/${username}" else "/home/${username}";
                stateVersion = "24.05";
              };
              programs.home-manager.enable = true;
            }
          ]
          ++ modules;
        };
    in
    {
      formatter.${system} = pkgs.nixfmt;

      # Host policy only: the GNOME machine still needs its own hardware module.
      nixosModules.nixos-gnome = import ./hosts/dora/default.nix;

      checks.${system} = import ./checks {
        inherit
          self
          inputs
          nixpkgs
          pkgs
          system
          ;
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          just
          deadnix
          statix
          nix-diff
          nix-index
          nix-prefetch-git
          nixfmt
          nix-output-monitor
          nil
        ];
      };

      # NixOS system configuration
      # here you can create different configurations with different host names for different machines
      # -----------------------------------------------------
      nixosConfigurations = rec {
        # Temporary compatibility alias for existing scripts and commands.
        nixos = nixos-niri;
        nixos-niri = nixpkgs.lib.nixosSystem {
          inherit system; # this is equal to system = system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/jokyv/default.nix # aka configuration.nix file
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

        "jokyv-install" = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            hostModule = ./hosts/jokyv/default.nix;
            installerHardwareModule = ./hosts/jokyv/installer-hardware.nix;
            installConfigFile = ./install/jokyv.nix;
          };
          modules = [
            ./install/default.nix
          ];
        };

      };

      # Home Manager configuration (standalone)
      # ---------------------------------------
      homeConfigurations."jokyv@nixos-niri" = mkPcDevelopment "niri";
      homeConfigurations."jokyv@nixos-niri-development" = self.homeConfigurations."jokyv@nixos-niri";
      homeConfigurations."jokyv@nixos-gnome-development" = mkPcDevelopment "gnome";
      homeConfigurations."jokyv@nixos-niri-gaming" = self.homeConfigurations.gaming;
      homeConfigurations."jokyv@nixos-gnome-gaming" = mkPcGaming "gnome";

      # Temporary compatibility alias for existing scripts and commands.
      homeConfigurations.jokyv = self.homeConfigurations."jokyv@nixos-niri";

      homeConfigurations."jokyv@nixos-gnome" = mkHome {
        username = "jokyv";
        inherit system;
        modules = jokyvPortableModules ++ [ ./home/users/bun-shell.nix ];
      };
      homeConfigurations."dora@nixos-gnome" = mkHome {
        username = "dora";
        inherit system;
        modules = [ ./home/users/dora.nix ];
      };
      homeConfigurations."jokyv@mac-hm" = mkHome {
        username = "jokyv";
        system = "aarch64-darwin";
        modules = jokyvPortableModules ++ [ ./home/users/bun-shell.nix ];
      };

      # Gaming mode configuration (minimal + Steam)
      # -------------------------------------------
      homeConfigurations.gaming = mkPcGaming "niri";
    };
}
