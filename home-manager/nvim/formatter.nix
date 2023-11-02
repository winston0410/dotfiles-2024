{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [ 
    stylua
    nixfmt
    python39Packages.black
    rustfmt
    nodePackages.purty
    nodePackages.prettier
    yamlfmt
    taplo
    # nodePackages.prettier_d_slim
    rufo
    elmPackages.elm-format
    haskellPackages.hindent
  ];
}
