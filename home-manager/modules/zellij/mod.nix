{ inputs, lib, config, pkgs,  unstable, ... }: {
  xdg.configFile = {
    "zellij/config.kdl" = { source = ./config.kdl; };
  };
}
