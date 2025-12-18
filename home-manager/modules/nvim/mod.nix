{ inputs, unstable, lib, config, pkgs, ... }: {

  imports = [ ./lsp.nix ./formatter.nix ./dap.nix ];

  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    extraLuaPackages = (ps:
      with ps; [
        luafilesystem
        jsregexp
        luassert
        # for sqlite.lua
        sqlite
        luv
        # for sops.nvim
        lyaml
      ]);
    extraPython3Packages = p:
      with p; [
        pynvim
        jupyter-client
        cairosvg
        pnglatex
        plotly
        kaleido
        pyperclip
        nbformat
        pillow
        requests
        websocket-client
      ];
    withRuby = false;
    withPython3 = true;
    withNodeJs = false;
  };

  home.packages = with pkgs;
    [
      # luajit
      lua5_1
      luarocks
      unstable.ast-grep
      unstable.codesnap
      # for sniprun compiler
      mono
      usql
      (pkgs.rustPlatform.buildRustPackage rec {
        pname = "sniprun";
        version = "1.3.18";

        src = pkgs.fetchFromGitHub {
          owner = "michaelb";
          repo = "sniprun";
          rev = "v${version}";
          sha256 = "sha256-2Q7Jnt7pVCuNne442KPh2cSjA6V6WSZkgUj99UpmnOM=";
        };

        cargoHash = "sha256-cu7wn75rQcwPLjFl4v05kVMsiCD0mAlIBt49mvIaPPU=";
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
      # difftastic
      unstable.difftastic
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
      nodejs_24
      tree-sitter
      fd
      bat
      chafa
      # render-markdown.nvim
      python313Packages.pylatexenc
      # kulala.nvim
      grpcurl
      websocat
      # presenterm
      unstable.presenterm
      # procs
      procs
      # molten.nvim
      python313Packages.jupytext
    ] ++ lib.optionals pkgs.stdenv.isDarwin [
      # img-clip.nvim
      pkgs.pngpaste
    ] ++ lib.optionals pkgs.stdenv.isLinux [
      # needed for treesitter, but only install in Linux, so we can still use MacOS's default gcc and won't conflict with it
      gcc14
      # vectorcode, cannot build on Darwin yet
      unstable.vectorcode
    ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    MANPAGER = "nvim +Man!";
    # using nvim as pager would lose the color
    # PAGER = "nvim";
    FCEDIT = "nvim --clean";
    MANWIDTH = 999;
  };
  home.shellAliases = {
    vi = "nvim --clean";
    vim =
      "nvim --cmd 'let g:disable_session = v:true' -u $XDG_CONFIG_HOME/nvim/minimal.lua";
    vimdiff = "nvim -d --cmd 'let g:disable_session = v:true'";
    nvimdiff = "nvim -d --cmd 'let g:disable_session = v:true'";
    k8s =
      "nvim --cmd  'let g:disable_session = v:true' -c 'lua require(\"kubectl\").toggle({ tab = false })'";
    diffview =
      "nvim --cmd  'let g:disable_session = v:true' --cmd 'let g:disable_autoformat = v:true' -c 'DiffviewOpen'";
  };

  xdg.configFile = {
    "nvim/init.lua" = { source = ./init.lua; };
    "nvim/minimal.lua" = { source = ./minimal.lua; };
    "nvim/.luarc.jsonc" = { source = ./.luarc.jsonc; };
    "nvim/ftplugin" = {
      source = ./ftplugin;
      recursive = true;
    };
    "nvim/after" = {
      source = ./after;
      recursive = true;
    };
    "nvim/assets" = {
      source = ./assets;
      recursive = true;
    };
    "nvim/lua" = {
      source = ./lua;
      recursive = true;
    };
    # Disable until we really need custom LSP config
    # "nvim/lsp" = { source = ./lsp; };
  };
}
