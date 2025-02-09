{ inputs, unstable, lib, config, pkgs, ... }: {
  imports = [ ./lsp.nix ./formatter.nix ];

  home.packages = with pkgs; [
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
  };

  xdg.configFile = {
    "nvim/init.lua" = {
      source = config.lib.file.mkOutOfStoreSymlink ./init.lua;
    };
    "nvim/ftplugin" = {
      source = config.lib.file.mkOutOfStoreSymlink ./ftplugin;
    };
    "nvim/ftdetect" = {
      source = config.lib.file.mkOutOfStoreSymlink ./ftdetect;
    };
    "nvim/plugins" = {
      source = config.lib.file.mkOutOfStoreSymlink ./plugins;
    };
  };
}
