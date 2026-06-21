{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # NPM
    bun

    # Shells & Terminals
    alacritty

    # Development Tools
    neovim
    git-cliff
    gh
    jaq
    jq
    gum
    uv
    virtualenv # need this for python virtual env

    # Rust and tools
    rustc
    cargo
    clippy
    rustfmt
    rust-analyzer
    cargo-watch
    cargo-edit

    # Python with packages
    (python313.withPackages (
      ps: with ps; [
        requests
        pyyaml
        rich
      ]
    ))
  ];
}
