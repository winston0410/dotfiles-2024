{ inputs, unstable, lib, config, pkgs, ... }: {
  imports = [ ./lsp.nix ./formatter.nix ];

  home.packages = with pkgs; [
    unstable.neovim
    # needed for treesitter
    nodejs_20
    # needed for fzf-lua
    fzf
    fd
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
