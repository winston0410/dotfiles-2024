{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [ 
    fzf
  ];

  xdg.configFile = {
    "fzf/fzf-color.sh" = { source = ./fzf-color.sh; };
  };
}
