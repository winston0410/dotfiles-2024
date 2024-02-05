{ inputs, lib, config, pkgs, unstable, ... }: {
  home.packages = with pkgs; [
    dockfmt
    gotools
    stylua
    nixfmt
    python39Packages.black
    # Install rustfmt in the rust module. Not sure if there is a better way
    rustfmt
    nodePackages.purty
    nodePackages.prettier
    yamlfmt
    taplo
    shfmt
    # nodePackages.prettier_d_slim
    rufo
    elmPackages.elm-format
    haskellPackages.hindent
    pgformatter
  ];

  xdg.configFile = { "prettier/.prettierrc" = { source = ./.prettierrc; }; };

  home.file =
    let prettierPluginDir = "${config.xdg.dataHome}/prettier/node_modules";
    in {
      "${prettierPluginDir}/plugin-plugin-svelte" = {
        source = pkgs.buildNpmPackage rec {
          pname = "prettier-plugin-svelte";
          version = "3.0.3";

          src = pkgs.fetchFromGitHub {
            owner = "sveltejs";
            repo = pname;
            rev = "v${version}";
            hash = "sha256-/kHHnzkWtlFR/SVyr98sEvjIBp4oA1a+V3Q3pc9iKIw=";
          };

          npmDepsHash = "sha256-r1AeUGs9LCKDyydppgVaJVtQf6w43nm4OfNqNNe4/p8=";
        };
      };

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
