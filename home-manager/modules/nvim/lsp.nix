{ inputs, unstable, lib, config, pkgs, system, ... }: {
  home.packages = let
  in [
    # REF https://github.com/NixOS/nixpkgs/pull/385105
    # kulala-ls
    pkgs.openscad-lsp
    unstable.protols
    unstable.codebook
    pkgs.docker-compose-language-service
    unstable.docker-language-server
    pkgs.vacuum-go
    pkgs.nginx-language-server
    pkgs.pest-ide-tools
    pkgs.rust-analyzer
    pkgs.roslyn-ls
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
    unstable.basedpyright
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
    pkgs.ansible-language-server
    pkgs.beancount-language-server
    pkgs.texlab
    pkgs.tilt
    pkgs.slint-lsp
    unstable.ltex-ls-plus
    pkgs.angular-language-server
    pkgs.shellcheck
    pkgs.lemminx
    (pkgs.rustPlatform.buildRustPackage rec {
      pname = "systemd-lsp";
      version = "0.1.0";

      src = pkgs.fetchFromGitHub {
        owner = "JFryy";
        repo = "systemd-lsp";
        rev = "dabbed8e5323a379002ad41e51e4066e979eedd6";
        sha256 = "sha256-Q4Q07f0v+yH/qUQiv7hIWEwVC9te9lfv3nXIFY7l6hw=";
      };

      cargoHash = "sha256-LgkSJsp2MxrmRmM+FC/Yrp/RzYSY4FesEC4NstV47So=";

      meta = with pkgs.lib; {
        description = "systemd language server for systemd unit files";
        homepage = "https://github.com/JFryy/systemd-lsp";
        license = licenses.mit;
        platforms = platforms.unix;
      };
    })
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
  ] ++ [ unstable.nodePackages.svelte-language-server unstable.postgres-lsp ];
}
