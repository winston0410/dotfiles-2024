{ inputs, unstable, lib, config, pkgs, ... }: {
  imports = [ ./lsp.nix ./formatter.nix ];

  home.packages = with pkgs; [
    (unstable.neovim.override {
      extraLuaPackages =
        (ps: with ps; [ luafilesystem jsregexp luarocks magick luassert ]);
    })
    (lua.override { version = "5.1.0"; })
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
