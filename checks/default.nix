{
  self,
  inputs,
  nixpkgs,
  pkgs,
  system,
}:

{
  gnome-policy =
    let
      gnome = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [ ../hosts/dora/default.nix ];
      };
      config = gnome.config;
    in
    assert config.services.desktopManager.gnome.enable;
    assert config.programs.nix-ld.enable;
    assert config.users.users.jokyv.isNormalUser;
    assert builtins.elem "wheel" config.users.users.jokyv.extraGroups;
    assert config.users.users.dora.isNormalUser;
    assert !(builtins.elem "wheel" config.users.users.dora.extraGroups);
    assert config.home-manager.users.jokyv.home.username == "jokyv";
    assert config.home-manager.users.dora.home.username == "dora";
    assert config.home-manager.users.jokyv.programs.git.enable;
    assert builtins.elem "/home/jokyv/.bun/bin" config.home-manager.users.jokyv.home.sessionPath;
    assert config.home-manager.users.jokyv.programs.bash.enable;
    assert !config.home-manager.users.jokyv.programs.zsh.enable;
    assert !config.home-manager.users.dora.programs.git.enable;
    assert !(builtins.elem "/home/dora/.bun/bin" config.home-manager.users.dora.home.sessionPath);
    assert !config.services.openssh.enable;
    assert !(builtins.elem 22 config.networking.firewall.allowedTCPPorts);
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

  portable-bun =
    let
      gnome = self.homeConfigurations."jokyv@nixos-gnome".config;
      gnomeDev = self.homeConfigurations."jokyv@nixos-gnome-development".config;
      gnomeGame = self.homeConfigurations."jokyv@nixos-gnome-gaming".config;
      mac = self.homeConfigurations."jokyv@mac-hm".config;
      niri = self.homeConfigurations.jokyv.config;
    in
    assert builtins.elem "/home/jokyv/.bun/bin" gnome.home.sessionPath;
    assert builtins.elem "/home/jokyv/.bun/bin" gnomeDev.home.sessionPath;
    assert builtins.elem "/home/jokyv/.bun/bin" gnomeGame.home.sessionPath;
    assert builtins.elem "/Users/jokyv/.bun/bin" mac.home.sessionPath;
    assert builtins.head niri.home.sessionPath == "/home/jokyv/.bun/bin";
    assert gnome.programs.bash.enable && mac.programs.bash.enable && niri.programs.bash.enable;
    assert !(builtins.elem "globstar" mac.programs.bash.shellOptions);
    assert !(builtins.elem "checkjobs" mac.programs.bash.shellOptions);
    assert !gnome.programs.zsh.enable && !gnomeDev.programs.zsh.enable;
    assert !gnomeGame.programs.zsh.enable && !mac.programs.zsh.enable && !niri.programs.zsh.enable;
    pkgs.runCommand "portable-bun-check" { } ''
      testHome="$TMPDIR/home"
      mkdir -p "$testHome/.bun/bin"
      for program in bun pi omp; do
        touch "$testHome/.bun/bin/$program"
        chmod +x "$testHome/.bun/bin/$program"
      done
      env -i HOME="$testHome" PATH=${pkgs.coreutils}/bin:${pkgs.gnugrep}/bin TERM=dumb \
        ${pkgs.bash}/bin/bash --noprofile --norc -ic '
          source ${gnome.home.file.".bashrc".source}
          for program in bun pi omp; do
            test "$(command -v "$program")" = "$HOME/.bun/bin/$program" || exit 1
          done
          test "$BUN_INSTALL" = "$HOME/.bun"
        '
      env -i HOME="$testHome" PATH=${pkgs.coreutils}/bin:${pkgs.gnugrep}/bin TERM=dumb \
        ${pkgs.bash}/bin/bash --noprofile --norc -c '
          source ${gnome.home.file.".profile".source}
          case ":$PATH:" in *:/home/jokyv/.bun/bin:*) ;; *) exit 1 ;; esac
          test "$BUN_INSTALL" = /home/jokyv/.bun
        '
      env -i HOME="$testHome" PATH=${pkgs.coreutils}/bin:${pkgs.gnugrep}/bin TERM=dumb \
        __HM_SESS_VARS_SOURCED=1 ${pkgs.bash}/bin/bash --noprofile --norc -c '
          source ${gnome.home.file.".profile".source}
          for program in bun pi omp; do
            test "$(command -v "$program")" = "$HOME/.bun/bin/$program" || exit 1
          done
          test "$BUN_INSTALL" = "$HOME/.bun"
        '
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
}
