{ inputs, lib, config, pkgs, ... }: {
  xdg.configFile = {
    "zk/config.toml" = { source = ./config.toml; };
    "zk/templates" = {
      source = ./templates;
      recursive = true;
    };
  };
}
