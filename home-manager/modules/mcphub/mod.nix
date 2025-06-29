{ inputs, lib, config, pkgs, ... }: {
  xdg.configFile = { "mcphub/servers.json" = { source = ./servers.json; }; };
}
