{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [ 
    bottom
  ];

  home.shellAliases = {
    top = "btm";
  };
}
