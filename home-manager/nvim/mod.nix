{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [ 
    neovim
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
