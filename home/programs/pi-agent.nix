{ pkgs, ... }:

let
  pi-agent = pkgs.buildNpmPackage {
    pname = "pi-coding-agent";
    version = "0.56.1";

    src = pkgs.fetchurl {
      url = "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.56.1.tgz";
      hash = "sha256-tYRKc9s0PFhToW/ymlEms++9lgRjv+0jEyqVFbPm2NE=";
    };

    npmDepsHash = "sha256-tYRKc9s0PFhToW/ymlEms++9lgRjv+0jEyqVFbPm2NE=";

    dontNpmBuild = true;

    nativeBuildInputs = [ pkgs.makeWrapper ];

    postInstall = ''
      wrapProgram $out/bin/pi \
        --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.nodejs_20 ]}
    '';
  };
in
{
  home.packages = [ pi-agent ];
}
