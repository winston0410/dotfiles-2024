{ inputs, lib, config, pkgs, ... }: {
  home.file = { ".steam/steam/steam_dev.cfg" = { source = ./steam_dev.cfg; }; };
}
