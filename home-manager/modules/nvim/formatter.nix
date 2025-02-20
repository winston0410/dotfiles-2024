{ inputs, lib, config, pkgs, unstable, ... }: {
  home.packages = with pkgs; [
    dockfmt
    gotools
    stylua
    nixfmt-classic
    # Not using Purescript anymore
    # nodePackages.purty
    # Not working with Python at the moment
    just
    kulala-fmt
    ruff
    rustfmt
    prettierd
    yamlfmt
    taplo
    shfmt
    nginx-config-formatter
    rufo
    hclfmt
    elmPackages.elm-format
    haskellPackages.hindent
    pgformatter
  ];

  xdg.configFile = { "prettier/.prettierrc" = { source = ./.prettierrc; }; };

  home.file =
    let prettierPluginDir = "${config.xdg.dataHome}/prettier/node_modules";
    in {
      # "${prettierPluginDir}/prettier-plugin-svelte" = {
      #   source = pkgs.buildNpmPackage rec {
      #     pname = "prettier-plugin-svelte";
      #     version = "3.0.3";
      #
      #     src = pkgs.fetchFromGitHub {
      #       owner = "sveltejs";
      #       repo = pname;
      #       rev = "v${version}";
      #       hash = "sha256-/kHHnzkWtlFR/SVyr98sEvjIBp4oA1a+V3Q3pc9iKIw=";
      #     };
      #
      #     npmDepsHash = "sha256-r1AeUGs9LCKDyydppgVaJVtQf6w43nm4OfNqNNe4/p8=";
      #   };
      # };

      # FIXME Cannot build this package, as this is a PNPM package, missing package-lock.json
      # "${prettierPluginDir}/@prettier/plugin-pug" = {
      #     source = pkgs.buildNpmPackage rec {
      #       pname = "@prettier/plugin-pug";
      #       version = "3.0.0";

      #       src = pkgs.fetchFromGitHub {
      #         owner = "prettier";
      #         repo = "plugin-pug";
      #         rev = "${version}";
      #         hash = "sha256-ZfaZ45tefrSzErpsIbgyBXUMQPOGAM7u1jpb2py1v9c=";
      #       };
      #     };
      # };
    };
}
