{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.shellAliases = {
    cat = "bat";
  };

  home.packages = with pkgs; [ 
    bat
  ];
}
