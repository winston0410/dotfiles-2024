{ inputs, unstable, lib, config, pkgs, ... }: {

  imports = [ ./lsp.nix ./formatter.nix ./dap.nix ];

  home.packages = with pkgs; [
    figlet
    fastfetch
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
    # FIXME No idea why but override from lua package does not work and the version will be 5.2, we have to use lua5_1 instead
    # (lua.override { version = "5.1.0"; })
    lua5_1
    luarocks
    # needed for treesitter
    nodejs_22
    tree-sitter
    gcc14
    fd
    bat
    chafa
    # needed for snacks.nvim
    imagemagick
    mermaid-cli
    ghostscript_headless
    tectonic
    libqalculate
    # lilypond-suite
    fluidsynth
    soundfont-fluid
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
            nvim -c "BaleiaColorize" -c "lua Snacks.picker.lines()" -
        else
            nvim -c "lua Snacks.picker.grep()"
        fi
    }
  '';

  home.shellAliases = {
    vi = "nvim --clean";
    vim = "nvim -u $XDG_CONFIG_HOME/nvim/minimal.lua";
    oil = ''nvim -c "Oil"'';
    neogit = "nvim -c 'lua require(\"neogit\").open()'";
    k8s = "nvim -c 'lua require(\"kubectl\").toggle({ tab = false })'";
    nfd = "nvim -c 'lua Snacks.picker.files()'";
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
