{ inputs, lib, config, pkgs, unstable, system, ... }: {
  imports = [
    ./modules/git/mod.nix
    ./modules/nvim/mod.nix
    ./modules/bat/mod.nix
    ./modules/lsd/mod.nix
    ./modules/ripgrep/mod.nix
    ./modules/zsh/mod.nix
    ./modules/font/mod.nix
    ./modules/xdg/mod.nix
    ./modules/sops/mod.nix
  ];
}
