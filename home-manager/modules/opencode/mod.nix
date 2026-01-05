{ inputs, lib, config, pkgs, ... }: {
  xdg.configFile = {
    "opencode/config.jsonc" = { source = ./config.jsonc; };
  };
}
