{ inputs, unstable, lib, config, pkgs, system, ... }: {
  home.packages = let
  in [
    pkgs.rust-analyzer
    unstable.gopls
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
    unstable.deno
    pkgs.jsonnet-language-server
    pkgs.buf-language-server
    pkgs.nodePackages.graphql-language-service-cli
    inputs.nixd.packages.${system}.default
    pkgs.ansible-language-server
    pkgs.beancount-language-server
    pkgs.texlab
    pkgs.tilt
    pkgs.slint-lsp
    pkgs.ltex-ls
    # TODO install @astrojs/language-server, https://github.com/withastro/language-tools/tree/main/packages/language-server
    # # Not sure how to handle pnpm package yet, https://github.com/NixOS/nixpkgs/issues/231513
    # (pkgs.buildNpmPackage rec {
    #   pname = "@angular/language-server";
    #   version = "16.2.0";
    #
    #   src = pkgs.fetchFromGitHub {
    #     owner = "angular";
    #     repo = "vscode-ng-language-service";
    #     rev = "v${version}";
    #     hash = "sha256-NLemLEYfvRFVSIK8deCVUUU2/27sjflNBnMAyyrAGzc=";
    #   };
    #
    #   # # REF https://github.com/nodejs/node/issues/2341
    #   # # We need libtool 2.6.2 to avoid issue, but it is really old and building it is causing issue
    #   nativeBuildInputs = [ pkgs.python3 pkgs.libtool ];
    #
    #   npmDepsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    # })
    # # # REF https://github.com/NixOS/nixpkgs/issues/245849
    # (pkgs.buildNpmPackage rec {
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
    # })
    (pkgs.buildNpmPackage rec {
      pname = "@microsoft/compose-language-service";
      version = "0.2.0";

      src = pkgs.fetchFromGitHub {
        owner = "microsoft";
        repo = "compose-language-service";
        rev = "v${version}";
        hash = "sha256-UBnABi7DMKrAFkRA8H6us/Oq4yM0mJ+kwOm0Rt8XnGw=";
      };

      npmDepsHash = "sha256-G1X9WrnwN6wM9S76PsGrPTmmiMBUKu4T2Al3HH3Wo+w=";
    })
    # FIXME this build does not work yet
    # (pkgs.buildNpmPackage rec {
    #   pname = "@mistweaverco/kulala-ls";
    #   version = "1.0.12";
    #
    #   src = pkgs.fetchFromGitHub {
    #     owner = "mistweaverco";
    #     repo = "kulala-ls";
    #     rev = "v${version}";
    #     hash = "sha256-ifOmj/n8Fp9oi4BQ7yyfRHSIB1Bd/mxOXAcbkUGtoF8=";
    #   };
    #
    #   nativeBuildInputs = [ pkgs.python3 pkgs.libtool ];
    #
    #   npmDepsHash = "sha256-CJQLK3PpdWb4SXqk15xrPQU4CrYFPh2kO2wLb+VaIPY=";
    # })
  ] ++ [ unstable.nodePackages.svelte-language-server unstable.postgres-lsp ];
}
