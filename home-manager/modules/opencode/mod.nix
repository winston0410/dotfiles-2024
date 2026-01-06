{ inputs, lib, config, pkgs, ... }: {
  xdg.configFile = {
    "opencode/opencode.jsonc" = { source = ./opencode.jsonc; };
  };
}
