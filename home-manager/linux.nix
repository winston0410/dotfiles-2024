{ inputs, lib, config, pkgs, unstable, ... }: {
  imports = [
    ./common.nix
  ];

  nix.settings = {
    extra-trusted-users = "kghugo";
  };

  home = {
    username = "kghugo";
    homeDirectory = "/home/kghugo";
  };
}
