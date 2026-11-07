{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Language Servers
    bash-completion
    bash-language-server
    dprint
    # ltex-ls-plus # more strict than typos
    markdown-oxide # https://oxide.md/v0/Articles/Markdown-Oxide+v0
    # marksman # using markdown-oxide currently
    nixd
    nixfmt # official nix formatter, formats one file at a time.
    nixfmt-tree # official nix formatter, formats whole project.
    nufmt
    # python313Packages.python-lsp-server
    # ty  # Managed by home-manager module (./programs/ty.nix)
    shfmt
    taplo
    typos
    typos-lsp
    vscode-langservers-extracted
    yaml-language-server
    just-lsp
  ];
}
