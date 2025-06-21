{ inputs, unstable, lib, config, pkgs, ... }: {

  imports = [ ./lsp.nix ./formatter.nix ./dap.nix ];

  home.packages = with pkgs;
    [
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
      lua5_1
      luarocks
      # needed for snacks.nvim
      imagemagick
      mermaid-cli
      ghostscript_headless
      tectonic
      libqalculate
      # lilypond-suite
      fluidsynth
      soundfont-fluid
    ] ++ [
      # needed for treesitter
      nodejs_22
      tree-sitter
      gcc14
      fd
      bat
      chafa
    ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    MANPAGER = "nvim +Man!";
    FCEDIT = "nvim --clean";
    MANWIDTH = 999;
  };

  programs.zsh.initContent = ''
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
