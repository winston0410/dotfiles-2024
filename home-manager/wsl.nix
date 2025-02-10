{ inputs, lib, config, pkgs, ... }: {
  imports = [ ./common.nix ];

  home = {
    username = "hugosum";
    homeDirectory = "/home/hugosum";
  };
}
