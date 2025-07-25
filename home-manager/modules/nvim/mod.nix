{ inputs, unstable, lib, config, pkgs, ... }: {

  imports = [ ./lsp.nix ./formatter.nix ./dap.nix ];

  home.packages = with pkgs;
    [
      (unstable.neovim.override {
        extraLuaPackages = (ps:
          with ps; [
            luafilesystem
            jsregexp
            luassert
            # for sqlite.lua
            sqlite
            luv
          ]);
        withRuby = false;
        withPython3 = false;
        withNodeJs = false;
      })
      luajit
      luarocks
      unstable.codesnap
      (pkgs.rustPlatform.buildRustPackage rec {
        pname = "sniprun";
        version = "1.3.18";

        src = pkgs.fetchFromGitHub {
          owner = "michaelb";
          repo = "sniprun";
          rev = "v${version}";
          sha256 = "sha256-2Q7Jnt7pVCuNne442KPh2cSjA6V6WSZkgUj99UpmnOM=";
        };

        cargoHash = "sha256-saipf9HZkw1HdGpdhtHddBsKeSvb6jS7QbhOxjXvRzY=";
        doCheck = false;
      })
      (pkgs.buildNpmPackage rec {
        pname = "uuid";
        version = "11.1.0";

        src = pkgs.fetchFromGitHub {
          owner = "uuidjs";
          repo = "uuid";
          rev = "v${version}";
          hash = "sha256-WbltvUZphfdvnagVDrCxMvUavj1EKXQEoAXzQwvK88U=";
        };

        preBuild = ''
          ${pkgs.dos2unix}/bin/dos2unix ./scripts/build.sh
          # REF https://discourse.nixos.org/t/shebang-locations/28992/4
          # remove the shebang of the original script, as it is wrong and wouldn't work on NixOS
          ${pkgs.gnused}/bin/sed -i '1{/^#!/d;}' ./scripts/build.sh
        '';

        npmBuildFlags = [ "--" "--no-pack" ];

        npmDepsHash = "sha256-iWTuG/ExpAmz16g5wbhO7fiYH9TULTz8BRcjUwVM6r0=";
      })
      # needed for snacks.nvim
      imagemagick
      mermaid-cli
      ghostscript_headless
      tectonic
      libqalculate
      # lilypond-suite
      fluidsynth
      soundfont-fluid
    ] ++ [ # mcphub.nvim
      uv
    ] ++ [
      # needed for treesitter
      nodejs_22
      tree-sitter
      gcc14
      fd
      bat
      chafa
      # render-markdown.nvim
      python312Packages.pylatexenc
    ] ++ lib.optionals pkgs.stdenv.isDarwin [
      # img-clip.nvim
      pkgs.pngpaste
    ] ++ lib.optionals pkgs.stdenv.isLinux [
      # vectorcode, cannot build on Darwin yet
      unstable.vectorcode
    ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    MANPAGER = "nvim +Man!";
    FCEDIT = "nvim --clean";
    MANWIDTH = 999;
  };

  programs.zsh.initExtra = ''
    nrg() {
        if [[ -p /dev/stdin ]] || [ ! -t 0 ]; then
            nvim --cmd 'let g:enable_session = v:false' -c "BaleiaColorize" -c "lua Snacks.picker.lines()" -
        else
            nvim --cmd 'let g:enable_session = v:false' -c "lua Snacks.picker.grep()"
        fi
    }
  '';

  home.shellAliases = {
    vi = "nvim --clean";
    vim =
      "nvim --cmd 'let g:enable_session = v:false' -u $XDG_CONFIG_HOME/nvim/minimal.lua";
    neogit =
      "nvim --cmd 'let g:enable_session = v:false' -c 'lua require(\"neogit\").open()'";
    k8s =
      "nvim --cmd 'let g:enable_session = v:false' -c 'lua require(\"kubectl\").toggle({ tab = false })'";
  };

  xdg.configFile = {
    "nvim/init.lua" = { source = ./init.lua; };
    "nvim/minimal.lua" = { source = ./minimal.lua; };
    "nvim/.luarc.jsonc" = { source = ./.luarc.jsonc; };
    "nvim/ftplugin" = { source = ./ftplugin; };
    "nvim/after" = { source = ./after; };
    "nvim/assets" = { source = ./assets; };
    "nvim/lua" = { source = ./lua; };
    # Disable until we really need custom LSP config
    # "nvim/lsp" = { source = ./lsp; };
  };
}
