{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    python312
    python312Packages.polars
    python312Packages.pandas
    xonsh
  ];

  shellHook = ''
    echo "Python development environment activated"
    export PYTHONPATH="${pkgs.python312Packages.polars}/lib/python3.12/site-packages:$PYTHONPATH"
    export PYTHONPATH="${pkgs.python312Packages.pandas}/lib/python3.12/site-packages:$PYTHONPATH"

    # Switch to Xonsh
    exec ${pkgs.xonsh}/bin/xonsh
  '';
}
