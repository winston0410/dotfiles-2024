{ inputs, lib, config, pkgs, unstable, ... }: {
  imports = [ ./common.nix ./modules/docker/mod.nix ];

  nix.settings = { extra-trusted-users = "kghugo"; };

  home = {
    username = "kghugo";
    homeDirectory = "/home/kghugo";
  };
}
