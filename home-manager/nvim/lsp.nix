{ inputs, unstable, lib, config, pkgs, system, ... }: {
  home.packages = let
    # # REF https://github.com/NixOS/nixpkgs/issues/245849
    # cucumber = pkgs.buildNpmPackage rec {
    #   pname = "@cucumber/language-server";
    #   version = "1.4.0";
    #
    #   src = pkgs.fetchFromGitHub {
    #     owner = "cucumber";
    #     repo = "language-server";
    #     rev = "v${version}";
    #     hash = "sha256-cB+psMTjcRmOJIhpF1duWreo2IxCQJX6uId5P3yaghg=";
    #   };
    #
    #   # REF https://github.com/nodejs/node/issues/2341
    #   # We need libtool 2.6.2 to avoid issue, but it is really old and building it is causing issue
    #   nativeBuildInputs = [ pkgs.python3 pkgs.libtool ];
    #
    #   npmDepsHash = "sha256-26U2qlyz0VolgKLSeFvKWYC9yae86vNHlTwJPy8HZxQ=";
    # };
  in [
    pkgs.rust-analyzer
    pkgs.gopls
    pkgs.rnix-lsp
    pkgs.ccls
    pkgs.haskell-language-server
    pkgs.elixir_ls
    pkgs.nodePackages.purescript-language-server
    pkgs.nodePackages.bash-language-server
    pkgs.nodePackages.dockerfile-language-server-nodejs
    pkgs.nodePackages.yaml-language-server
    pkgs.nodePackages.vls
    pkgs.nodePackages.vim-language-server
    pkgs.nodePackages.typescript-language-server
    pkgs.nodePackages.pyright
    pkgs.haskellPackages.dhall-lsp-server
    pkgs.terraform-ls
    pkgs.solargraph
    pkgs.metals
    pkgs.nodePackages.vscode-langservers-extracted
    pkgs.lua-language-server
    pkgs.deno
    # cucumber
  ] ++ [ unstable.nodePackages.svelte-language-server ];
}
