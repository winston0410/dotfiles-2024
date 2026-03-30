{ inputs, lib, config, pkgs, ... }: {
  xdg.configFile = {
    "ghostty/config.ghostty" = { source = ./config.ghostty; };
  };
}
