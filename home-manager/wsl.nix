{ inputs, lib, config, pkgs, ... }: {
  imports = [ ./common.nix ];

  home.packages = with pkgs;
    [
      # No clipboard provider in WSL
      yank
    ];
  home = {
    username = "hugosum";
    homeDirectory = "/home/hugosum";
  };
}
