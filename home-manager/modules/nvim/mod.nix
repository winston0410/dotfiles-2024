{ inputs, unstable, lib, config, pkgs, ... }: {
  imports = [ ./lsp.nix ./formatter.nix ];

  home.packages = with pkgs; [
    figlet
    fastfetch
    (unstable.neovim.override {
      extraLuaPackages =
        (ps: with ps; [ luafilesystem jsregexp luarocks magick luassert ]);
    })
    # FIXME No idea why but override from lua package does not work and the version will be 5.2, we have to use lua5_1 instead
    # (lua.override { version = "5.1.0"; })
    lua5_1
    luarocks
    # needed for treesitter
    tree-sitter
    gcc14
    nodejs_20
    # needed for fzf-lua
    fzf
    fd
    bat
    delta
    chafa
    # needed for image.nvim
    imagemagick
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.shellAliases = {
    vi = "nvim";
    vim = "nvim";
    vimdiff = "nvim -d";
    oil = ''nvim -c "Oil"'';
    neogit = "nvim -c 'lua require(\"neogit\").open()'";
    k8s = "nvim -c 'lua require(\"kubectl\").toggle({ tab = true })'";
    nrg =
      # NOTE using sed for removing ansi code
      # ''sed -r "s/\x1B\[[0-9;]*[mK]//g" | nvim -c "lua Snacks.picker.lines()"'';
      ''nvim -c "BaleiaColorize" -c "lua Snacks.picker.lines()"'';
    nfd = ''nvim -c "lua Snacks.picker.smart()"'';
  };

  xdg.configFile = {
    "nvim/init.lua" = {
      source = config.lib.file.mkOutOfStoreSymlink ./init.lua;
    };
    "nvim/.luarc.jsonc" = {
      source = config.lib.file.mkOutOfStoreSymlink ./.luarc.jsonc;
    };
    "nvim/ftplugin" = {
      source = config.lib.file.mkOutOfStoreSymlink ./ftplugin;
    };
    "nvim/plugins" = {
      source = config.lib.file.mkOutOfStoreSymlink ./plugins;
    };
  };
}
