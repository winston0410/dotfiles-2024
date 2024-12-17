{ inputs, unstable, lib, config, pkgs, ... }: {
  imports = [ ./lsp.nix ./formatter.nix ];

  home.packages = with pkgs; [
    # neovim-unwrapped does not work
    # (unstable.neovim-unwrapped.override { lua = (unstable.lua5_2.withPackages (ps: with ps; [ luafilesystem ])); })
    (unstable.neovim.override {
      extraLuaPackages = (ps: with ps; [ luafilesystem ]);
    })
    # needed for treesitter
    gcc14
    nodejs_20
    # needed for fzf-lua
    fzf
    fd
    bat
    delta
    chafa
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
    "nvim/init.lua" = { source = ./init.lua; };
    "nvim/ftplugin" = { source = ./ftplugin; };
    "nvim/ftdetect" = { source = ./ftdetect; };
    "nvim/plugins" = { source = ./plugins; };
  };
}
