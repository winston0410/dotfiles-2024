{ inputs, lib, config, pkgs, unstable, ... }: {
  imports = [
    ./common.nix
  ];

  nix.settings = {
    extra-trusted-users = "hugosum";
    builders-use-substitutes = true;
  };

  home = {
    username = "hugosum";
    homeDirectory = "/Users/hugosum";
  };
}
