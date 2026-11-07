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

      checks.${system} = {
        gnome-policy =
          let
            gnome = nixpkgs.lib.nixosSystem {
              inherit system;
              specialArgs = { inherit inputs; };
              modules = [ ./hosts/dora/default.nix ];
            };
            config = gnome.config;
          in
          assert config.services.desktopManager.gnome.enable;
          assert config.users.users.jokyv.isNormalUser;
          assert builtins.elem "wheel" config.users.users.jokyv.extraGroups;
          assert config.users.users.dora.isNormalUser;
          assert !(builtins.elem "wheel" config.users.users.dora.extraGroups);
          assert config.home-manager.users.jokyv.home.username == "jokyv";
          assert config.home-manager.users.dora.home.username == "dora";
          assert config.home-manager.users.jokyv.programs.git.enable;
          assert !config.home-manager.users.dora.programs.git.enable;
          assert !config.system.autoUpgrade.enable;
          assert !config.systemd.timers.prefetch-system-closure.enable;
          assert !config.systemd.paths.prefetch-system-closure.enable;
          assert !(builtins.hasAttr "/home/jokyv/.cache/fontconfig" config.fileSystems);
          assert !(builtins.hasAttr "/home/jokyv/.cache/mesa_shader_cache" config.fileSystems);
          pkgs.runCommand "gnome-policy-check" { } ''
            touch "$out"
          '';

        desktop-profiles =
          let
            niriDev = self.homeConfigurations."jokyv@nixos-niri-development".config;
            ng = self.homeConfigurations."jokyv@nixos-niri-gaming".config;
            gd = self.homeConfigurations."jokyv@nixos-gnome-development".config;
            gg = self.homeConfigurations."jokyv@nixos-gnome-gaming".config;
          in
          assert niriDev.wayland.windowManager.niri.enable && ng.wayland.windowManager.niri.enable;
          assert !gd.wayland.windowManager.niri.enable && !gg.wayland.windowManager.niri.enable;
          assert
            niriDev.programs.noctalia.enable && !gd.programs.noctalia.enable && !gg.programs.noctalia.enable;
          assert niriDev.home.sessionVariables.WM == "niri" && ng.home.sessionVariables.WM == "niri";
          assert gd.home.sessionVariables.WM == "gnome" && gg.home.sessionVariables.WM == "gnome";
          pkgs.runCommand "desktop-profiles-check" { } ''
            touch "$out"
          '';

        desktop-sessions =
          let
            host = self.nixosConfigurations.nixos.config;
            sessions = host.services.displayManager.sessionData.sessionNames;
            home = self.homeConfigurations.jokyv.config;
          in
          assert host.services.displayManager.regreet.enable;
          assert host.services.displayManager.defaultSession == "niri";
          assert builtins.elem "niri" sessions;
          assert builtins.elem "gnome" sessions;
          assert home.systemd.user.services.noctalia.Unit.ConditionEnvironment == "XDG_CURRENT_DESKTOP=niri";
          pkgs.runCommand "desktop-sessions-check" { } ''
            touch "$out"
          '';
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
        modules = jokyvPortableModules;
      };
      homeConfigurations."dora@nixos-gnome" = mkHome {
        username = "dora";
        inherit system;
        modules = [ ./home/users/dora.nix ];
      };
      homeConfigurations."jokyv@mac-hm" = mkHome {
        username = "jokyv";
        system = "aarch64-darwin";
        modules = jokyvPortableModules;
      };

      # Gaming mode configuration (minimal + Steam)
      # -------------------------------------------
      homeConfigurations.gaming = mkPcGaming "niri";
    };
}
