{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [ 
    ripgrep
  ];

  home.shellAliases = {
    grep = "rg";
  };
}
