{ inputs, unstable, lib, config, pkgs, system, ... }: {
  home.packages = let
  in [
    # REF https://github.com/NixOS/nixpkgs/pull/385105
    # kulala-ls
    pkgs.clojure-lsp
    pkgs.ts_query_ls
    pkgs.gdtoolkit_3
    pkgs.openscad-lsp
    pkgs.protols
    pkgs.docker-compose-language-service
    pkgs.docker-language-server
    pkgs.typos-lsp
    pkgs.vacuum-go
    pkgs.nginx-language-server
    pkgs.pest-ide-tools
    pkgs.rust-analyzer
    pkgs.roslyn-ls
    pkgs.gopls
    pkgs.vue-language-server
    pkgs.ccls
    pkgs.haskell-language-server
    pkgs.elixir-ls
    pkgs.nodePackages.purescript-language-server
    pkgs.nodePackages.bash-language-server
    pkgs.dockerfile-language-server
    pkgs.yaml-language-server
    pkgs.nodePackages.vim-language-server
    pkgs.nodePackages.typescript-language-server
    pkgs.basedpyright
    pkgs.haskellPackages.dhall-lsp-server
    pkgs.terraform-ls
    pkgs.solargraph
    pkgs.metals
    pkgs.vscode-langservers-extracted
    pkgs.lua-language-server
    # inputs.emmylua-analyzer-rust.packages.${system}.default
    pkgs.deno
    pkgs.jsonnet-language-server
    pkgs.nodePackages.graphql-language-service-cli
    inputs.nixd.packages.${system}.default
    inputs.config-lsp.packages.${system}.default
    pkgs.beancount-language-server
    pkgs.texlab
    pkgs.tilt
    pkgs.slint-lsp
    pkgs.ltex-ls-plus
    pkgs.angular-language-server
    pkgs.shellcheck
    pkgs.lemminx
    pkgs.systemd-lsp
    # (pkgs.stdenv.mkDerivation rec {
    #   pname = "npm-workspaces-lsp";
    #   version = "0.1.0"; # update per release

    #   src = pkgs.fetchFromGitHub {
    #     owner = "AkisArou";
    #     repo = "npm-workspaces-lsp";
    #     rev = "main";
    #     sha256 = "sha256-REtVKcPrjBsOQBUJh6yx3nlG2WNodUjPLyFesonYfG0=";
    #   };

    #   nativeBuildInputs = [ pkgs.pnpm_9.configHook ];
    #   buildInputs = [ pkgs.pnpm_9 pkgs.nodejs_22 ];

    #   pnpmDeps = pkgs.pnpm_9.fetchDeps {
    #     inherit pname version src;
    #     hash = "sha256-3E02rUg/ElyoBHj06rBBqPfvY5Z/BoUIlWvh/6kD4lk=";
    #   };

    #   buildPhase = ''
    #     pnpm install --frozen-lockfile
    #     pnpm --filter=npm-workspaces-language-server build
    #   '';

    #   installPhase = ''
    #     mkdir -p $out/bin
    #     ls -al ./packages/lsp-server/dist
    #     cp ./packages/lsp-server/dist/server.js $out/bin/npm-workspaces-lsp
    #   '';

    #   dontCheck = true;
    # })
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
  ] ++ [ pkgs.nodePackages.svelte-language-server pkgs.postgres-language-server ];
}
