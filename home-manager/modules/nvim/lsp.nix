{ inputs, unstable, lib, config, pkgs, system, ... }: {
  home.packages = let
  in [
    pkgs.rust-analyzer
    unstable.gopls
    pkgs.vue-language-server
    pkgs.ccls
    pkgs.haskell-language-server
    pkgs.elixir_ls
    pkgs.nodePackages.purescript-language-server
    pkgs.nodePackages.bash-language-server
    pkgs.nodePackages.dockerfile-language-server-nodejs
    pkgs.nodePackages.yaml-language-server
    pkgs.nodePackages.vim-language-server
    pkgs.nodePackages.typescript-language-server
    pkgs.pyright
    pkgs.haskellPackages.dhall-lsp-server
    pkgs.terraform-ls
    pkgs.solargraph
    pkgs.metals
    pkgs.vscode-langservers-extracted
    pkgs.lua-language-server
    pkgs.deno
    pkgs.jsonnet-language-server
    pkgs.nodePackages.graphql-language-service-cli
    inputs.nixd.packages.${system}.default
    pkgs.ansible-language-server
    pkgs.beancount-language-server
    pkgs.texlab
    pkgs.tilt
    pkgs.slint-lsp
    pkgs.ltex-ls
    pkgs.angular-language-server
    pkgs.shellcheck
    pkgs.lemminx
    # TODO install @astrojs/language-server, https://github.com/withastro/language-tools/tree/main/packages/language-server
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
    # NOTE this package does not use package-lock.json, need to fix that
    # (pkgs.buildNpmPackage rec {
    #   pname = "@vue/typescript-plugin";
    #   version = "2.1.10";
    #
    #   src = pkgs.fetchFromGitHub {
    #     owner = "vuejs";
    #     repo = "language-tools";
    #     rev = "v${version}";
    #     hash = "sha256-tmFl1Fi8jnxwr/2LQsZ5yCg/HDIC6NoDGAwww3Yh99Y=";
    #   };
    #
    #   npmDepsHash = "sha256-0009WrnwN6wM9S76PsGrPTmmiMBUKu4T2Al3HH3Wo+w=";
    # })
  ] ++ [ unstable.nodePackages.svelte-language-server unstable.postgres-lsp ]
  ++ lib.optionals pkgs.stdenv.isLinux [ pkgs.csharp-ls ];

}
