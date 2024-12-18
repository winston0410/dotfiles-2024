{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [ 
    lsd
  ];

  home.shellAliases = {
    ls = "lsd -a ";
  };

  xdg.configFile = {
    "lsd/config.yaml" = { source = ./config.yaml; };
  };
}
