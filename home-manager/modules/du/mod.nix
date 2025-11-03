{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # make this mod to contain all utilities later 
  home.packages = with pkgs; [ 
    dua
    duf
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    detox
  ];
}
